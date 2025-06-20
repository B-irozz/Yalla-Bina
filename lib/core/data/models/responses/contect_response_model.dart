// class ContactModel {
//   final String id;
//   final String name;
//   final String email;
//   final String profilePic;
//   final String randomId;
//   final String status;
//   final String availability;
//
//   ContactModel({
//     required this.id,
//     required this.name,
//     required this.email,
//     required this.profilePic,
//     required this.randomId,
//     required this.status,
//     required this.availability,
//   });
//
//   factory ContactModel.fromJson(Map<String, dynamic> json) {
//     return ContactModel(
//       id: json['_id'] ?? '',
//       name: json['name'] ?? 'Unknown',
//       email: json['email'] ?? '',
//       profilePic: json['profilePic'] ?? '',
//       randomId: json['randomId'] ?? '',
//       status: json['status'] ?? 'Unknown',
//       availability: json['availability'] ?? 'Offline',
//     );
//   }
// }