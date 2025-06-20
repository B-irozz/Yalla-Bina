class CreateOrderRequest {
  final List<OrderProduct> products;
  final String address;
  final String phone;
  final String? notes;

  CreateOrderRequest({
    required this.products,
    required this.address,
    required this.phone,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'products': products.map((product) => product.toJson()).toList(),
      'address': address,
      'phone': phone,
    };
    if (notes != null) {
      data['notes'] = notes;
    }
    return data;
  }
}

class OrderProduct {
  final String productId;
  final int quantity;

  OrderProduct({
    required this.productId,
    required this.quantity,
  });

  Map<String, dynamic> toJson() => {
    'productId': productId,
    'quantity': quantity,
  };
}