import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:yallabina/core/data/utils/end_points.dart';
import '../../models/responses/Contact.dart';
import '../../utils/shared_pref_utils.dart';

class ContactRepository {
  final Dio dio = Get.find<Dio>();
  final SharedPrefUtils sharedPrefUtils = Get.find<SharedPrefUtils>();

  Future<List<ContactDM>> getAllContacts() async {
    String? token=await sharedPrefUtils.getToken();
    try {
      final response = await dio.get(
        '${EndPoints.baseUrl}/contact/getAllContacts',
        options: Options(
          headers: {
            'Authorization':'$token',
          },
        ),
      );

      print('Response Status: ${response.statusCode}, Data: ${response.data}');

      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        final ContactsResponse contactsResponse = ContactsResponse.fromJson(response.data);
        if (contactsResponse.status == 'success') {
          return contactsResponse.contacts ?? [];
        } else {
          throw Exception(contactsResponse.message ?? 'Failed to load contacts');
        }
      } else {
        throw Exception('Failed to load contacts');
      }
    } catch (e) {
      print('Error in getAllContacts: $e');
      throw Exception('Failed to load contacts: $e');
    }
  }
}