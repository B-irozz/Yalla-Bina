import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:yallabina/core/data/utils/end_points.dart';

import '../../utils/shared_pref_utils.dart';

class QuestionsRepository {
  Future<Either<Failure, List<Question>>> getQuestionsByClassAndSubject({
    required String classId,
    required String subjectId,
  }) async {
    print("Checking connectivity for questions fetch...");
    final List<ConnectivityResult> connectivityResult =
    await (Connectivity().checkConnectivity());
    print("Connectivity Result: $connectivityResult");

    if (connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.wifi) ||
        connectivityResult.contains(ConnectivityResult.ethernet)) {
      print("Connectivity is available. Proceeding with the API call.");

      try {
        const String url =
            "https://yalaa-production.up.railway.app/auth/getQuestionsByClassAndSubject";
        print("Final URL: $url");

        var headers = {
          'Content-Type': 'application/json',
        };

        var data = json.encode({
          "classId": classId,
          "subjectId": subjectId,
        });

        Dio dio = Dio();
        Response response = await dio.request(
          url,
          options: Options(
            method: 'GET',
            headers: headers,
            validateStatus: (status) {
              return status! < 500;
            },
          ),
          data: data,
        );

        var jsonResponse = response.data;
        print("Response data: $jsonResponse");

        QuestionsResponse questionsResponse =
        QuestionsResponse.fromJson(jsonResponse);
        print("Parsed QuestionsResponse: ${questionsResponse.questions}");

        if (response.statusCode! >= 200 && response.statusCode! < 300) {
          print("getQuestionsByClassAndSubject success");
          return Right(questionsResponse.questions);
        } else {
          print(
              "getQuestionsByClassAndSubject failed. Response Code: ${response.statusCode}");
          return Left(Failure(questionsResponse.message ??
              "Something went wrong, please try again"));
        }
      } on DioException catch (e) {
        print("getQuestionsByClassAndSubject DioError: $e");
        return Left(Failure("يوجد خطأ ما!"));
      } catch (e) {
        print("getQuestionsByClassAndSubject Error: $e");
        return Left(Failure("حدث خطأ غير متوقع!"));
      }
    } else {
      print("No internet connection available.");
      return Left(Failure("لا يوجد اتصال بالانترنت!"));
    }
  }

  Future<Either<Failure, bool>> submitAnswer({
    required String questionId,
    required String selectedAnswer,
  }) async {
    print("Checking internet connection...");
    final List<ConnectivityResult> connectivityResult =
    await (Connectivity().checkConnectivity());

    if (!connectivityResult.contains(ConnectivityResult.mobile) &&
        !connectivityResult.contains(ConnectivityResult.wifi) &&
        !connectivityResult.contains(ConnectivityResult.ethernet)) {
      print("No internet connection.");
      return Left(Failure("لا يوجد اتصال بالانترنت!"));
    }

    final SharedPrefUtils sharedPrefUtils = Get.find<SharedPrefUtils>();
    final String? token = await sharedPrefUtils.getToken();
    print("Retrieved token: $token");

    try {
      const String url = "${EndPoints.baseUrl}/auth/submitAnswer";
      print("POST request to: $url");

      var headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };
      print("Headers: $headers");

      var data = json.encode({
        "questionId": questionId,
        "selectedAnswer": selectedAnswer,
      });
      print("Payload: $data");

      Dio dio = Dio();
      Response response = await dio.post(
        url,
        options: Options(
          headers: headers,
          validateStatus: (status) => status! < 500,
        ),
        data: data,
      );

      print("Response status code: ${response.statusCode}");
      print("Response data: ${response.data}");

      var jsonResponse = response.data;
      final message = jsonResponse['message'] as String;

      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        final isCorrect = message.contains('✅ تم تسجيل إجابتك وحصلت على');
        print("Answer correctness: $isCorrect");
        return Right(isCorrect);
      } else {
        print("Server error: $message");
        return Left(Failure(message));
      }
    } on DioException catch (e) {
      print("DioException: ${e.message}");
      return Left(Failure("يوجد خطأ في الاتصال بالخادم"));
    } catch (e) {
      print("Unexpected error: $e");
      return Left(Failure("حدث خطأ غير متوقع!"));
    }
  }

}

class QuestionsResponse {
  final bool success;
  final String message;
  final List<Question> questions;

  QuestionsResponse({
    required this.success,
    required this.message,
    required this.questions,
  });

  factory QuestionsResponse.fromJson(Map<String, dynamic> json) {
    return QuestionsResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      questions: (json['data'] as List<dynamic>?)
          ?.map((questionJson) => Question.fromJson(questionJson))
          .toList() ??
          [],
    );
  }
}

class Question {
  final String id;
  final String title;
  final List<String> options;

  Question({
    required this.id,
    required this.title,
    required this.options, required marks,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      options: (json['options'] as List<dynamic>?)?.cast<String>() ?? [], marks: 20,
    );
  }
}

class Failure {
  final String message;

  Failure(this.message);
}