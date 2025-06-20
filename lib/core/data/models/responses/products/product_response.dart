// class ProductsResponse {
//   final String message;
//   final ProductsData data;
//
//   ProductsResponse({
//     required this.message,
//     required this.data,
//   });
//
//   factory ProductsResponse.fromJson(Map<String, dynamic> json) {
//     return ProductsResponse(
//       message: json['message'],
//       data: ProductsData.fromJson(json['data']),
//     );
//   }
// }
//
// class ProductsData {
//   final List<Product> products;
//   final Pagination pagination;
//   final ProductCategory category;
//
//   ProductsData({
//     required this.products,
//     required this.pagination,
//     required this.category,
//   });
//
//   factory ProductsData.fromJson(Map<String, dynamic> json) {
//     return ProductsData(
//       products: List<Product>.from(
//           json['products'].map((x) => Product.fromJson(x))),
//       pagination: Pagination.fromJson(json['pagination']),
//       category: ProductCategory.fromJson(json['category']),
//     );
//   }
// }
//
// class Product {
//   final int number;
//   final LocalizedText name1;
//   final LocalizedText name2;
//   final LocalizedText country;
//   final LocalizedText description;
//   final LocalizedText quantity;
//   final String id;
//   final int newPrice;
//   final int oldPrice;
//   final List<ProductImage> images;
//   final ProductCategory category;
//
//   Product({
//     required this.number,
//     required this.name1,
//     required this.name2,
//     required this.country,
//     required this.description,
//     required this.quantity,
//     required this.id,
//     required this.newPrice,
//     required this.oldPrice,
//     required this.images,
//     required this.category,
//   });
//
//   factory Product.fromJson(Map<String, dynamic> json) {
//     return Product(
//       number: json['number'],
//       name1: LocalizedText.fromJson(json['name1']),
//       name2: LocalizedText.fromJson(json['name2']),
//       country: LocalizedText.fromJson(json['country']),
//       description: LocalizedText.fromJson(json['description']),
//       quantity: LocalizedText.fromJson(json['quantity']),
//       id: json['_id'],
//       newPrice: json['newprice'],
//       oldPrice: json['oldprice'],
//       images: List<ProductImage>.from(
//           json['image'].map((x) => ProductImage.fromJson(x))),
//       category: ProductCategory.fromJson(json['category']),
//     );
//   }
//
//   // Helper method to get discount percentage
//   int get discountPercentage {
//     if (oldPrice == 0) return 0;
//     return ((oldPrice - newPrice) / oldPrice * 100).round();
//   }
// }
//
// class ProductImage {
//   final String secureUrl;
//   final String publicId;
//   final String id;
//
//   ProductImage({
//     required this.secureUrl,
//     required this.publicId,
//     required this.id,
//   });
//
//   factory ProductImage.fromJson(Map<String, dynamic> json) {
//     return ProductImage(
//       secureUrl: json['secure_url'],
//       publicId: json['public_id'],
//       id: json['_id'],
//     );
//   }
// }
//
// class ProductCategory {
//   final LocalizedText name;
//   final String id;
//
//   ProductCategory({
//     required this.name,
//     required this.id,
//   });
//
//   factory ProductCategory.fromJson(Map<String, dynamic> json) {
//     return ProductCategory(
//       name: LocalizedText.fromJson(json['name']),
//       id: json['_id'],
//     );
//   }
// }
//
// class LocalizedText {
//   final String en;
//   final String ar;
//
//   LocalizedText({
//     required this.en,
//     required this.ar,
//   });
//
//   factory LocalizedText.fromJson(Map<String, dynamic> json) {
//     return LocalizedText(
//       en: json['en'],
//       ar: json['ar'],
//     );
//   }
//
//   // Helper method to get text based on current locale
//   String getText(String locale) {
//     return locale == 'ar' ? ar : en;
//   }
// }
//
// class Pagination {
//   final int totalProducts;
//   final int totalPages;
//   final int currentPage;
//   final int limit;
//
//   Pagination({
//     required this.totalProducts,
//     required this.totalPages,
//     required this.currentPage,
//     required this.limit,
//   });
//
//   factory Pagination.fromJson(Map<String, dynamic> json) {
//     return Pagination(
//       totalProducts: json['totalProducts'],
//       totalPages: json['totalPages'],
//       currentPage: json['currentPage'],
//       limit: json['limit'],
//     );
//   }
// }