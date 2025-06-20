import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yallabina/features/chat/chatting/chatting_screen.dart';
import 'chat_screen_controller.dart';


class ChatContactsScreen extends StatelessWidget {
  final ContactController _contactController = Get.put(ContactController());

  ChatContactsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacts'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(
            child: Obx(() {
              if (_contactController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              return _buildContactList();
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search by name or ID',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onChanged: (query) => _contactController.filterContacts(query),
      ),
    );
  }

  Widget _buildContactList() {

    return ListView.builder(
      itemCount: _contactController.filteredContacts.length,
      itemBuilder: (context, index) {
        final contact = _contactController.filteredContacts[index];
        return InkWell(

          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(contact.profilePic!),
              radius: 25,
            ),
            title: Text(contact.label!),
            subtitle: Text(contact.randomId.toString()),
            trailing: _buildStatusIndicator(contact.value!),
            onTap: (){
              Get.to(()=>ChatScreen( receiverId:  contact.value!, receiverName: contact.label!, currentUserId: _contactController.userDM!.id.toString(),));
            },
          ),
        );
      },
    );
  }

  Widget _buildStatusIndicator(String availability) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: availability == 'Online' ? Colors.green : Colors.grey,
        shape: BoxShape.circle,
      ),
    );
  }
}