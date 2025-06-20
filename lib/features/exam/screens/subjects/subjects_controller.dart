import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/data/models/failures.dart';
import '../../../../core/data/models/responses/authResponse/login_response.dart';
import '../../../../core/data/repos/subjects/subjects_repo.dart';
import '../../../../core/data/utils/shared_pref_utils.dart';
import '../questions/questions_view.dart';

class SubjectsController extends GetxController {
  final RxBool isLoading = true.obs;
  final RxBool isSelectingPersonType = false.obs;
  final RxString selectedPersonType = ''.obs;
  final RxList<Subject> subjects = <Subject>[].obs;
  final SubjectsRepo subjectsRepo = SubjectsRepo();
  final SharedPrefUtils sharedPrefUtils = Get.find<SharedPrefUtils>();
  String classId = "";
  String? trackId;

  late int selectedSubject;

  @override
  void onInit() {
    super.onInit();
    fetchSubjects();
  }

  Future<void> fetchSubjects() async {
  isLoading.value = true;
  subjects.clear();
  print("✅ Subjects cleared.");

  UserDM? user = await sharedPrefUtils.getUser();

  if (user != null && user.gradeLevelId != null) {
    Either<Failure, List<Subject>> result = await subjectsRepo.getSubjectsByGradeLevel(
      user.gradeLevelId.toString(),
      scientificTrackId: user.scientificTrack?.toString(),
    );

    result.fold(
      (failure) => print("❌ API Failure: ${failure.errorMessage}"),
      (subjectsList) {
        subjects.value = subjectsList;
        print("✅ Subjects loaded: ${subjectsList.length}");
      },
    );
  } else {
    print("⚠️ User or gradeLevelId is null");
  }

  isLoading.value = false;
}

  void onSubjectTap(Subject subject) {
    print("🔍 [CONTROLLER] Subject tapped: ${subject.name}, ID: ${subject.subjectId}");
    selectedSubject = subject.subjectId;
    isSelectingPersonType.value = true;
    print("✅ [CONTROLLER] Selected subject: $selectedSubject, isSelecting: ${isSelectingPersonType.value}");
  }

  Future<void> navigateToExam(String subjectId, String gender) async {
    print("🔍 [CONTROLLER] Navigating to exam for subjectId: $subjectId, gender: $gender");
    UserDM? user = await sharedPrefUtils.getUser();
    if (user != null) {
      print("✅ [CONTROLLER] User found for navigation: ${user.name}");
      Get.to(() => ExamScreen(
        subjectId: subjectId,
        classId: user.gradeLevelId.toString(),
        scientificTrack: user.scientificTrack ?? 0,
        totalPoints: user.totalPoints ?? 0,
        gender: gender,
      ));
    } else {
      print("⚠️ [CONTROLLER] No user found for navigation");
    }
  }
}