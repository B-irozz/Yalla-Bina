/// message : "department retrieved successfully!"
/// data : {"department":[{"name":{"en":"Departmentsh","ar":"القسم الفرنسيه"},"_id":"67ed3f58fa1156b1a6f91b64","updatedBy":"67e72de90003fff3ed8e20e2","createdAt":"2025-04-02T13:44:56.229Z","updatedAt":"2025-04-02T17:36:29.554Z"},{"name":{"en":"Department Name in English","ar":"اسم القسم الفرنسيه"},"_id":"67ed3f60fa1156b1a6f91b67","updatedBy":"67e72de90003fff3ed8e20e2","createdAt":"2025-04-02T13:45:04.726Z","updatedAt":"2025-04-02T13:45:04.726Z"},{"name":{"en":"Department Name in English","ar":"اسم القسم الفرنسيه"},"_id":"67ed755cf2d9de8aa6c3cb6f","updatedBy":"67e72de90003fff3ed8e20e2","createdAt":"2025-04-02T17:35:24.944Z","updatedAt":"2025-04-02T17:35:24.944Z"}]}
library;

class CategoriesResponseDm {
  CategoriesResponseDm({
      this.message, 
      this.data,});

  CategoriesResponseDm.fromJson(dynamic json) {
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  String? message;
  Data? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = message;
    if (data != null) {
      map['data'] = data?.toJson();
    }
    return map;
  }

}

/// department : [{"name":{"en":"Departmentsh","ar":"القسم الفرنسيه"},"_id":"67ed3f58fa1156b1a6f91b64","updatedBy":"67e72de90003fff3ed8e20e2","createdAt":"2025-04-02T13:44:56.229Z","updatedAt":"2025-04-02T17:36:29.554Z"},{"name":{"en":"Department Name in English","ar":"اسم القسم الفرنسيه"},"_id":"67ed3f60fa1156b1a6f91b67","updatedBy":"67e72de90003fff3ed8e20e2","createdAt":"2025-04-02T13:45:04.726Z","updatedAt":"2025-04-02T13:45:04.726Z"},{"name":{"en":"Department Name in English","ar":"اسم القسم الفرنسيه"},"_id":"67ed755cf2d9de8aa6c3cb6f","updatedBy":"67e72de90003fff3ed8e20e2","createdAt":"2025-04-02T17:35:24.944Z","updatedAt":"2025-04-02T17:35:24.944Z"}]

class Data {
  Data({
      this.categories,});

  Data.fromJson(dynamic json) {
    if (json['department'] != null) {
      categories = [];
      json['department'].forEach((v) {
        categories?.add(Department.fromJson(v));
      });
    }
  }
  List<Department>? categories;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (categories != null) {
      map['department'] = categories?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// name : {"en":"Departmentsh","ar":"القسم الفرنسيه"}
/// _id : "67ed3f58fa1156b1a6f91b64"
/// updatedBy : "67e72de90003fff3ed8e20e2"
/// createdAt : "2025-04-02T13:44:56.229Z"
/// updatedAt : "2025-04-02T17:36:29.554Z"

class Department {
  Department({
      this.name, 
      this.id, 
      this.updatedBy, 
      this.createdAt, 
      this.updatedAt,});

  Department.fromJson(dynamic json) {
    name = json['name'] != null ? Name.fromJson(json['name']) : null;
    id = json['_id'];
    updatedBy = json['updatedBy'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }
  Name? name;
  String? id;
  String? updatedBy;
  String? createdAt;
  String? updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (name != null) {
      map['name'] = name?.toJson();
    }
    map['_id'] = id;
    map['updatedBy'] = updatedBy;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    return map;
  }

}

/// en : "Departmentsh"
/// ar : "القسم الفرنسيه"

class Name {
  Name({
      this.en, 
      this.ar,});

  Name.fromJson(dynamic json) {
    en = json['en'];
    ar = json['ar'];
  }
  String? en;
  String? ar;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['en'] = en;
    map['ar'] = ar;
    return map;
  }

}