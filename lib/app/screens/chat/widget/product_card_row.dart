import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ovowpp/app/components/snack_bar/show_custom_snackbar.dart';
import 'package:ovowpp/core/helper/date_converter.dart';
import 'package:ovowpp/core/translations/strings_enum.dart';
import 'package:ovowpp/core/utils/app_status.dart';
import 'package:ovowpp/core/utils/my_color.dart';
import 'package:ovowpp/data/model/chat/chat_data_response_model.dart';

/// Accepts "https://x", "http://x" or a bare host like "shop.com/p"; anything
/// else (or an empty value) is treated as no usable URL.
Uri? productValidUri(String? raw) {
  if (raw == null || raw.trim().isEmpty) return null;
  final text = raw.trim();
  final candidate = text.startsWith('http://') || text.startsWith('https://') ? text : 'https://$text';
  final uri = Uri.tryParse(candidate);
  if (uri == null || (uri.scheme != 'http' && uri.scheme != 'https') || uri.host.isEmpty) return null;
  return uri;
}

/// One horizontal row of product cards for consecutive product messages from
/// the same side. [messages] is ordered oldest first.
class ProductCardRow extends StatelessWidget {
  const ProductCardRow({super.key, required this.messages, required this.isSender});

  final List<MessagesData> messages;
  final bool isSender;

  @override
  Widget build(BuildContext context) {
    if (messages.isEmpty) return const SizedBox.shrink();
    final newest = messages.last;
    final maxRowWidth = MediaQuery.of(context).size.width * 0.8;

    return Align(
      alignment: isSender ? AlignmentDirectional.centerEnd : AlignmentDirectional.centerStart,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 12.w),
        child: Column(
          crossAxisAlignment: isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: maxRowWidth,
              height: 278.h,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: messages.length,
                separatorBuilder: (ctx, idx) => SizedBox(width: 8.w),
                itemBuilder: (_, i) => _ProductCard(data: messages[i].productData!),
              ),
            ),
            SizedBox(height: 2.h),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  DateConverter.convertUtcToLocalTime(newest.createdAt.toString()),
                  style: TextStyle(fontSize: 11.sp, color: MyColor.getBodyTextColor()),
                ),
                if (isSender) ...[
                  SizedBox(width: 4.w),
                  Icon(
                    newest.status == AppStatus.READ || newest.status == AppStatus.DELIVERED
                        ? Icons.done_all
                        : newest.status == AppStatus.FAILED
                        ? Icons.refresh
                        : Icons.done,
                    size: 16.sp,
                    color: newest.status == AppStatus.READ
                        ? MyColor.getPrimaryColor()
                        : newest.status == AppStatus.FAILED
                        ? MyColor.pendingColor
                        : MyColor.getBodyTextColor(),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({required this.data});

  final ProductCardData data;

  @override
  Widget build(BuildContext context) {
    final imageUri = productValidUri(data.imageUrl);
    final linkUri = productValidUri(data.url);
    final title = data.title ?? data.bodyText ?? '';

    return Container(
      width: 170.w,
      decoration: BoxDecoration(
        color: MyColor.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: MyColor.chatChipBg),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 120.h,
            child: imageUri == null
                ? _imagePlaceholder()
                : Image.network(
                    imageUri.toString(),
                    fit: BoxFit.cover,
                    errorBuilder: (ctx, err, stack) => _imagePlaceholder(),
                    loadingBuilder: (context, child, progress) =>
                        progress == null ? child : _imagePlaceholder(),
                  ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(10.w, 8.h, 10.w, 0),
            child: Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700, color: MyColor.getHeadingTextColor()),
            ),
          ),
          if (data.bodyText != null && data.bodyText != title)
            Padding(
              padding: EdgeInsets.fromLTRB(10.w, 4.h, 10.w, 0),
              child: Text(
                data.bodyText!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 11.sp, color: MyColor.getBodyTextColor()),
              ),
            ),
          const Spacer(),
          Padding(
            padding: EdgeInsets.fromLTRB(10.w, 8.h, 10.w, 10.h),
            child: SizedBox(
              height: 34.h,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: MyColor.chatBannerButton,
                  disabledBackgroundColor: MyColor.chatChipBg,
                  foregroundColor: MyColor.white,
                  elevation: 0,
                  padding: EdgeInsets.symmetric(horizontal: 6.w),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                ),
                onPressed: linkUri == null ? null : () => _open(linkUri),
                child: Text(
                  (data.buttonText ?? '').isNotEmpty ? data.buttonText! : Strings.orderNow.tr,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _imagePlaceholder() {
    return Container(
      color: MyColor.chatChipBg,
      alignment: Alignment.center,
      child: Icon(Icons.image_outlined, size: 36.sp, color: MyColor.chatHeaderGreen),
    );
  }

  Future<void> _open(Uri uri) async {
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        CustomSnackBar.error(errorList: [Strings.couldNotOpenUrl.tr]);
      }
    } catch (_) {
      CustomSnackBar.error(errorList: [Strings.invalidUrl.tr]);
    }
  }
}
