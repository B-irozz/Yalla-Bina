import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yallabina/core/constant/colors.dart';
import 'package:yallabina/features/exam/screens/subjects/subjects_controller.dart';

class SubjectsView extends StatelessWidget {
  const SubjectsView({super.key});

  @override
  Widget build(BuildContext context) {
    final SubjectsController controller = Get.put(SubjectsController());
    return WillPopScope(
      onWillPop: () async {
        if (controller.isSelectingPersonType.value) {
          controller.isSelectingPersonType.value = false;
          return false;
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("المواد الدراسية"),
          backgroundColor: AppColors.background,
        ),
        body: Obx(() =>
            controller.isLoading.value
                ? const Center(child: CircularProgressIndicator())
                : controller.isSelectingPersonType.value
                ? SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: _buildPersonTypeSelectionCard(controller),
                  )
                : _buildSubjectsList(context, controller),
        ),
      ),
    );
  }

  Widget _buildSubjectsList(BuildContext context, SubjectsController controller) {
    return controller.subjects.isEmpty
        ? const Center(child: Text("لا توجد مواد دراسية متاحة", style: TextStyle(fontSize: 18)))
        : ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: controller.subjects.length,
            itemBuilder: (context, index) {
              final subject = controller.subjects[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: _buildSubjectCard(
                  context,
                  subjectName: subject.name,
                  onTap: () {
                    controller.onSubjectTap(subject); // استخدام الـ method المناسب
                  },
                ),
              );
            },
          );
  }

  Widget _buildSubjectCard(BuildContext context,
      {required String subjectName, required VoidCallback onTap}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withOpacity(0.7),
            AppColors.secondary.withOpacity(0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Opacity(
              opacity: 0.6,
              child: Image.asset(
                'assets/images/subject.png',
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  subjectName,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'Cairo',
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.background,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                  onPressed: onTap,
                  child: const Text(
                    "ابدأ الآن",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonTypeSelectionCard(SubjectsController controller) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white.withOpacity(0.8),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          const Text(
            "اختر نوع الشخص الذي ستختبر معه:",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'Cairo',
            ),
          ),
          const SizedBox(height: 20),
          Obx(() => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ChoiceChip(
                    label: const Text("ولد"),
                    selected: controller.selectedPersonType.value == '1',
                    onSelected: (selected) {
                      controller.selectedPersonType.value = '1';
                    },
                  ),
                  const SizedBox(width: 20),
                  ChoiceChip(
                    label: const Text("بنت"),
                    selected: controller.selectedPersonType.value == '2',
                    onSelected: (selected) {
                      controller.selectedPersonType.value = '2';
                    },
                  ),
                ],
              )),
          const SizedBox(height: 20),
          Obx(() => ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                onPressed: controller.selectedPersonType.value.isNotEmpty
                    ? () {
                        controller.navigateToExam(
                            controller.selectedSubject.toString(),
                            controller.selectedPersonType.value);
                      }
                    : null,
                child: const Text(
                  "يلا بينا",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              )),
          TextButton(
            onPressed: () => controller.isSelectingPersonType.value = false,
            child: const Text(
              "رجوع",
              style: TextStyle(fontSize: 16, color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }
}