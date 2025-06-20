import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yallabina/features/auth/signup/signup_controller.dart';
import '../../../../../core/constant/colors.dart';
import '../../../../../core/data/utils/shared_pref_utils.dart';

class ClassSelectionScreen extends StatelessWidget {
  final SignUpController controller = Get.find();

  ClassSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Class')),
      body: ListView.builder(
        itemCount: controller.classes.length,
        itemBuilder: (context, index) {
          final classId = controller.classes[index].levelId;
          final className = controller.classes[index].name;

          return ListTile(
            title: Text(className),
            onTap: () {
              print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!11");
              print(classId);
              print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!11");
              controller.classId.value = int.parse(classId);
              controller.scientificTrack.value = ''; // إعادة تهيئة التراك عند اختيار كلاس جديد
              Get.back();
            },
          );
        },
      ),
    );
  }
}

class ClassSelection extends StatelessWidget {
  final SignUpController controller = Get.find();

  ClassSelection({super.key});

  Future<void> getClasses() async {
    final sharedPref = Get.find<SharedPrefUtils>();
    controller.classes = await sharedPref.getClasses();
  }

  @override
  Widget build(BuildContext context) {
    getClasses();
    return Obx(() {
      if (controller.classId.value != 0) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.primary),
                borderRadius: BorderRadius.circular(8),
                color: AppColors.primary.withOpacity(0.1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Selected Class',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'ID: ${controller.classId.value}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () => Get.to(() => ClassSelectionScreen()),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.primary,
                    ),
                    child: const Text('Change Selection'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Obx(() => DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Scientific Track',
                    labelStyle: const TextStyle(color: AppColors.primary),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: AppColors.primary, width: 2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    prefixIcon: const Icon(Icons.school, color: AppColors.primary),
                  ),
                  items: controller.classId.value == 8321
                      ? [] // الصف الأول: لا يظهر أوبشن
                      : controller.classId.value == 5896
                          ? [
                              {'label': 'علمي', 'value': 8106},
                              {'label': 'أدبي', 'value': 3584},
                            ]
                              .map((track) => DropdownMenuItem<String>(
                                    value: track['label'] as String,
                                    child: Text(track['label'] as String),
                                  ))
                              .toList()
                          : controller.classId.value == 8842
                              ? [
                                  {'label': 'أدبي', 'value': 2994},
                                  {'label': 'علمي علوم', 'value': 1518},
                                  {'label': 'علمي رياضة', 'value': 2813},
                                ]
                                .map((track) => DropdownMenuItem<String>(
                                      value: track['label'] as String,
                                      child: Text(track['label'] as String),
                                    ))
                                .toList()
                              : [],
                  onChanged: controller.classId.value == 8321
                      ? null
                      : (value) {
                          final selectedTrack = (controller.classId.value == 5896
                                  ? [
                                      {'label': 'علمي', 'value': 8106},
                                      {'label': 'أدبي', 'value': 3584},
                                    ]
                                  : [
                                      {'label': 'أدبي', 'value': 2994},
                                      {'label': 'علمي علوم', 'value': 1518},
                                      {'label': 'علمي رياضة', 'value': 2813},
                                    ])
                              .firstWhere((track) => track['label'] == value);
                          controller.scientificTrack.value = selectedTrack['value'].toString();
                        },
                  value: controller.scientificTrack.value.isEmpty
                      ? null
                      : (controller.classId.value == 5896
                              ? [
                                  {'label': 'علمي', 'value': 8106},
                                  {'label': 'أدبي', 'value': 3584},
                                ]
                              : [
                                  {'label': 'أدبي', 'value': 2994},
                                  {'label': 'علمي علوم', 'value': 1518},
                                  {'label': 'علمي رياضة', 'value': 2813},
                                ])
                          .firstWhere((track) => track['value'].toString() == controller.scientificTrack.value,
                              orElse: () => {'label': '', 'value': ''})['label'] as String,
                  dropdownColor: Colors.white,
                  icon: const Icon(Icons.arrow_drop_down, color: AppColors.primary),
                )),
          ],
        );
      }
      return ElevatedButton.icon(
        onPressed: () => Get.to(() => ClassSelectionScreen()),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        icon: const Icon(Icons.class_),
        label: const Text('Select Class'),
      );
    });
  }
}