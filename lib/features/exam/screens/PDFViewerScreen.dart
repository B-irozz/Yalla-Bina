import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:yallabina/core/constant/colors.dart';

class PDFViewerScreen extends StatelessWidget {
  final String subject;
  final String pdfPath;

  const PDFViewerScreen(
      {super.key, required this.subject, required this.pdfPath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary.withOpacity(0.9),
        title: Text(
          subject,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: 'Cairo',
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.background.withOpacity(0.9),
              AppColors.primary.withOpacity(0.2),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: PDFView(
          filePath: pdfPath,
          enableSwipe: true,
          swipeHorizontal: false,
          autoSpacing: true,
          pageFling: true,
          onError: (error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("خطأ في تحميل الملف: $error")),
            );
          },
          onPageError: (page, error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("خطأ في الصفحة $page: $error")),
            );
          },
        ),
      ),
    );
  }
}
