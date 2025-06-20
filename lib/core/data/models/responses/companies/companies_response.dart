// category_models.dart

class CategoryResponse {
  final String message;
  final CategoryData data;

  CategoryResponse({
    required this.message,
    required this.data,
  });

  factory CategoryResponse.fromJson(Map<String, dynamic> json) {
    return CategoryResponse(
      message: json['message'] ?? '',
      data: CategoryData.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'data': data.toJson(),
    };
  }
}

class CategoryData {
  final List<Category> categories;

  CategoryData({
    required this.categories,
  });

  factory CategoryData.fromJson(Map<String, dynamic> json) {
    return CategoryData(
      categories: json['categories'] != null
          ? List<Category>.from(
          json['categories'].map((x) => Category.fromJson(x)))
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'categories': categories.map((x) => x.toJson()).toList(),
    };
  }
}

class Category {
  final CategoryName name;
  final CategoryImage image;
  final String id;
  final String updatedBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  Category({
    required this.name,
    required this.image,
    required this.id,
    required this.updatedBy,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      name: CategoryName.fromJson(json['name'] ?? {}),
      image: CategoryImage.fromJson(json['image'] ?? {}),
      id: json['_id'] ?? '',
      updatedBy: json['updatedBy'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name.toJson(),
      'image': image.toJson(),
      '_id': id,
      'updatedBy': updatedBy,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class CategoryName {
  final String en;
  final String ar;

  CategoryName({
    required this.en,
    required this.ar,
  });

  factory CategoryName.fromJson(Map<String, dynamic> json) {
    return CategoryName(
      en: json['en'] ?? '',
      ar: json['ar'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'en': en,
      'ar': ar,
    };
  }
}

class CategoryImage {
  final String secureUrl;
  final String publicId;

  CategoryImage({
    required this.secureUrl,
    required this.publicId,
  });

  factory CategoryImage.fromJson(Map<String, dynamic> json) {
    return CategoryImage(
      secureUrl: json['secure_url'] ?? '',
      publicId: json['public_id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'secure_url': secureUrl,
      'public_id': publicId,
    };
  }
}