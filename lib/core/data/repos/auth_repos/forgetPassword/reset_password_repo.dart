import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../models/failures.dart';
import '../../../utils/end_points.dart';

class ResetPasswordRepo {
  Future<Either<Failure, String>> resetPassword({
    required String phone,
    required String password,
    required String code,
  }) async {
    final List<ConnectivityResult> connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.wifi) ||
        connectivityResult.contains(ConnectivityResult.ethernet)) {
      try {
        String url = "${EndPoints.baseUrl}${EndPoints.resetPassword}/$phone";
        print("Full Reset URL: $url");
        Dio dio = Dio();
        Response response = await dio.post(
          url,
          data: {"otp": code, "password": password},
          options: Options(headers: {"Accept": "application/json"}, validateStatus: (status) => status! < 500),
        );
        print("Reset Response: ${response.statusCode} - ${jsonEncode(response.data)}");
        if (response.statusCode! >= 200 && response.statusCode! < 300) {
          return Right(response.data['message']);
        } else {
          return Left(Failure(response.data['message'] ?? "Something went wrong"));
        }
      } catch (e) {
        print("Reset Exception: $e");
        return Left(Failure("يوجد خطأ ما!"));
      }
    } else {
      return Left(Failure("لا يوجد اتصال بالانترنت!"));
    }
  }
}