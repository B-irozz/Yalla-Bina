import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';

import '../../models/failures.dart';
import '../../utils/end_points.dart';
import '../../utils/shared_pref_utils.dart';


class VerifyRepo {

  VerifyRepo();

  Future<Either<Failure, String>> verify(String code, String email) async {
    print("Starting verification process...");

    // Check connectivity
    final List<ConnectivityResult> connectivityResult =
    await (Connectivity().checkConnectivity());
    print("Connectivity check: $connectivityResult");

    if (!connectivityResult.any((result) =>
    result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi ||
        result == ConnectivityResult.ethernet)) {
      print("No internet connection.");
      return Left(Failure("لا يوجد اتصال بالانترنت!"));
    }

    try {
      String baseUrl = EndPoints.baseUrl;
      String endPoints = EndPoints.verifyEmail;
      String url = "$baseUrl$endPoints";

      print("Making API call to: $url");

      var data = json.encode({"code": code, "email": email});
      print("Request data: $data");

      Dio dio = Dio();
      Response response = await dio.post(
        url,
        data: data,
        options: Options(
          headers: {'Content-Type': 'application/json'},
          validateStatus: (status) => status! < 500,
        ),
      );

      print("Response Status: ${response.statusCode}");
      print("Response Body: ${response.data}");

      // Handle non-successful responses (outside 200-299 range)
      if (response.statusCode! < 200 || response.statusCode! >= 300) {
        final errorMessage = response.data['message'] ??
            "فشل التحقق. الرجاء المحاولة مرة أخرى.";
        return Left(Failure(errorMessage));
      }

      // Extract token from the nested 'data' object
      final responseData = response.data as Map<String, dynamic>;
      final dataMap = responseData['data'] as Map<String, dynamic>?;

      if (dataMap == null) {
        return Left(Failure("بيانات الاستجابة غير صالحة."));
      }

      // Check for both 'access_token' and 'access_Token' variants
      final token = dataMap['access_token'] ?? dataMap['access_Token'];

      if (token == null) {
        return Left(Failure("لم يتم استلام رمز الدخول."));
      }

      final sharedPref = Get.find<SharedPrefUtils>();
      print("Verify success. Token: $token");
      sharedPref.saveToken(token);
      return Right(token);
    } on DioException catch (e) {
      print("Dio Error: ${e.message}");
      print("Error Response: ${e.response?.data}");
      return Left(Failure("حدث خطأ في الاتصال بالخادم."));
    } catch (e, stackTrace) {
      print("Unexpected Error: $e");
      print("Stack Trace: $stackTrace");
      return Left(Failure("حدث خطأ غير متوقع."));
    }
  }
}