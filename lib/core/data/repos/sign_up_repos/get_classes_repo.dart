import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:yallabina/core/data/utils/shared_pref_utils.dart';

import '../../models/failures.dart';

class ClassesRepo {
  Future<Either<Failure, List<Class>>> getAllClasses() async {
    print("Checking connectivity...");
    final List<ConnectivityResult> connectivityResult =
    await (Connectivity().checkConnectivity());
    print("Connectivity Result: $connectivityResult");

    if (connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.wifi) ||
        connectivityResult.contains(ConnectivityResult.ethernet)) {
      print("Connectivity is available. Proceeding with the API call.");

      try {
        String url =
            "http://exammatchingapp-production.up.railway.app/api/grade-levels";
        print("Final URL: $url");

        Dio dio = Dio();
        Response response = await dio.get(
          url,
          options: Options(
            validateStatus: (status) {
              return status! < 500;
            },
          ),
        );

        var json = response.data;
        print("Response data: $json");

        // Convert the list of maps into List<Class>
        final List<Class> classList = (json as List)
            .map((item) => Class.fromJson(item as Map<String, dynamic>))
            .toList();

        print("Parsed class list: $classList");

        if (response.statusCode! >= 200 && response.statusCode! < 300) {
          print("getAllClasses success");
          final sharedPref = Get.find<SharedPrefUtils>();
          sharedPref.saveClasses(classList);

          return Right(classList);
        } else {
          print("getAllClasses failed. Response Code: ${response.statusCode}");
          return Left(Failure("حدث خطأ أثناء جلب الصفوف، حاول مرة أخرى"));
        }
      } catch (e) {
        print("getAllClasses DioError: $e");
        return Left(Failure("يوجد خطأ ما!"));
      }
    } else {
      print("No internet connection available.");
      return Left(Failure("لا يوجد اتصال بالانترنت!"));
    }
  }
}


class Class {
  final String id;
  final String name;
  final String levelId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;

  Class({
    required this.id,
    required this.name,
    required this.levelId,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory Class.fromJson(Map<String, dynamic> json) {
    return Class(
      id: json['_id'],
      name: json['name'],
      levelId: json['gradeLevelId'].toString(), // convert int to String if needed
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      v: json['__v'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'gradeLevelId': levelId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      '__v': v,
    };
  }
}

