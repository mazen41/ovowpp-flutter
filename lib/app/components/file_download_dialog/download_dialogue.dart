import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:ovowpp/core/utils/util_exporter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ovowpp/app/components/snack_bar/show_custom_snackbar.dart';

class DownloadingDialog extends StatefulWidget {
  final String url;
  final String fileName;
  final bool isPdf;
  final bool isImage;

  const DownloadingDialog({
    super.key,
    required this.isImage,
    required this.url,
    this.isPdf = true,
    required this.fileName,
  });

  @override
  DownloadingDialogState createState() => DownloadingDialogState();
}

class DownloadingDialogState extends State<DownloadingDialog> {
  int _total = 0, _received = 0;
  late http.StreamedResponse _response;
  File? image;
  final List<int> _bytes = [];

  Future<void> _downloadFile() async {
    _response = await http.Client().send(http.Request('GET', Uri.parse(widget.url)));
    _total = _response.contentLength ?? 0;

    _response.stream
        .listen((value) {
          setState(() {
            _bytes.addAll(value);
            _received += value.length;
          });
        })
        .onDone(() async {
          final file = File('${(await getApplicationDocumentsDirectory()).path}/qr_code.png');
          File savedFile = await file.writeAsBytes(_bytes);
          Get.back();
          CustomSnackBar.success(successList: ['${MyStrings.fileDownloadedSuccess}: ${savedFile.path.toString()}']);
          setState(() {
            image = file;
          });
        });
  }

  Future<void> saveImage() async {
    var response = await Dio().get(widget.url, options: Options(responseType: ResponseType.bytes));
    final result = await ImageGallerySaverPlus.saveImage(
      Uint8List.fromList(response.data),
      quality: 60,
      name: widget.fileName,
    );

    try {
      dynamic value = result['isSuccess'];
      if (value.toString() == 'true') {
        Get.back();
        CustomSnackBar.success(successList: [(MyStrings.fileDownloadedSuccess)]);
      } else {
        Get.back();
        dynamic errorMessage = result['errorMessage'];
        CustomSnackBar.error(errorList: [errorMessage]);
      }
    } catch (e) {
      if (kDebugMode) {
        printX(e.toString());
      }
      Get.back();
      CustomSnackBar.error(errorList: [MyStrings.requestFail]);
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.isImage) {
      saveImage();
    } else {
      _downloadFile();
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return AlertDialog(
      backgroundColor: theme.cardColor,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: SpinKitThreeBounce(color: MyColor.getPrimaryColor(), size: 20.0),
            ),
          ),
          Visibility(
            visible: !widget.isImage,
            child: Column(
              children: [
                const SizedBox(height: 20),
                Text(
                  '${MyStrings.downloading.tr} ${_received ~/ 1024}/${_total ~/ 1024} ${'KB'.tr}',
                  style: theme.textTheme.labelMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
