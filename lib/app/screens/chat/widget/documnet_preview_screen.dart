import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:http/http.dart' as http;
import 'package:ovowpp/core/utils/util.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ovowpp/app/components/card/my_custom_scaffold.dart';

class DocumentPreviewScreen extends StatefulWidget {
  final String pdfUrl;
  final String title;

  const DocumentPreviewScreen({super.key, required this.pdfUrl, this.title = 'PDF Viewer'});

  @override
  State<DocumentPreviewScreen> createState() => _DocumentPreviewScreenState();
}

class _DocumentPreviewScreenState extends State<DocumentPreviewScreen> {
  final Completer<PDFViewController> _controller = Completer<PDFViewController>();
  String? localPath;
  bool isLoading = true;
  bool hasError = false;
  String errorMessage = '';
  int currentPage = 0;
  int totalPages = 0;

  @override
  void initState() {
    super.initState();
    downloadAndSavePDF();
  }

  Future<void> downloadAndSavePDF() async {
    try {
      setState(() {
        isLoading = true;
        hasError = false;
      });

      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/temp_pdf.pdf');

      final response = await http.get(Uri.parse(widget.pdfUrl));

      if (response.statusCode == 200) {
        await file.writeAsBytes(response.bodyBytes);
        setState(() {
          localPath = file.path;
          isLoading = false;
        });
      } else {
        throw Exception('Failed to download PDF: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        hasError = true;
        errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MyCustomScaffold(
      pageTitle: widget.title,
      actionButton: [
        if (!isLoading && !hasError && totalPages > 0)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Center(
              child: Text(
                '${currentPage + 1} / $totalPages',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
          ),
      ],
      body: _buildBody(),
      floatingActionButton: _buildBottomNavigation(),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading PDF...', style: TextStyle(fontSize: 16)),
          ],
        ),
      );
    }

    if (hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            const Text('Failed to load PDF', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                errorMessage,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: downloadAndSavePDF,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (localPath == null) {
      return const Center(child: Text('No PDF to display'));
    }

    return PDFView(
      filePath: localPath!,
      enableSwipe: true,
      swipeHorizontal: false,
      autoSpacing: true,
      pageFling: true,
      pageSnap: true,
      defaultPage: currentPage,
      fitPolicy: FitPolicy.BOTH,
      preventLinkNavigation: false,
      onRender: (pages) {
        setState(() {
          totalPages = pages ?? 0;
        });
      },
      onViewCreated: (PDFViewController pdfViewController) {
        _controller.complete(pdfViewController);
      },
      onLinkHandler: (String? uri) {
        // Handle link clicks if needed
      },
      onPageChanged: (int? page, int? total) {
        setState(() {
          currentPage = page ?? 0;
          totalPages = total ?? 0;
        });
      },
      onError: (error) {
        setState(() {
          hasError = true;
          errorMessage = error.toString();
        });
      },
      onPageError: (page, error) {
        printX('Page $page error: $error');
      },
    );
  }

  Widget? _buildBottomNavigation() {
    if (isLoading || hasError || totalPages <= 1) {
      return null;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha((0.3 * 255).round()),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            onPressed: currentPage > 0 ? _goToPreviousPage : null,
            icon: const Icon(Icons.arrow_back_ios),
            tooltip: 'Previous Page',
          ),
          Expanded(
            child: Slider(
              value: currentPage.toDouble(),
              min: 0,
              max: (totalPages - 1).toDouble(),
              divisions: totalPages > 1 ? totalPages - 1 : 1,
              onChanged: (value) {
                _goToPage(value.round());
              },
            ),
          ),
          IconButton(
            onPressed: currentPage < totalPages - 1 ? _goToNextPage : null,
            icon: const Icon(Icons.arrow_forward_ios),
            tooltip: 'Next Page',
          ),
        ],
      ),
    );
  }

  Future<void> _goToPreviousPage() async {
    final controller = await _controller.future;
    if (currentPage > 0) {
      await controller.setPage(currentPage - 1);
    }
  }

  Future<void> _goToNextPage() async {
    final controller = await _controller.future;
    if (currentPage < totalPages - 1) {
      await controller.setPage(currentPage + 1);
    }
  }

  Future<void> _goToPage(int page) async {
    final controller = await _controller.future;
    await controller.setPage(page);
  }

  @override
  void dispose() {
    // Clean up the temporary file
    if (localPath != null) {
      final file = File(localPath!);
      if (file.existsSync()) {
        file.deleteSync();
      }
    }
    super.dispose();
  }
}
