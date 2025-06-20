class LoginResponse {
  LoginResponse({
    this.message,
    this.authorization,
    this.result,
  });

  LoginResponse.fromJson(dynamic json) {
    message = json['message'];
    authorization = json['authorization'] != null ? Authorization.fromJson(json['authorization']) : null;
    result = json['result'] != null ? UserDM.fromJson(json['result']) : null;
  }
  String? message;
  Authorization? authorization;
  UserDM? result;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = message;
    if (authorization != null) {
      map['authorization'] = authorization?.toJson();
    }
    if (result != null) {
      map['result'] = result?.toJson();
    }
    return map;
  }
}

class Authorization {
  Authorization({
    this.token,
  });

  Authorization.fromJson(dynamic json) {
    token = json['token'];
  }
  String? token;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['token'] = token;
    return map;
  }
}

class UserDM {
  UserDM({
    this.id,
    this.randomId,
    this.name,
    this.email,
    this.gradeLevelId,
    this.scientificTrack,
    this.subjects,
    this.password,
    this.status,
    this.availability,
    this.gender,
    this.role,
    this.isConfirmed,
    this.isDeleted,
    this.isBlocked,
    this.profilePic,
    this.profilePicPublicId,
    this.totalPoints,
    this.rank,
  });

  UserDM.fromJson(dynamic json) {
    id = json['_id'];
    randomId = json['randomId'];
    name = json['name'];
    email = json['email'];
    gradeLevelId = json['gradeLevelId'];
    scientificTrack = json['scientificTrack'];
    subjects = json['subjects'] != null ? List<int>.from(json['subjects']) : null;
    password = json['password'];
    status = json['status'];
    availability = json['availability'];
    gender = json['gender'];
    role = json['role'];
    isConfirmed = json['isConfirmed'];
    isDeleted = json['isDeleted'];
    isBlocked = json['isBlocked'];
    profilePic = json['profilePic'];
    profilePicPublicId = json['profilePicPublicId'];
    totalPoints = json['totalPoints'];
    rank = json['rank'];
  }

  String? id;
  int? randomId;
  String? name;
  String? email;
  int? gradeLevelId;
  int? scientificTrack;
  List<int>? subjects;
  String? password;
  String? status;
  String? availability;
  int? gender;
  String? role;
  bool? isConfirmed;
  bool? isDeleted;
  bool? isBlocked;
  String? profilePic;
  String? profilePicPublicId;
  int? totalPoints;
  int? rank;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = id;
    map['randomId'] = randomId;
    map['name'] = name;
    map['email'] = email;
    map['gradeLevelId'] = gradeLevelId;
    map['scientificTrack'] = scientificTrack;
    map['subjects'] = subjects;
    map['password'] = password;
    map['status'] = status;
    map['availability'] = availability;
    map['gender'] = gender;
    map['role'] = role;
    map['isConfirmed'] = isConfirmed;
    map['isDeleted'] = isDeleted;
    map['isBlocked'] = isBlocked;
    map['profilePic'] = profilePic;
    map['profilePicPublicId'] = profilePicPublicId;
    map['totalPoints'] = totalPoints;
    map['rank'] = rank;
    return map;
  }
}