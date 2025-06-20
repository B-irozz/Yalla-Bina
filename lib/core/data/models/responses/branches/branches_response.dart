class BranchesResponse {
  BranchesResponse({
    this.message,
    this.data,
  });

  factory BranchesResponse.fromJson(Map<String, dynamic> json) {
    return BranchesResponse(
      message: json['message'] as String?,
      data: json['data'] != null
          ? BranchesData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }

  String? message;
  BranchesData? data;

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'data': data?.toJson(),
    };
  }
}

class BranchesData {
  BranchesData({
    this.branches,
  });

  factory BranchesData.fromJson(Map<String, dynamic> json) {
    return BranchesData(
      branches: json['branches'] != null
          ? List<Branch>.from(
        (json['branches'] as List).map(
              (x) => Branch.fromJson(x as Map<String, dynamic>),
        ),
      )
          : null,
    );
  }

  List<Branch>? branches;

  Map<String, dynamic> toJson() {
    return {
      'branches': branches?.map((x) => x.toJson()).toList(),
    };
  }
}

class Branch {
  Branch({
    this.name1,
    this.name2,
    this.address,
    this.id,
    this.phone,
    this.locationLink,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory Branch.fromJson(Map<String, dynamic> json) {
    return Branch(
      name1: json['name1'] != null
          ? Name1.fromJson(json['name1'] as Map<String, dynamic>)
          : null,
      name2: json['name2'] != null
          ? Name2.fromJson(json['name2'] as Map<String, dynamic>)
          : null,
      address: json['address'] != null
          ? Address.fromJson(json['address'] as Map<String, dynamic>)
          : null,
      id: json['_id'] as String?,
      phone: json['phone'] as num?,
      locationLink: json['locationLink'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      v: json['__v'] as num?,
    );
  }

  Name1? name1;
  Name2? name2;
  Address? address;
  String? id;
  num? phone;
  String? locationLink;
  String? createdAt;
  String? updatedAt;
  num? v;

  Map<String, dynamic> toJson() {
    return {
      'name1': name1?.toJson(),
      'name2': name2?.toJson(),
      'address': address?.toJson(),
      '_id': id,
      'phone': phone,
      'locationLink': locationLink,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': v,
    };
  }
}

class Address {
  Address({
    this.en,
    this.ar,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      en: json['en'] as String?,
      ar: json['ar'] as String?,
    );
  }

  String? en;
  String? ar;

  Map<String, dynamic> toJson() {
    return {
      'en': en,
      'ar': ar,
    };
  }
}

class Name2 {
  Name2({
    this.en,
    this.ar,
  });

  factory Name2.fromJson(Map<String, dynamic> json) {
    return Name2(
      en: json['en'] as String?,
      ar: json['ar'] as String?,
    );
  }

  String? en;
  String? ar;

  Map<String, dynamic> toJson() {
    return {
      'en': en,
      'ar': ar,
    };
  }
}

class Name1 {
  Name1({
    this.en,
    this.ar,
  });

  factory Name1.fromJson(Map<String, dynamic> json) {
    return Name1(
      en: json['en'] as String?,
      ar: json['ar'] as String?,
    );
  }

  String? en;
  String? ar;

  Map<String, dynamic> toJson() {
    return {
      'en': en,
      'ar': ar,
    };
  }
}