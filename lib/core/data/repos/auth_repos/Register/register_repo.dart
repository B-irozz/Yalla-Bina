
import '../../../utils/shared_pref_utils.dart';

class RegisterRepo {
  SharedPrefUtils sharedPrefUtils;

  RegisterRepo(this.sharedPrefUtils);

//   Future<Either<Failure, String>> register(
//       RegisterRequestBody body) async {
//     final List<ConnectivityResult> connectivityResult =
//         await (Connectivity().checkConnectivity());
//
//     if (connectivityResult.contains(ConnectivityResult.mobile) ||
//         connectivityResult.contains(ConnectivityResult.wifi) ||
//         connectivityResult.contains(ConnectivityResult.ethernet)) {
//       try {
//         String baseUrl = EndPoints.baseUrl;
//         String endPoints = EndPoints.signup;
//
//         String url = "$baseUrl$endPoints";
//         print("#############################");
// print(body.phone);
//         Dio dio = Dio();
//         Response response = await dio.post(
//           url,
//           data: body.toJson(),
//           options: Options(
//             headers: {
//               "Accept": "application/json",
//             },
//             validateStatus: (status) {
//               return status! < 500;
//             },
//           ),
//         );
//
//         String responseMessage = response.data['message'];
//
//         print("messgae = $response");
//
//         if (response.statusCode! >= 200 && response.statusCode! < 300) {
//           // sharedPrefUtils.saveUser(clientRegisterResponse.data!.user!);
//           // sharedPrefUtils.saveToken(clientRegisterResponse.data!.token!);
//           print("clientRegister success");
//           return Right(responseMessage);
//         } else {
//           print("clientRegister failed");
//           return Left(Failure(
//               responseMessage ?? "something went wrong"));
//         }
//       } catch (e) {
//         print("clientRegister Exception = $e");
//         return Left(Failure("يوجد خطأ ما!"));
//       }
//     } else {
//       return Left(Failure("لا يوجد اتصال بالانترنت!"));
//     }
//   }
}

