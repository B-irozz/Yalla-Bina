import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:yallabina/core/data/repos/sign_up_repos/get_classes_repo.dart';
import 'package:yallabina/core/data/repos/sign_up_repos/get_profileImages_repo.dart';
import '../../../../../core/data/repos/sign_up_repos/sign_up_repo.dart';
import '../../../../../core/utils/dialog_utils.dart';
import 'email_verification.dart';

class SignUpController extends GetxController {
  final SignUpRepo signUpRepo = SignUpRepo();

  var currentStep = 0.obs;
  var isLoading = false.obs;
  var username = ''.obs;
  var email = ''.obs;
  var password = ''.obs;
  var gender = ''.obs;
  var classId = 0.obs;
  var imageId = ''.obs;
  var confirmationPassword = ''.obs;
  var scientificTrack = ''.obs;
  List<ImageModel> profileImages = [];
  List<Class> classes = [];
  var selectedImagePath = ''.obs;
  XFile? pickedFile;

  Future<void> pickImage() async {
    try {
      pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        selectedImagePath.value = pickedFile!.path;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick image: ${e.toString()}');
    }
  }

  void nextStep() {
    if (currentStep.value < 2) {
      currentStep.value++;
    }
  }

  void previousStep() {
    if (currentStep.value > 0) {
      currentStep.value--;
    }
  }

  Future<void> signUp() async {
  if (classId.value == 0) {
    showErrorDialog("Please select a class first!");
    return;
  }
  try {
    isLoading(true);
    final response = await signUpRepo.signUp(
      email: email.value,
      password: password.value,
      gender: gender.value,
      gradeLevelId: classId.value,
      filePath: selectedImagePath.value,
      name: username.value,
      scientificTrack: scientificTrack.value.isEmpty || classId.value == 8321 ? null : int.tryParse(scientificTrack.value), // تحويل لـ int أو null
    );

    response.fold(
      (failure) {
        showErrorDialog(failure.errorMessage);
      },
      (data) {
        Get.offAll(() => EmailVerificationScreen(email: email.value));
      },
    );
  } catch (e) {
    Get.snackbar('Error', e.toString());
  } finally {
    isLoading(false);
  }
}
}