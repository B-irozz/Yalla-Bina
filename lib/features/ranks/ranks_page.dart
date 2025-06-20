import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/data/models/dataModels/studentRank.dart';
import 'ranks_controller.dart';

class RanksScreen extends StatelessWidget {
  RanksScreen({super.key});

  final RanksController controller = Get.put(RanksController());

  @override
  Widget build(BuildContext context) {
    controller.fetchStudentsRanks();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leaderboard'),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.isNotEmpty) {
          return Center(child: Text(controller.errorMessage.value));
        }

        return SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              // Top 3 ranks with special styling
              if (controller.ranks.length >= 3) _buildTopThree(),
              // Other ranks
              _buildOtherRanks(),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildTopThree() {
    return Column(
      children: [
        // Second place (left side)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildRankCard(controller.ranks[1], 2, Colors.grey[300]!),
            // First place (center, larger)
            _buildRankCard(controller.ranks[0], 1, Colors.amber, isTop: true),
            // Third place (right side)
            _buildRankCard(controller.ranks[2], 3, Colors.brown[300]!),
          ],
        ),
        const SizedBox(height: 30),
      ],
    );
  }

  Widget _buildOtherRanks() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: controller.ranks.length > 3 ? controller.ranks.length - 3 : 0,
      itemBuilder: (context, index) {
        final rankIndex = index + 3;
        final rank = controller.ranks[rankIndex];
        return _buildRankItem(rank, rankIndex + 1);
      },
    );
  }

  Widget _buildRankCard(Rank rank, int position, Color color, {bool isTop = false}) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.topCenter,
          children: [
            // Podium base
            Container(
              width: isTop ? 100 : 80,
              height: isTop ? 60 : 80 - (position * 10),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            // Profile and rank info
            Column(
              children: [
                CircleAvatar(
                  radius: isTop ? 40 : 30,
                  backgroundImage: NetworkImage(rank.profilePic??""),
                ),
                const SizedBox(height: 8),
                Text(
                  rank.name!,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: isTop ? 18 : 16,
                  ),
                ),
                Text(
                  '${rank.totalPoints} pts',
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    border: Border.all(color: Colors.grey),
                  ),
                  child: Text(
                    position.toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: isTop ? 20 : 16,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRankItem(Rank rank, int position) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(rank.profilePic??""),
      ),
      title: Text(rank.name!),
      subtitle: Text('${rank.totalPoints} points'),
      trailing: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey[200],
        ),
        child: Text(
          position.toString(),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}