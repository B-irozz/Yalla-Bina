class ProductsResponse {
  ProductsResponse({
    this.message,
    this.data,});

  ProductsResponse.fromJson(dynamic json) {
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

class Data {
  Data({
    this.products,
    this.pagination,});

  Data.fromJson(dynamic json) {
    if (json['products'] != null) {
      products = [];
      json['products'].forEach((v) {
        products?.add(ProductDM.fromJson(v));
      });
    }
    pagination = json['pagination'] != null ? Pagination.fromJson(json['pagination']) : null;
  }
  List<ProductDM>? products;
  Pagination? pagination;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (products != null) {
      map['products'] = products?.map((v) => v.toJson()).toList();
    }
    if (pagination != null) {
      map['pagination'] = pagination?.toJson();
    }
    return map;
  }
}

class Pagination {
  Pagination({
    this.totalProducts,
    this.totalPages,
    this.currentPage,
    this.limit,});

  Pagination.fromJson(dynamic json) {
    totalProducts = json['totalProducts'];
    totalPages = json['totalPages'];
    currentPage = json['currentPage'];
    limit = json['limit'];
  }
  num? totalProducts;
  num? totalPages;
  num? currentPage;
  num? limit;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['totalProducts'] = totalProducts;
    map['totalPages'] = totalPages;
    map['currentPage'] = currentPage;
    map['limit'] = limit;
    return map;
  }
}

class ProductDM {
  ProductDM({
    this.number,
    this.name1,
    this.name2,
    this.country,
    this.storageCondition,
    this.description,
    this.quantity,
    this.id,
    this.animalTypes,
    this.tableData,
    this.newprice,
    this.oldprice,
    this.image,});

  ProductDM.fromJson(dynamic json) {
    number = json['number'];
    name1 = json['name1'] != null ? Name.fromJson(json['name1']) : null;
    name2 = json['name2'] != null ? Name.fromJson(json['name2']) : null;
    country = json['country'] != null ? Country.fromJson(json['country']) : null;
    storageCondition = json['stoargecondition'] != null ? Name.fromJson(json['stoargecondition']) : null;
    description = json['description'] != null ? Description.fromJson(json['description']) : null;
    quantity = json['quantity'] != null ? Quantity.fromJson(json['quantity']) : null;
    id = json['_id'];
    animalTypes = json['animalTypes'] != null ? List<String>.from(json['animalTypes']) : null;
    if (json['tableData'] != null) {
      tableData = [];
      json['tableData'].forEach((v) {
        tableData?.add(TableData.fromJson(v));
      });
    }
    newprice = json['newprice'];
    oldprice = json['oldprice'];
    if (json['image'] != null) {
      image = [];
      json['image'].forEach((v) {
        image?.add(ImageDM.fromJson(v));
      });
    }
    isFavorite = false;
  }
  num? number;
  Name? name1;
  Name? name2;
  Country? country;
  Name? storageCondition;
  Description? description;
  Quantity? quantity;
  String? id;
  List<String>? animalTypes;
  List<TableData>? tableData;
  num? newprice;
  num? oldprice;
  List<ImageDM>? image;
  bool? isFavorite;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['number'] = number;
    if (name1 != null) {
      map['name1'] = name1?.toJson();
    }
    if (name2 != null) {
      map['name2'] = name2?.toJson();
    }
    if (country != null) {
      map['country'] = country?.toJson();
    }
    if (storageCondition != null) {
      map['stoargecondition'] = storageCondition?.toJson();
    }
    if (description != null) {
      map['description'] = description?.toJson();
    }
    if (quantity != null) {
      map['quantity'] = quantity?.toJson();
    }
    map['_id'] = id;
    if (animalTypes != null) {
      map['animalTypes'] = animalTypes;
    }
    if (tableData != null) {
      map['tableData'] = tableData?.map((v) => v.toJson()).toList();
    }
    map['newprice'] = newprice;
    map['oldprice'] = oldprice;
    if (image != null) {
      map['image'] = image?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class TableData {
  TableData({
    this.name,
    this.value,
    this.id,
  });

  TableData.fromJson(dynamic json) {
    name = json['name'] != null ? Name.fromJson(json['name']) : null;
    value = json['value'] != null ? Name.fromJson(json['value']) : null;
    id = json['_id'];
  }
  Name? name;
  Name? value;
  String? id;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (name != null) {
      map['name'] = name?.toJson();
    }
    if (value != null) {
      map['value'] = value?.toJson();
    }
    map['_id'] = id;
    return map;
  }
}

class ImageDM {
  ImageDM({
    this.secureUrl,
    this.publicId,
    this.id,});

  ImageDM.fromJson(dynamic json) {
    secureUrl = json['secure_url'];
    publicId = json['public_id'];
    id = json['_id'];
  }
  String? secureUrl;
  String? publicId;
  String? id;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['secure_url'] = secureUrl;
    map['public_id'] = publicId;
    map['_id'] = id;
    return map;
  }
}

class Quantity {
  Quantity({
    this.en,
    this.ar,});

  Quantity.fromJson(dynamic json) {
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

class Description {
  Description({
    this.en,
    this.ar,});

  Description.fromJson(dynamic json) {
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

class Country {
  Country({
    this.en,
    this.ar,});

  Country.fromJson(dynamic json) {
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