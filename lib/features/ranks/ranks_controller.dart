import 'package:get/get.dart';
import 'package:yallabina/core/data/models/dataModels/studentRank.dart';
import 'package:yallabina/core/data/repos/ranks/ranks_repo.dart';

class RanksController extends GetxController {
  RanksRepo repo=RanksRepo();
  final RxList<Rank> ranks = <Rank>[].obs;
  final RxBool isLoading = true.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchStudentsRanks();
  }

  // Future<void> fetchRanks() async {
  //   try {
  //     isLoading.value = true;
  //     errorMessage.value = '';
  //
  //     final response = await _dio.get(
  //       'https://exammatchingapp-production.up.railway.app/api/ranks',
  //     );
  //
  //     if (response.statusCode == 200) {
  //       final List<dynamic> ranksData = response.data['ranks'];
  //       ranks.assignAll(ranksData.map((e) => RankDm.fromJson(e)).toList());
  //     } else {
  //       errorMessage.value = response.data['message'] ?? 'Failed to fetch ranks';
  //     }
  //   } on DioException catch (e) {
  //     errorMessage.value = e.response?.data['message'] ?? 'Network error occurred';
  //   } catch (e) {
  //     errorMessage.value = 'An unexpected error occurred';
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }
  Future<void> fetchStudentsRanks() async {
    isLoading(true);
    try {
      final result = await repo.getRanks();

      result.fold(
            (failure) {
          // Handle failure case
          Get.snackbar('Error', failure.errorMessage);
        },
            (response) {
              final List<Rank>? ranksData = response.ranks;
              ranks.assignAll(ranksData!);
          }

      );
    } catch (e) {
      print('Error loading previous messages: $e');
      Get.snackbar('Error', 'Failed to load messages');
    } finally {
      isLoading(false);
    }
  }

}

class RankDm {
  final String id;
  final int studentId;
  final String name;
  final int totalPoints;
  final int rank;
  final String profilePic;

  RankDm({
    required this.id,
    required this.studentId,
    required this.name,
    required this.totalPoints,
    required this.rank,
    required this.profilePic,
  });

  factory RankDm.fromJson(Map<String, dynamic> json) {
    return RankDm(
      id: json['_id'],
      studentId: json['studentId'],
      name: json['name'],
      totalPoints: json['totalPoints'],
      rank: json['rank'],
      profilePic: json['profilePic'],
    );
  }
}