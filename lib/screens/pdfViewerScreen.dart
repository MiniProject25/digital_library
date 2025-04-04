import 'dart:io';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

/// A screen that displays a PDF file using Syncfusion's PDF viewer.
/// Allows text selection and displays the PDF with a simple app bar.
class pdfViewerScreen extends StatefulWidget {
  final String filePath; // Local file path to the PDF
  final String fileName; // Name to display on the AppBar

  const pdfViewerScreen({
    super.key,
    required this.filePath,
    required this.fileName,
  });

  @override
  State<pdfViewerScreen> createState() => _pdfViewerScreenState();
}

class _pdfViewerScreenState extends State<pdfViewerScreen> {
  /// Key used to control the PDF viewer (e.g., for programmatic navigation)
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();

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
      ),
    );
  }
}
