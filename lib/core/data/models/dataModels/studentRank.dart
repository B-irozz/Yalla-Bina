class StudentRank {
  StudentRank({
      this.message, 
      this.ranks,});

  StudentRank.fromJson(dynamic json) {
    message = json['message'];
    if (json['ranks'] != null) {
      ranks = [];
      json['ranks'].forEach((v) {
        ranks?.add(Rank.fromJson(v));
      });
    }
  }
  String? message;
  List<Rank>? ranks;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = message;
    if (ranks != null) {
      map['ranks'] = ranks?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class Rank {
  Rank({
      this.id, 
      this.studentId, 
      this.name, 
      this.totalPoints, 
      this.rank, 
      this.updatedAt, 
      this.v, 
      this.profilePic, 
      this.profilePicPublicId,});

  Rank.fromJson(dynamic json) {
    id = json['_id'];
    studentId = json['studentId'];
    name = json['name'];
    totalPoints = json['totalPoints'];
    rank = json['rank'];
    updatedAt = json['updatedAt'];
    v = json['__v'];
    profilePic = json['profilePic'];
    profilePicPublicId = json['profilePicPublicId'];
  }
  String? id;
  num? studentId;
  String? name;
  num? totalPoints;
  num? rank;
  String? updatedAt;
  num? v;
  String? profilePic;
  String? profilePicPublicId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = id;
    map['studentId'] = studentId;
    map['name'] = name;
    map['totalPoints'] = totalPoints;
    map['rank'] = rank;
    map['updatedAt'] = updatedAt;
    map['__v'] = v;
    map['profilePic'] = profilePic;
    map['profilePicPublicId'] = profilePicPublicId;
    return map;
  }

}