import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:yallabina/core/app_responsive.dart';
import 'package:yallabina/features/auth/log_in/login_view.dart';

import '../../core/constant/colors.dart';

class OnBoarding extends StatefulWidget {
  const OnBoarding({super.key});

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  final _introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) {
    // Navigate to MainScreen when done
    Get.offAll(() => LoginView());
  }

  @override
  Widget build(BuildContext context) {
    // final width = Get.width; // Screen width
    // final height = Get.height; // Screen height
    // Custom decoration for full screen
    const pageDecoration = PageDecoration(

      bodyPadding: EdgeInsets.zero,
      titlePadding: EdgeInsets.zero,
      contentMargin: EdgeInsets.zero,
      fullScreen: true,
      bodyFlex: 1,
      imageFlex: 1,
      boxDecoration: BoxDecoration(
        color: Colors.white,
      ),
    );

    return SafeArea(
      child: Scaffold(
        body: IntroductionScreen(
          key: _introKey,
          globalBackgroundColor: Colors.white,
          pages: [
            PageViewModel(
              image: Container(
                color: Colors.white,
                width: double.infinity,
                height: double.infinity,
                child: Center(
                  child: SvgPicture.asset(
                    "assets/svgs/undraw_co-working_becw.svg",
                    width: 200, // adjust as needed
                    height: 200,
                  ),
                ),
              ),
              title: "",
              decoration: pageDecoration,
              bodyWidget: const SizedBox.shrink(),
            ),
            PageViewModel(
              image: Container(
                color: Colors.white,
                width: double.infinity,
                height: double.infinity,
                child: Center(
                  child: SvgPicture.asset(
                    "assets/svgs/undraw_audio-conversation_zg3f.svg",
                    width: 200, // adjust as needed
                    height: 200,
                  ),
                ),
              ),
              title: "",
              decoration: pageDecoration,
              bodyWidget: const SizedBox.shrink(),
            ),
            PageViewModel(
              image: Container(
                color: Colors.white,
                width: double.infinity,
                height: double.infinity,
                child: Center(
                  child: SvgPicture.asset(
                    "assets/svgs/undraw_grades_hqyk.svg",
                    width: 200, // adjust as needed
                    height: 200,
                  ),
                ),
              ),
              title: "",
              decoration: pageDecoration,
              bodyWidget: const SizedBox.shrink(),
            ),



          ],

          onDone: () => _onIntroEnd(context),
          showSkipButton: false,
          skipOrBackFlex: 0,
          nextFlex: 0,
          showBackButton: false,
          back: const Icon(Icons.arrow_back),
          next: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            padding: const EdgeInsets.all(12),
            child: Icon(
              Icons.arrow_forward,
              color: AppColors.darkestHeading,
              size:  28.s(),
            ),
          ),
          done: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            padding: EdgeInsets.all(10.s()),
            child: Icon(
              Icons.check,
              color: AppColors.darkestHeading,
              size:  28.s(),
            ),
          ),
          animationDuration: 400,
          curve: Curves.easeIn,
          controlsMargin:  EdgeInsets.all(12.s()),
          controlsPadding: const EdgeInsets.fromLTRB(8, 4, 8, 16),
          dotsDecorator:  DotsDecorator(
            activeColor: AppColors.darkestHeading,
            size: const Size(10.0, 10.0),
            color: const Color(0xFFBDBDBD),
            activeSize: const Size(22.0, 10.0),
            activeShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.s())),
            ),
          ),
          dotsContainerDecorator: ShapeDecoration(
            // color: Color(0xDAFFFFFF),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.s())),
            ),
          ),
        ),
      ),
    );
  }
}