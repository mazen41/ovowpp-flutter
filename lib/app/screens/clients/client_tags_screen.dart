import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ovowpp/app/components/annotated_region/annotated_region_widget.dart';
import 'package:ovowpp/app/components/app-bar/custom_app_bar.dart';
import 'package:ovowpp/app/components/custom_loader/custom_loader.dart';
import 'package:ovowpp/app/components/no_data.dart';
import 'package:ovowpp/app/components/snack_bar/show_custom_snackbar.dart';
import 'package:ovowpp/core/utils/app_status.dart';
import 'package:ovowpp/core/utils/dimensions.dart';
import 'package:ovowpp/core/utils/my_color.dart';
import 'package:ovowpp/core/utils/text_style.dart';
import 'package:ovowpp/core/utils/url_container.dart';
import 'package:ovowpp/data/model/global/response_model/response_model.dart';
import 'package:ovowpp/data/services/api_service.dart';

class ClientTagsScreen extends StatefulWidget {
  const ClientTagsScreen({super.key});

  @override
  State<ClientTagsScreen> createState() => _ClientTagsScreenState();
}

class _ClientTagsScreenState extends State<ClientTagsScreen> {
  bool _loading = true;
  List<dynamic> _tags = [];

  // Predefined color palette for tags
  static const List<Color> _palette = [
    Color(0xFF6366F1), // Indigo
    Color(0xFF10B981), // Emerald
    Color(0xFFF59E0B), // Amber
    Color(0xFFEF4444), // Red
    Color(0xFF3B82F6), // Blue
    Color(0xFF8B5CF6), // Violet
    Color(0xFFEC4899), // Pink
    Color(0xFF14B8A6), // Teal
    Color(0xFFF97316), // Orange
    Color(0xFF64748B), // Slate
  ];

  Color _selectedColor = const Color(0xFF6366F1);

  @override
  void initState() {
    super.initState();
    _loadTags();
  }

  Future<void> _loadTags() async {
    setState(() => _loading = true);
    try {
      final res = await ApiService.getRequest(
        '${UrlContainer.baseUrl}${UrlContainer.allContactTagListDataEndPoint}',
      );
      if (res.statusCode == 200) {
        final data = res.responseJson['data'];
        _tags = (data is List ? data : (data as Map?)?['data'] ?? []) as List<dynamic>;
      }
    } catch (_) {}
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegionWidget(
      child: Scaffold(
        backgroundColor: MyColor.white,
        appBar: CustomAppBar(
          title: 'Manage Tags',
          bgColor: MyColor.white,
          elevation: 0,
        ),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: MyColor.getPrimaryColor(),
          icon: const Icon(Icons.add, color: Colors.white),
          label: const Text('New Tag', style: TextStyle(color: Colors.white)),
          onPressed: () => _showTagDialog(),
        ),
        body: _loading
            ? const Center(child: CustomLoader())
            : _tags.isEmpty
                ? const NoDataWidget()
                : RefreshIndicator(
                    onRefresh: _loadTags,
                    child: ListView.separated(
                      padding: EdgeInsets.only(
                        top: 12.h,
                        bottom: 100.h,
                        left: 16.w,
                        right: 16.w,
                      ),
                      itemCount: _tags.length,
                      separatorBuilder: (_, __) =>
                          Divider(height: 1, color: MyColor.lightBorder.withAlpha(60)),
                      itemBuilder: (context, index) {
                        final tag = _tags[index];
                        final color = _hexToColor(tag['color'] as String?) ?? MyColor.getPrimaryColor();
                        return _TagTile(
                          tag: tag,
                          color: color,
                          onEdit: () => _showTagDialog(tag: tag),
                          onDelete: () => _deleteTag(tag),
                        );
                      },
                    ),
                  ),
      ),
    );
  }

  Future<void> _showTagDialog({dynamic tag}) async {
    final isEdit = tag != null;
    final nameController = TextEditingController(text: isEdit ? (tag['name'] ?? '') : '');
    _selectedColor = isEdit
        ? (_hexToColor(tag['color'] as String?) ?? _palette.first)
        : _palette.first;

    await showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialog) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
          title: Text(
            isEdit ? 'Edit Tag' : 'New Tag',
            style: MyTextStyle.heading16W600(),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: nameController,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: 'Tag name',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
                ),
              ),
              SizedBox(height: 16.h),
              Text('Color', style: MyTextStyle.subHeading14W500().copyWith(color: MyColor.getBodyTextColor())),
              SizedBox(height: 8.h),
              Wrap(
                spacing: 10.w,
                runSpacing: 8.h,
                children: _palette
                    .map((c) => GestureDetector(
                          onTap: () => setDialog(() => _selectedColor = c),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 120),
                            width: 30.w,
                            height: 30.w,
                            decoration: BoxDecoration(
                              color: c,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: _selectedColor == c ? Colors.black87 : Colors.transparent,
                                width: 2.5,
                              ),
                              boxShadow: _selectedColor == c
                                  ? [BoxShadow(color: c.withAlpha(120), blurRadius: 6)]
                                  : [],
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text('Cancel', style: TextStyle(color: MyColor.getBodyTextColor())),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: MyColor.getPrimaryColor(),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
              ),
              onPressed: () async {
                final name = nameController.text.trim();
                if (name.isEmpty) {
                  CustomSnackBar.error(errorList: ['Tag name cannot be empty']);
                  return;
                }
                Navigator.pop(ctx);
                await _saveTag(
                  name: name,
                  color: '#${_selectedColor.value.toRadixString(16).substring(2)}',
                  id: isEdit ? tag['id']?.toString() : null,
                );
              },
              child: Text(isEdit ? 'Update' : 'Create',
                  style: const TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
    nameController.dispose();
  }

  Future<void> _saveTag({required String name, required String color, String? id}) async {
    final isEdit = id != null;
    final url = isEdit
        ? '${UrlContainer.baseUrl}${UrlContainer.updateContactTagUrl}$id'
        : '${UrlContainer.baseUrl}${UrlContainer.createContactTagUrl}';
    try {
      final res = await ApiService.postRequest(url, {'name': name, 'color': color});
      if (res.statusCode == 200 &&
          (res.responseJson['status'] as String?)?.toLowerCase() == AppStatus.success) {
        CustomSnackBar.success(successList: [isEdit ? 'Tag updated' : 'Tag created']);
        await _loadTags();
      } else {
        CustomSnackBar.error(errorList: [(res.responseJson['message'] as List?)?.first?.toString() ?? 'Failed']);
      }
    } catch (_) {
      CustomSnackBar.error(errorList: ['Something went wrong']);
    }
  }

  Future<void> _deleteTag(dynamic tag) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        title: Text('Delete Tag?', style: MyTextStyle.heading16W600()),
        content: Text(
          'Delete "${tag['name'] ?? 'tag'}"? This will remove the tag from all contacts.',
          style: MyTextStyle.subHeading14W400().copyWith(color: MyColor.getBodyTextColor()),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('Cancel', style: TextStyle(color: MyColor.getBodyTextColor())),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text('Delete', style: TextStyle(color: MyColor.getErrorColor())),
          ),
        ],
      ),
    );

    if (confirm != true) return;
    try {
      final url = '${UrlContainer.baseUrl}${UrlContainer.deleteContactTagUrl}${tag['id']}';
      final res = await ApiService.postRequest(url, {});
      if (res.statusCode == 200 &&
          (res.responseJson['status'] as String?)?.toLowerCase() == AppStatus.success) {
        CustomSnackBar.success(successList: ['Tag deleted']);
        await _loadTags();
      } else {
        CustomSnackBar.error(errorList: ['Failed to delete tag']);
      }
    } catch (_) {
      CustomSnackBar.error(errorList: ['Something went wrong']);
    }
  }

  Color? _hexToColor(String? hex) {
    if (hex == null || hex.isEmpty) return null;
    final cleaned = hex.replaceAll('#', '');
    if (cleaned.length == 6) return Color(int.parse('FF$cleaned', radix: 16));
    return null;
  }
}

class _TagTile extends StatelessWidget {
  final dynamic tag;
  final Color color;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _TagTile({
    required this.tag,
    required this.color,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final count = tag['contacts_count']?.toString() ?? tag['count']?.toString() ?? '0';
    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 4.h),
      leading: CircleAvatar(
        radius: 20.r,
        backgroundColor: color.withAlpha(40),
        child: Icon(Icons.label_rounded, color: color, size: 20.sp),
      ),
      title: Text(
        tag['name']?.toString() ?? '',
        style: MyTextStyle.subHeading14W500().copyWith(color: MyColor.usdTextColor),
      ),
      subtitle: Text(
        '$count contacts',
        style: MyTextStyle.subHeading12W400().copyWith(color: MyColor.getBodyTextColor()),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.edit_outlined, color: MyColor.getPrimaryColor(), size: 20.sp),
            onPressed: onEdit,
          ),
          IconButton(
            icon: Icon(Icons.delete_outline_rounded, color: MyColor.getErrorColor(), size: 20.sp),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}
