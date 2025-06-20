import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:yallabina/core/data/repos/sign_up_repos/get_classes_repo.dart';
import 'package:yallabina/core/data/repos/sign_up_repos/get_profileImages_repo.dart';
import '../models/responses/authResponse/login_response.dart';

class SharedPrefUtils {
  static final storage = FlutterSecureStorage();

  init() {
    print("🗂 [SharedPrefUtils] Initializing repositories...");
    ImagesRepo imagesRepo = ImagesRepo()..getAllImages();
    ClassesRepo classesRepo = ClassesRepo()..getAllClasses();
    print("✅ [SharedPrefUtils] Initialization complete.");
  }

  void saveUser(UserDM user) async {
    if (user != null) {
      print("💾 [SharedPrefUtils] Saving user to storage: ${user.email}");
      await storage.write(key: "user", value: jsonEncode(user.toJson()));
      print("✅ [SharedPrefUtils] User saved successfully.");
    } else {
      print("⚠️ [SharedPrefUtils] Attempted to save null user.");
    }
  }

  Future<UserDM?> getUser() async {
    print("🔍 [SharedPrefUtils] Retrieving user from storage...");
    String? userAsString = await storage.read(key: "user");
    if (userAsString == null) {
      print("❗ [SharedPrefUtils] No user found in storage.");
      return null;
    }
    Map<String, dynamic> json = jsonDecode(userAsString);
    UserDM user = UserDM.fromJson(json);
    print("✅ [SharedPrefUtils] User retrieved: ${user.email}");
    return user;
  }

  void saveToken(String token) async {
    print("💾 [SharedPrefUtils] Saving token to storage...");
    await storage.write(key: "auth_token", value: token);
    print("✅ [SharedPrefUtils] Token saved successfully.");
  }

  Future<String?> getToken() async {
    print("🔍 [SharedPrefUtils] Retrieving token from storage...");
    String? token = await storage.read(key: 'auth_token');
    if (token != null) {
      print("✅ [SharedPrefUtils] Token retrieved successfully.");
    } else {
      print("❗ [SharedPrefUtils] No token found.");
    }
    return token;
  }

  void saveUserAddresses(List<String> addresses) async {
    print("💾 [SharedPrefUtils] Saving user addresses: ${addresses.length} items");
    await storage.write(key: "user_addresses", value: jsonEncode(addresses));
    print("✅ [SharedPrefUtils] User addresses saved.");
  }

  Future<List<String>> getUserAddresses() async {
    print("🔍 [SharedPrefUtils] Retrieving user addresses...");
    String? addressesAsString = await storage.read(key: "user_addresses");
    if (addressesAsString == null) {
      print("❗ [SharedPrefUtils] No addresses found.");
      return [];
    }
    List<dynamic> decodedList = jsonDecode(addressesAsString);
    List<String> addresses = List<String>.from(decodedList);
    print("✅ [SharedPrefUtils] Retrieved ${addresses.length} addresses.");
    return addresses;
  }

  void saveProfileImages(List<ImageModel> images) async {
    print("💾 [SharedPrefUtils] Saving profile images: ${images.length} images");
    List<Map<String, dynamic>> imageList = images.map((e) => e.toJson()).toList();
    await storage.write(key: "profile_images", value: jsonEncode(imageList));
    print("✅ [SharedPrefUtils] Profile images saved.");
  }

  Future<List<ImageModel>> getProfileImages() async {
    print("🔍 [SharedPrefUtils] Retrieving profile images...");
    String? imagesJson = await storage.read(key: "profile_images");
    if (imagesJson == null) {
      print("❗ [SharedPrefUtils] No profile images found.");
      return [];
    }
    List<dynamic> jsonList = jsonDecode(imagesJson);
    List<ImageModel> images = jsonList.map((e) => ImageModel.fromJson(e)).toList();
    print("✅ [SharedPrefUtils] Retrieved ${images.length} profile images.");
    return images;
  }

  void saveClasses(List<Class> classes) async {
    print("💾 [SharedPrefUtils] Saving classes: ${classes.length} classes");
    List<Map<String, dynamic>> classList = classes.map((e) => e.toJson()).toList();
    await storage.write(key: "classes", value: jsonEncode(classList));
    print("✅ [SharedPrefUtils] Classes saved.");
  }

  Future<List<Class>> getClasses() async {
    print("🔍 [SharedPrefUtils] Retrieving classes...");
    String? classesJson = await storage.read(key: "classes");
    if (classesJson == null) {
      print("❗ [SharedPrefUtils] No classes found.");
      return [];
    }
    List<dynamic> jsonList = jsonDecode(classesJson);
    List<Class> classes = jsonList.map((e) => Class.fromJson(e)).toList();
    print("✅ [SharedPrefUtils] Retrieved ${classes.length} classes.");
    return classes;
  }

  Future<void> deleteUser() async {
    print("🗑 [SharedPrefUtils] Deleting all data (deleteUser)...");
    await storage.deleteAll();
    print("✅ [SharedPrefUtils] All data deleted.");
  }

  Future<void> logoutUser() async {
  print("🚪 Logging out user...");
  await storage.deleteAll();
  print("✅ Storage cleared.");
}

}
