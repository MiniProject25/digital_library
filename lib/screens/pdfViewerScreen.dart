import 'dart:io';
import 'package:digital_library/services/BookServices.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../models/bookModel.dart';

/// A screen that displays a PDF file using Syncfusion's PDF viewer.
/// Allows text selection and displays the PDF with a simple app bar.
class pdfViewerScreen extends StatefulWidget {
  final String filePath; // Local file path to the PDF
  final String fileName; // Name to display on the AppBar
  final Book book;
  final int currentPage;

  const pdfViewerScreen({
    super.key,
    required this.currentPage,
    required this.book,
    required this.filePath,
    required this.fileName,
  });

  @override
  State<pdfViewerScreen> createState() => _pdfViewerScreenState();
}

class _pdfViewerScreenState extends State<pdfViewerScreen> {
  /// Key used to control the PDF viewer (e.g., for programmatic navigation)
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  bookServices bService = bookServices();

  void _onPageChanged(PdfPageChangedDetails details) {
    print("Called onPageChanged!");
    bService.saveLastReadPage(widget.book.id, details.newPageNumber);
    print("Exiting onPageChanged!");
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.fileName),
      ),

      /// Displays the PDF from a local file and allows text selection
      body: SfPdfViewer.file(
        File(widget.filePath),
        key: _pdfViewerKey,
        enableTextSelection: true,
        onPageChanged: _onPageChanged,
        initialPageNumber: widget.currentPage,
      ),
    );
  }
}
