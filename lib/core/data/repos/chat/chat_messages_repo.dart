  import 'package:dartz/dartz.dart';
  import 'package:dio/dio.dart';
  import 'package:get/get.dart';
  import '../../../../features/chat/chatting/message_model.dart';
  import '../../models/failures.dart';
  import '../../utils/end_points.dart';
  import '../../utils/shared_pref_utils.dart';

  class ChatMessages {
    final Dio dio = Get.find<Dio>();
    final SharedPrefUtils sharedPrefUtils = Get.find<SharedPrefUtils>();

    Future<Either<Failure, MessagesResponseDm>> getMessages(String receiverId) async {
      try {
        final token = await sharedPrefUtils.getToken();
        if (token == null) {
          return Left(Failure("No token found"));
        }

        print("Using Token: $token");

        print("Sending request to ${EndPoints.baseUrl}/message/getMessages/$receiverId");
        print("Headers: {Authorization: $token}");

        final response = await dio.post(
          "${EndPoints.baseUrl}/message/getMessages/$receiverId",
          options: Options(
            headers: {
              'Authorization': token,
            },
          ),
        );

        print("Response Status Code: ${response.statusCode}");
        print("Response Data: ${response.data}");

        if (response.statusCode! >= 200 && response.statusCode! < 300) {
          final messagesResponse = MessagesResponseDm.fromJson(response.data);
          return Right(messagesResponse);
        } else {
          print("Error response data: ${response.data}");
          return Left(Failure(response.data['message'] ?? "Failed to fetch messages"));
        }
      } on DioException catch (e) {
        print("DioException: ${e.response?.data}");
        final message = e.response?.data is Map && e.response?.data['message'] != null
            ? e.response!.data['message']
            : e.message ?? "Network error occurred";
        return Left(Failure(message));
      } catch (e) {
        print("Unexpected error: $e");
        return Left(Failure("An unexpected error occurred"));
      }
    }
  }

  class MessagesResponseDm {
    final String status;
    final String message;
    final List<Message> result;

    MessagesResponseDm({
      required this.status,
      required this.message,
      required this.result,
    });

    factory MessagesResponseDm.fromJson(Map<String, dynamic> json) {
      return MessagesResponseDm(
        status: json['status'],
        message: json['message'],
        result: (json['result'] as List)
            .map((messageJson) => Message.fromJson(messageJson))
            .toList(),
      );
    }
  }