import 'package:dartz/dartz.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart'; // For basename
import 'package:yallabina/core/data/utils/end_points.dart';
import '../../models/failures.dart';

class SignUpRepo {
  Future<Either<Failure, String>> signUp({
  required String name,
  required String email,
  required String password,
  required String gender,
  required int gradeLevelId,
  required String filePath,
  int? scientificTrack, // تغيير النوع لـ int?
}) async {
  print("Checking internet connectivity...");
  print("gradeLevelId: $gradeLevelId");
  final List<ConnectivityResult> connectivityResult =
      await Connectivity().checkConnectivity();

  if (connectivityResult.contains(ConnectivityResult.mobile) ||
      connectivityResult.contains(ConnectivityResult.wifi) ||
      connectivityResult.contains(ConnectivityResult.ethernet)) {
    print("Internet available, proceeding with sign up...");
    print(filePath);

    try {
      final uri = Uri.parse("${EndPoints.baseUrl}/auth/register");
      final request = http.MultipartRequest('POST', uri);

      final mimeType = lookupMimeType(filePath) ?? 'application/octet-stream';
      final mimeSplit = mimeType.split('/');

      request.files.add(await http.MultipartFile.fromPath(
        'profilePic',
        filePath,
        filename: basename(filePath),
        contentType: MediaType(mimeSplit[0], mimeSplit[1]),
      ));

      request.fields['name'] = name;
      request.fields['gender'] = gender;
      request.fields['gradeLevelId'] = gradeLevelId.toString();
      request.fields['email'] = email;
      request.fields['password'] = password;
      if (scientificTrack != null) {
        request.fields['scientificTrack'] = scientificTrack.toString(); // إرسال كـ int
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print("Sign Up Response: ${response.body}");

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final user = response.body;
        return Right(user);
      } else {
        return Left(Failure(
            "حدث خطأ ما، يرجى المحاولة لاحقًا. (${response.statusCode})"));
      }
    } catch (e) {
      print("SignUp error: $e");
      return Left(Failure("حدث خطأ أثناء إنشاء الحساب."));
    }
  } else {
    return Left(Failure("لا يوجد اتصال بالانترنت!"));
  }
}
}