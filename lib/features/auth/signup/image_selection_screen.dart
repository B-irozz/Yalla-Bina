import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:yallabina/features/auth/signup/signup_controller.dart';

class ImageSelectionScreen extends StatelessWidget {
  final SignUpController controller = Get.find();

   ImageSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Image')),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 4,
          mainAxisSpacing: 4,
        ),
        itemCount: controller.profileImages.length,
        itemBuilder: (context, index) {
          // Replace with actual image data from your repo
          final imageId = controller.profileImages[index].id;
          final imageUrl =controller.profileImages[index].image;

          return GestureDetector(
            onTap: () async {
              final imageUrl = controller.profileImages[index].image.secureUrl;
              final response = await http.get(Uri.parse(imageUrl));

              if (response.statusCode == 200) {
                final dir = await getApplicationDocumentsDirectory();
                final file = File('${dir.path}/profile_$imageId.jpg');

                await file.writeAsBytes(response.bodyBytes);
print(file.path);
                controller.selectedImagePath.value = file.path;
                Get.back();
              } else {
                Get.snackbar('Error', 'Failed to download image');
              }
            },

            child: Image.network(imageUrl.secureUrl),
          );
        },
      ),
    );
  }
}