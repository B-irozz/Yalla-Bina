import 'package:get/get.dart';
import 'package:yallabina/features/auth/log_in/login_view.dart';

class OnboardingController extends GetxController {
  // Current index of the slider
  var currentIndex = 0;

  changeSlide(int index)
  {
    currentIndex = index;
update();
  }


  // Function to go to the next screen
  void goNext() {
    if (currentIndex < 2) {
      currentIndex++;
      update();
    }
  }

  // Function to skip the onboarding process
  void skip() {
    currentIndex = 2;
update();  }

  void start(){
    Get.offAll(LoginView());
  }
}
