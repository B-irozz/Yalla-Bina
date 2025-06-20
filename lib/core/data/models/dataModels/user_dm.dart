//
// import '../responses/user_profile/profile_response.dart';
//
// class UserDM {
//   UserDM({
//     this.username,
//     this.points,
//     this.notifications,});
//
//   UserDM.fromJson(dynamic json) {
//     username = json['username'];
//     points = json['Points'];
//     if (json['notifications'] != null) {
//       notifications = [];
//       json['notifications'].forEach((v) {
//         notifications?.add(Notifications.fromJson(v));
//       });
//     }
//   }
//   String? username;
//   num? points;
//   List<Notifications>? notifications;
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['username'] = username;
//     map['Points'] = points;
//     if (notifications != null) {
//       map['notifications'] = notifications?.map((v) => v.toJson()).toList();
//     }
//     return map;
//   }
//
// }
