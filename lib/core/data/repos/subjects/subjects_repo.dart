import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../models/failures.dart';

class SubjectsRepo {
  Future<Either<Failure, List<Subject>>> getSubjectsByGradeLevel(String gradeLevelId, {String? scientificTrackId}) async {
    print("🔍 [REPO] Checking connectivity for subjects fetch at ${DateTime.now()}");
    final connectivityResult = await Connectivity().checkConnectivity();
    print("✅ [REPO] Connectivity Result: $connectivityResult");

    if (connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.wifi) ||
        connectivityResult.contains(ConnectivityResult.ethernet)) {
      print("✅ [REPO] Connectivity available. Proceeding with API call.");

      try {
        String url = "https://exammatchingapp-production.up.railway.app/api/subjects";
        Map<String, String> params = {'gradeLevelId': gradeLevelId};
        if (scientificTrackId != null) {
          params['scientificTrackId'] = scientificTrackId;
        }
        print("🔍 [REPO] Final URL: $url, params: $params");

        Dio dio = Dio();
        Response response = await dio.get(
          url,
          queryParameters: params,
          options: Options(
            validateStatus: (status) => status! < 500,
          ),
        );

        print("✅ [REPO] Response received: Status ${response.statusCode}, Data: ${response.data}");
        var json = response.data;

        if (response.statusCode! >= 200 && response.statusCode! < 300) {
          print("✅ [REPO] getSubjectsByGradeLevel success");

          List<Subject> subjects = (json as List)
              .map((subjectJson) => Subject.fromJson(subjectJson))
              .toList();

          for (var subject in subjects) {
            print("📚 Subject Loaded -> id: ${subject.subjectId}, name: ${subject.name}");
          }

          return Right(subjects);
        } else {
          print("❌ [REPO] getSubjectsByGradeLevel failed. Code: ${response.statusCode}, Message: ${json['message'] ?? 'Something went wrong'}");
          return Left(Failure(json['message'] ?? "Something went wrong, please try again"));
        }
      } catch (e, stack) {
        print("❌ [REPO] DioError: $e, Stack: $stack");
        return Left(Failure("يوجد خطأ ما!"));
      }
    } else {
      print("❌ [REPO] No internet connection available.");
      return Left(Failure("لا يوجد اتصال بالانترنت!"));
    }
  }
}

class Subject {
  final String id;
  final String name;
  final int gradeLevelId;
  final int subjectId;
  final DateTime createdAt;
  final DateTime updatedAt;

  Subject({
    required this.id,
    required this.name,
    required this.gradeLevelId,
    required this.subjectId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      gradeLevelId: json['gradeLevelId'] ?? 0,
      subjectId: json['subjectId'] ?? 0,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}