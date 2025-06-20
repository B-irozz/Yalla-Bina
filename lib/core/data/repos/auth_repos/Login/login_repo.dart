  import 'package:connectivity_plus/connectivity_plus.dart';
  import 'package:dartz/dartz.dart';
  import 'package:dio/dio.dart';
  import 'package:get/get.dart';
  import '../../../../service/socket.dart';
  import '../../../models/failures.dart';
  import '../../../models/responses/authResponse/login_response.dart';
  import '../../../utils/end_points.dart';
  import '../../../utils/shared_pref_utils.dart';

  class LoginRepo {
    final SharedPrefUtils sharedPrefUtils;
    final Dio dio = Dio();

    LoginRepo(this.sharedPrefUtils);

    Future<Either<Failure, UserDM>> login({required String email, required String password}) async {
      final connectivity = await Connectivity().checkConnectivity();
      if (!connectivity.any((r) => [ConnectivityResult.mobile, ConnectivityResult.wifi, ConnectivityResult.ethernet].contains(r))) {
        return Left(Failure("لا يوجد اتصال بالانترنت!"));
      }
      try {
        print("Sending Login Request to: ${EndPoints.baseUrl}/auth/login");
        print("Request Data: {email: $email, password: $password}");

        await sharedPrefUtils.deleteUser();
        
        final response = await dio.post(
          "${EndPoints.baseUrl}/auth/login",
          data: {"email": email, "password": password},
          options: Options(
            headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
            validateStatus: (status) => status != null && status < 500,
          ),
        );
        print("Response Status Code: ${response.statusCode}");
        print("Response Data: ${response.data}");

        if (response.statusCode! >= 200 && response.statusCode! < 300) {
          final loginResponse = LoginResponse.fromJson(response.data);
          final userDM = loginResponse.result;
          final token = loginResponse.authorization?.token;

          if (userDM == null) return Left(Failure("Invalid user data received"));
          if (token == null) return Left(Failure("Invalid token data received"));
          if (userDM.gradeLevelId == null || userDM.subjects == null) {
            return Left(Failure("Invalid user data: Missing gradeLevelId or subjects"));
          }

          sharedPrefUtils.saveToken(token);
          sharedPrefUtils.saveUser(userDM);

          SocketService.to.connectAndVerify(token: token, serverUrl: EndPoints.socketUrl, email: userDM.email!);

          return Right(userDM);
        } else {
          return Left(Failure(response.data['message'] ?? "فشل تسجيل الدخول. الرجاء المحاولة مرة أخرى."));
        }
      } on DioException catch (e) {
        print("DioException: ${e.response?.data ?? e.message}");
        final message = e.response?.data is Map && e.response?.data['message'] != null
            ? e.response!.data['message']
            : e.message ?? "حدث خطأ في الاتصال بالخادم";
        return Left(Failure(message));
      } catch (e) {
        print("General Exception: $e");
        return Left(Failure("حدث خطأ غير متوقع: ${e.toString()}"));
      }
    }
  }