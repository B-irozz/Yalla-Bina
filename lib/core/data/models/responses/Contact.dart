/// status : "success"
/// message : "Contacts retrieved successfully."
/// contacts : [{"label":"Omeir","value":"68038ecf29b484e0a519a7b6","profilePic":"https://res.cloudinary.com/dr1wyb9oq/image/upload/v1745063630/chating-app/User/2021163/2021163profilePic.jpg","randomId":2021163},{"label":"Yalla","value":"68040bdb0e65c8fdd7429fa3","profilePic":"https://res.cloudinary.com/dr1wyb9oq/image/upload/v1745095643/chating-app/User/7397023/7397023profilePic.jpg","randomId":7397023},{"label":"omeir","value":"680638cd76dbfe33e6d32aee","profilePic":"https://res.cloudinary.com/dr1wyb9oq/image/upload/v1745238220/chating-app/User/6001535/6001535profilePic.png","randomId":6001535},{"label":"Yalla","value":"68065ba9b2df9fd34451f97b","profilePic":"https://res.cloudinary.com/dr1wyb9oq/image/upload/v1745247144/chating-app/User/1664656/1664656profilePic.jpg","randomId":1664656},{"label":"Yalla","value":"68065c21b2df9fd34451f982","profilePic":"https://res.cloudinary.com/dr1wyb9oq/image/upload/v1745247264/chating-app/User/6953294/6953294profilePic.jpg","randomId":6953294}]
library;

class ContactsResponse {
  ContactsResponse({
      this.status, 
      this.message, 
      this.contacts,});

  ContactsResponse.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    if (json['contacts'] != null) {
      contacts = [];
      json['contacts'].forEach((v) {
        contacts?.add(ContactDM.fromJson(v));
      });
    }
  }
  String? status;
  String? message;
  List<ContactDM>? contacts;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    if (contacts != null) {
      map['contacts'] = contacts?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// label : "Omeir"
/// value : "68038ecf29b484e0a519a7b6"
/// profilePic : "https://res.cloudinary.com/dr1wyb9oq/image/upload/v1745063630/chating-app/User/2021163/2021163profilePic.jpg"
/// randomId : 2021163

class ContactDM {
  ContactDM({
      this.label, 
      this.value, 
      this.profilePic, 
      this.randomId,});

  ContactDM.fromJson(dynamic json) {
    label = json['label'];
    value = json['value'];
    profilePic = json['profilePic'];
    randomId = json['randomId'];
  }
  String? label;
  String? value;
  String? profilePic;
  num? randomId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['label'] = label;
    map['value'] = value;
    map['profilePic'] = profilePic;
    map['randomId'] = randomId;
    return map;
  }

}