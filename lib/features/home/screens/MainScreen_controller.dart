import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yallabina/features/auth/profile.dart';
import 'package:yallabina/features/chat_with_ai/ai_chat.dart';

import '../../chat/chat_contacts_screen.dart';
import '../../ranks/ranks_page.dart';
import 'homepage.dart';

class MainScreenController extends GetxController {


  int currentTab = 0;

  List<Widget> get tabs {
    return [
      Homepage(),
      RanksScreen(),
      ChatContactsScreen(),
      AIChatView(),
      const ProfileScreen(),

    ];
  }

  changeTab({required int index,int? companyIndex}) {
    currentTab = index;
    update();
  }

}