import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../models/failures.dart';
import '../../../utils/end_points.dart';

class ForgetPasswordRepo {
  Future<Either<Failure, bool>> forgetPassword(String email) async {
    final List<ConnectivityResult> connectivityResult = await (Connectivity().checkConnectivity());
    print("Connectivity result: $connectivityResult");

    if (connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.wifi) ||
        connectivityResult.contains(ConnectivityResult.ethernet)) {
      try {
        String baseUrl = EndPoints.baseUrl;
        String endPoints = EndPoints.forgetPassword;
        String url = "$baseUrl$endPoints";
        print("Request URL: $url");
        print("Email sent: $email");

        Dio dio = Dio();
        Response response = await dio.post(
          url,
          data: {"email": email}, // تغيير من phone لـ email
          options: Options(
            validateStatus: (status) {
              return status! < 500;
            },
          ),
        );

        print("Response Status Code: ${response.statusCode}");
        print("Response Data: ${response.data}");

        Map json = response.data;
        String? message = json['message'];

        if (response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300) {
          print("forgetPassword success");
          return const Right(true);
        } else {
          print("forgetPassword failed with message: $message");
          return Left(Failure(message ?? "something went wrong"));
        }
      } catch (e) {
        print("forgetPassword Exception: $e");
        return Left(Failure("يوجد خطأ ما!"));
      }
    } else {
      print("No internet connection available");
      return Left(Failure("لا يوجد اتصال بالانترنت!"));
    }
  }
}