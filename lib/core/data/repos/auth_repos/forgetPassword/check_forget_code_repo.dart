import 'dart:convert'; 
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../models/failures.dart';
import '../../../utils/end_points.dart';

class CheckForgetPasswordRepo {
  Future<Either<Failure, String?>> checkForgetPassword(String email, String code) async {
    final List<ConnectivityResult> connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.wifi) ||
        connectivityResult.contains(ConnectivityResult.ethernet)) {
      try {
        String url = "${EndPoints.baseUrl}${EndPoints.resetPassword}/$email"; // استخدام resetPassword
        print("Check URL: $url, OTP: $code");
        Dio dio = Dio();
        Response response = await dio.post(
          url,
          data: {"otp": code}, // ترسل الـ OTP بس للتحقق
          options: Options(headers: {"Accept": "application/json"}, validateStatus: (status) => status! < 500),
        );
        print("Check Response: ${response.statusCode} - ${jsonEncode(response.data)}");
        if (response.statusCode! >= 200 && response.statusCode! < 300) {
          return Right(response.data['message']); // لو الـ OTP صح، رجّع رسالة
        } else {
          return Left(Failure(response.data['message'] ?? "Something went wrong"));
        }
      } catch (e) {
        print("Check Exception: $e");
        return Left(Failure("يوجد خطأ ما!"));
      }
    } else {
      return Left(Failure("لا يوجد اتصال بالانترنت!"));
    }
  }

  Future<Either<Failure, bool>> forgetPassword(String email) async {
    final List<ConnectivityResult> connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.wifi) ||
        connectivityResult.contains(ConnectivityResult.ethernet)) {
      try {
        String url = "${EndPoints.baseUrl}${EndPoints.forgetPassword}";
        print("Forget URL: $url, Email: $email");
        Dio dio = Dio();
        Response response = await dio.post(
          url,
          data: {"email": email},
          options: Options(headers: {"Accept": "application/json"}, validateStatus: (status) => status! < 500),
        );
        print("Forget Response: ${response.statusCode} - ${jsonEncode(response.data)}");
        if (response.statusCode! >= 200 && response.statusCode! < 300) {
          return Right(true);
        } else {
          return Left(Failure(response.data['message'] ?? "Something went wrong"));
        }
      } catch (e) {
        print("Forget Exception: $e");
        return Left(Failure("يوجد خطأ ما!"));
      }
    } else {
      return Left(Failure("لا يوجد اتصال بالانترنت!"));
    }
  }
}