import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import '../../models/failures.dart';
import '../../utils/shared_pref_utils.dart';

class ImagesRepo {
  Future<Either<Failure, List<ImageModel>>> getAllImages() async {
    print("Checking connectivity...");
    final List<ConnectivityResult> connectivityResult =
    await (Connectivity().checkConnectivity());
    print("Connectivity Result: $connectivityResult");

    if (connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.wifi) ||
        connectivityResult.contains(ConnectivityResult.ethernet)) {

      print("Connectivity is available. Proceeding with the API call.");

      try {
        String url = "https://yalaa-production.up.railway.app/auth/getAllImages";
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

        ImagesResponse imagesResponse = ImagesResponse.fromJson(json);
        print("Parsed ImagesResponse: ${imagesResponse.images}");

        if (response.statusCode! >= 200 && response.statusCode! < 300) {
          print("getAllImages success");
          final sharedPref = Get.find<SharedPrefUtils>();
          sharedPref.saveProfileImages(imagesResponse.images);
          return Right(imagesResponse.images);
        } else {
          print("getAllImages failed. Response Code: ${response.statusCode}");
          return Left(Failure(imagesResponse.message ?? "Something went wrong, please try again"));
        }
      } catch (e) {
        print("getAllImages DioError: $e");
        return Left(Failure("يوجد خطأ ما!"));
      }
    } else {
      print("No internet connection available.");
      return Left(Failure("لا يوجد اتصال بالانترنت!"));
    }
  }
}

// Response models
class ImagesResponse {
  final String message;
  final List<ImageModel> images;

  ImagesResponse({
    required this.message,
    required this.images,
  });

  factory ImagesResponse.fromJson(Map<String, dynamic> json) {
    // Convert the dynamic object map to a list of ImageModel
    List<ImageModel> images = [];
    if (json['data'] != null) {
      final dataMap = json['data'] as Map<String, dynamic>;
      images = dataMap.values
          .map((item) => ImageModel.fromJson(item))
          .toList();
    }

    return ImagesResponse(
      message: json['message'],
      images: images,
    );
  }
}

class ImageModel {
  final String id;
  final CloudinaryImage image;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;

  ImageModel({
    required this.id,
    required this.image,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(
      id: json['_id'],
      image: CloudinaryImage.fromJson(json['image']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      v: json['__v'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'image': image.toJson(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      '__v': v,
    };
  }
}

class CloudinaryImage {
  final String secureUrl;
  final String publicId;

  CloudinaryImage({
    required this.secureUrl,
    required this.publicId,
  });

  factory CloudinaryImage.fromJson(Map<String, dynamic> json) {
    return CloudinaryImage(
      secureUrl: json['secure_url'],
      publicId: json['public_id'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'secure_url': secureUrl,
      'public_id': publicId,
    };
  }
}
