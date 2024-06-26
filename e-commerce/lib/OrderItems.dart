class OrderItems {
  late String orderId;
  late String customerName;
  late String phoneNumber;
  late String address;
  late List<Map<String, dynamic>> productList;
  late double price;
  late int quantity;
  late double totalAmount;

  OrderItems({
    required this.orderId,
    required this.customerName,
    required this.phoneNumber,
    required this.address,
    required this.productList,
    required this.price,
    required this.totalAmount,
    required this.quantity,
  });

  Map<String, dynamic> toMap() {
    return {
      'ID đơn hàng': orderId,
      'Tên khách hàng': customerName,
      'Số điện thoại': phoneNumber,
      'Địa chỉ': address,
      'Thông tin sản phẩm': productList,
      'Giá': price,
      'Số lượng': quantity,
    };
  }

  factory OrderItems.fromMap(Map<dynamic, dynamic>? map) {
    if (map == null) {
      throw ArgumentError("Map cannot be null");
    }
    return OrderItems(
      orderId: map['ID đơn hàng'] ?? '',
      customerName: map['Tên khách hàng'] ?? '',
      phoneNumber: map['Số điện thoại'] ?? '',
      address: map['Địa chỉ'] ?? '',
      productList: (map['Thông tin sản phẩm'] as List<dynamic>)
          .map((item) => Map<String, dynamic>.from(item))
          .toList(),
      price: (map['Giá'] ?? 0.0).toDouble(),
      quantity: (map['Số lượng'] ?? 0).toInt(),
      totalAmount: (map['Tổng tiền'] ?? 0).toDouble(),
    );
  }
}
