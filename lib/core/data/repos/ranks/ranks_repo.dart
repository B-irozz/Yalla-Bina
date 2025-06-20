import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../../models/dataModels/studentRank.dart';
import '../../models/failures.dart';

class RanksRepo{
  final Dio dio = Get.find<Dio>();


  Future<Either<Failure, StudentRank>> getRanks() async {
    try {
      print('Sending request to https://exammatchingapp-production.up.railway.app/api/ranks'); // Debug print

      // Make the request
      final response = await dio.request(
        'https://exammatchingapp-production.up.railway.app/api/ranks',
        options: Options(method: 'GET'),
      );

      print('Response received: ${response.statusCode}'); // Debug print

      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        print('Response data: ${response.data}'); // Debug print
        final ranksResponse = StudentRank.fromJson(response.data);
        return Right(ranksResponse);
      } else {
        print('Error response data: ${response.data}'); // Debug print
        return Left(
          Failure(response.data['message'] ?? 'Failed to fetch ranks'),
        );
      }
    } on DioException catch (e) {
      print('DioException: ${e.response?.data}'); // Debug print
      return Left(
        Failure(e.response?.data['message'] ?? 'Network error occurred'),
      );
    } catch (e) {
      print('Unexpected error: $e'); // Debug print
      return Left(Failure('An unexpected error occurred'));
    }
  }

}
// class RanksResponseDm {
//   final String message;
//   final List<RankDm> ranks;
//
//   RanksResponseDm({
//     required this.message,
//     required this.ranks,
//   });
//
//   factory RanksResponseDm.fromJson(Map<String, dynamic> json) {
//     return RanksResponseDm(
//       message: json['message'],
//       ranks: (json['ranks'] as List).map((e) => RankDm.fromJson(e)).toList(),
//     );
//   }
// }
//
// class RankDm {
//   final String id;
//   final int studentId;
//   final String name;
//   final int totalPoints;
//   final int rank;
//   final String updatedAt;
//   final int v;
//   final String profilePic;
//   final String profilePicPublicId;
//
//   RankDm({
//     required this.id,
//     required this.studentId,
//     required this.name,
//     required this.totalPoints,
//     required this.rank,
//     required this.updatedAt,
//     required this.v,
//     required this.profilePic,
//     required this.profilePicPublicId,
//   });
//
//   factory RankDm.fromJson(Map<String, dynamic> json) {
//     return RankDm(
//       id: json['_id'],
//       studentId: json['studentId'],
//       name: json['name'],
//       totalPoints: json['totalPoints'],
//       rank: json['rank'],
//       updatedAt: json['updatedAt'],
//       v: json['__v'],
//       profilePic: json['profilePic'],
//       profilePicPublicId: json['profilePicPublicId'],
//     );
//   }
// }