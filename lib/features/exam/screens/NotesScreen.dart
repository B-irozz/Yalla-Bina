import 'package:flutter/material.dart';
import 'package:yallabina/core/constant/colors.dart';
import 'package:yallabina/features/exam/screens/PDFViewerScreen.dart';
// import 'pdf_viewer_screen.dart'; // استيراد صفحة عارض الـ PDF

class NotesScreen extends StatelessWidget {
  const NotesScreen({super.key});

  // قائمة المذكرات كمثال
  final List<Map<String, String>> notes = const [
    {"subject": "الرياضيات", "pdfPath": "assets/pdfs/AI for midterm.pdf"},
    {"subject": "العلوم", "pdfPath": "assets/pdfs/AI for midterm.pdf"},
    {"subject": "اللغة العربية", "pdfPath": "assets/pdfs/AI for midterm.pdf"},
    {"subject": "التاريخ", "pdfPath": "assets/pdfs/AI for midterm.pdf"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
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
        child: SafeArea(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
            child: Column(
              children: [
                // العنوان
                const Text(
                  "مذكرات الدراسة",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.text,
                    fontFamily: 'Cairo',
                  ),
                ),
                const SizedBox(height: 20),

                // قائمة المذكرات
                Expanded(
                  child: ListView.builder(
                    itemCount: notes.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: GestureDetector(
                          onTap: () {
                            // الانتقال لصفحة عارض الـ PDF
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PDFViewerScreen(
                                  subject: notes[index]["subject"]!,
                                  pdfPath: notes[index]["pdfPath"]!,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withOpacity(0.2),
                                  blurRadius: 5,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.book,
                                    color: AppColors.primary, size: 30),
                                const SizedBox(width: 15),
                                Text(
                                  notes[index]["subject"]!,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.text,
                                    fontFamily: 'Cairo',
                                  ),
                                ),
                                const Spacer(),
                                const Icon(Icons.arrow_forward_ios,
                                    color: AppColors.secondary, size: 20),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
