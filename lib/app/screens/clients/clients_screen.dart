import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ovowpp/app/components/annotated_region/annotated_region_widget.dart';
import 'package:ovowpp/app/components/app-bar/custom_app_bar.dart';
import 'package:ovowpp/app/components/avatar/alphabet_avatar.dart';
import 'package:ovowpp/app/components/custom_loader/custom_loader.dart';
import 'package:ovowpp/app/components/image/my_network_image_widget.dart';
import 'package:ovowpp/app/components/no_data.dart';
import 'package:ovowpp/app/components/snack_bar/show_custom_snackbar.dart';
import 'package:ovowpp/core/route/route.dart';
import 'package:ovowpp/core/utils/app_permission.dart';
import 'package:ovowpp/core/utils/app_style.dart';
import 'package:ovowpp/core/utils/dimensions.dart';
import 'package:ovowpp/core/utils/my_color.dart';
import 'package:ovowpp/core/utils/text_style.dart';
import 'package:ovowpp/core/utils/url_container.dart';
import 'package:ovowpp/core/utils/util.dart';
import 'package:ovowpp/data/model/global/response_model/response_model.dart';
import 'package:ovowpp/data/services/api_service.dart';
import 'package:ovowpp/data/services/shared_pref_service.dart';

class ClientsScreen extends StatefulWidget {
  const ClientsScreen({super.key});

  @override
  State<ClientsScreen> createState() => _ClientsScreenState();
}

class _ClientsScreenState extends State<ClientsScreen> {
  bool _loading = true;
  List<dynamic> _clients = [];
  List<dynamic> _filtered = [];
  List<dynamic> _allTags = [];
  String _searchQuery = '';
  String? _selectedTagId;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => _loading = true);
    try {
      final clientRes = await ApiService.getRequest(
        '${UrlContainer.baseUrl}${UrlContainer.contactListUrl}',
      );
      final tagRes = await ApiService.getRequest(
        '${UrlContainer.baseUrl}${UrlContainer.allContactTagListDataEndPoint}',
      );

      if (clientRes.statusCode == 200) {
        final data = clientRes.responseJson['data'];
        final rawList = (data is Map ? data['data'] : data) as List<dynamic>? ?? [];
        _clients = rawList;
        _filtered = rawList;
      }
      if (tagRes.statusCode == 200) {
        final tagData = tagRes.responseJson['data'];
        _allTags = (tagData is List ? tagData : (tagData as Map?)?['data'] ?? []) as List<dynamic>;
      }
    } catch (e) {
      // ignore
    } finally {
      setState(() => _loading = false);
    }
  }

  void _applyFilters() {
    setState(() {
      _filtered = _clients.where((c) {
        final name = '${c['firstname'] ?? ''} ${c['lastname'] ?? ''}'.toLowerCase();
        final mobile = (c['mobile'] ?? '').toString().toLowerCase();
        final matchesSearch =
            _searchQuery.isEmpty || name.contains(_searchQuery) || mobile.contains(_searchQuery);

        final tags = (c['tags'] as List<dynamic>?) ?? [];
        final matchesTag = _selectedTagId == null ||
            tags.any((t) => t['id'].toString() == _selectedTagId);

        return matchesSearch && matchesTag;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegionWidget(
      child: Scaffold(
        backgroundColor: MyColor.white,
        appBar: CustomAppBar(
          title: 'Clients',
          bgColor: MyColor.white,
          elevation: 0,
          action: [
            IconButton(
              icon: Icon(Icons.label_outlined, color: MyColor.getPrimaryColor()),
              onPressed: () => Get.toNamed(RouteHelper.clientTagsScreen)?.then((_) => _loadData()),
              tooltip: 'Manage Tags',
            ),
          ],
        ),
        body: Column(
          children: [
            _buildSearchAndFilter(),
            Expanded(
              child: _loading
                  ? const Center(child: CustomLoader())
                  : _filtered.isEmpty
                      ? const NoDataWidget()
                      : RefreshIndicator(
                          onRefresh: _loadData,
                          child: ListView.separated(
                            padding: EdgeInsets.symmetric(vertical: 8.h),
                            itemCount: _filtered.length,
                            separatorBuilder: (_, __) =>
                                Divider(height: 1, color: MyColor.lightBorder.withAlpha(80)),
                            itemBuilder: (context, index) => _buildClientTile(_filtered[index]),
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchAndFilter() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          child: TextField(
            controller: _searchController,
            onChanged: (v) {
              _searchQuery = v.toLowerCase();
              _applyFilters();
            },
            decoration: InputDecoration(
              hintText: 'Search clients…',
              hintStyle: MyTextStyle.subHeading14W400().copyWith(color: MyColor.getBodyTextColor()),
              prefixIcon: Icon(Icons.search_rounded, color: MyColor.getBodyTextColor()),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        _searchController.clear();
                        _searchQuery = '';
                        _applyFilters();
                      },
                    )
                  : null,
              filled: true,
              fillColor: MyColor.lightBorder.withAlpha(30),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            ),
          ),
        ),
        if (_allTags.isNotEmpty)
          SizedBox(
            height: 36.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              itemCount: _allTags.length + 1,
              separatorBuilder: (_, __) => SizedBox(width: 8.w),
              itemBuilder: (context, i) {
                if (i == 0) {
                  final isAll = _selectedTagId == null;
                  return _tagChip(label: 'All', selected: isAll, onTap: () {
                    setState(() => _selectedTagId = null);
                    _applyFilters();
                  });
                }
                final tag = _allTags[i - 1];
                final isSelected = _selectedTagId == tag['id'].toString();
                return _tagChip(
                  label: tag['name'] ?? 'Tag',
                  selected: isSelected,
                  color: _hexToColor(tag['color'] as String?),
                  onTap: () {
                    setState(() =>
                        _selectedTagId = isSelected ? null : tag['id'].toString());
                    _applyFilters();
                  },
                );
              },
            ),
          ),
        SizedBox(height: 8.h),
      ],
    );
  }

  Widget _tagChip({
    required String label,
    required bool selected,
    Color? color,
    required VoidCallback onTap,
  }) {
    final chipColor = color ?? MyColor.getPrimaryColor();
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: selected ? chipColor : chipColor.withAlpha(25),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: chipColor.withAlpha(80)),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : chipColor,
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildClientTile(dynamic client) {
    final tags = (client['tags'] as List<dynamic>?) ?? [];
    final name = '${client['firstname'] ?? ''} ${client['lastname'] ?? ''}'.trim();
    final mobile = client['mobile']?.toString() ?? '';
    final imageSrc = client['imageSrc']?.toString();
    final conversationId = client['conversation_id']?.toString();

    return InkWell(
      onTap: () {
        if (conversationId != null && conversationId.isNotEmpty) {
          if (MyUtils.checkPermission(AppPermission.sendMessage)) {
            Get.toNamed(RouteHelper.chatScreen, arguments: [conversationId, '']);
          } else {
            CustomSnackBar.error(errorList: ['Permission denied']);
          }
        }
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Row(
          children: [
            // Avatar
            imageSrc != null && imageSrc.isNotEmpty
                ? MyNetworkImageWidget(
                    imageUrl: imageSrc,
                    height: 48.w,
                    width: 48.w,
                    radius: 100,
                    boxFit: BoxFit.cover,
                  )
                : AlphabetAvatar(
                    firstname: client['firstname'] ?? '',
                    lastName: client['lastname'] ?? '',
                    size: 48.w,
                  ),
            SizedBox(width: 12.w),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name.isNotEmpty ? name : '+$mobile',
                    style: MyTextStyle.heading16W600().copyWith(color: MyColor.usdTextColor),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (mobile.isNotEmpty) ...[
                    SizedBox(height: 2.h),
                    Text(
                      '+$mobile',
                      style: MyTextStyle.subHeading14W400()
                          .copyWith(color: MyColor.getBodyTextColor()),
                    ),
                  ],
                  if (tags.isNotEmpty) ...[
                    SizedBox(height: 6.h),
                    Wrap(
                      spacing: 6.w,
                      runSpacing: 4.h,
                      children: tags
                          .take(3)
                          .map<Widget>((t) => _tagChip(
                                label: t['name']?.toString() ?? '',
                                selected: false,
                                color: _hexToColor(t['color']?.toString()),
                                onTap: () {},
                              ))
                          .toList(),
                    ),
                  ],
                ],
              ),
            ),
            // Chevron
            if (conversationId != null && conversationId.isNotEmpty)
              Icon(Icons.chevron_right_rounded, color: MyColor.getBodyTextColor(), size: 20.sp),
          ],
        ),
      ),
    );
  }

  Color? _hexToColor(String? hex) {
    if (hex == null || hex.isEmpty) return null;
    final cleaned = hex.replaceAll('#', '');
    if (cleaned.length == 6) {
      return Color(int.parse('FF$cleaned', radix: 16));
    }
    return null;
  }
}
