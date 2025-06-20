import 'package:get/get.dart';
import 'package:yallabina/core/data/models/responses/authResponse/login_response.dart';

import '../../core/data/models/responses/Contact.dart';
import '../../core/data/repos/chat/contacts_repository.dart';
import '../../core/data/utils/shared_pref_utils.dart';


class ContactController extends GetxController {
  final ContactRepository contactRepository = ContactRepository();
  final SharedPrefUtils sharedPrefUtils = Get.find<SharedPrefUtils>();

  final RxList<ContactDM> contacts = <ContactDM>[].obs;
  final RxList<ContactDM> filteredContacts = <ContactDM>[].obs;
  final RxString searchQuery = ''.obs;
  final RxBool isLoading = true.obs;
  UserDM? userDM =UserDM();

  @override
  void onInit() {
    fetchUser();
    fetchContacts();

    super.onInit();

  }
  Future<void> fetchUser() async {
    UserDM? currentUser=await sharedPrefUtils.getUser();
    userDM=currentUser;
  }

  Future<void> fetchContacts() async {
    try {
      isLoading.value = true;
      final fetchedContacts = await contactRepository.getAllContacts();
      contacts.assignAll(fetchedContacts);
      filteredContacts.assignAll(fetchedContacts);
    } finally {
      isLoading.value = false;
    }
  }

  void filterContacts(String query) {
    searchQuery.value = query.toLowerCase();
    if (query.isEmpty) {
      filteredContacts.assignAll(contacts);
    } else {
      filteredContacts.assignAll(
        contacts.where((contact) =>
        contact.label!.toLowerCase().contains(searchQuery.value) ||
            contact.randomId!.toString().toLowerCase().contains(searchQuery.value)),
      );
    }
  }
}