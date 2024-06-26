// ignore_for_file: unnecessary_this

class CartItem {
  final String id;
  final String image;
  final String name;
  final int price;
  final int quantity;

  CartItem({
    required this.id,
    required this.image,
    required this.name,
    required this.price,
    required this.quantity,
  });

  factory CartItem.fromMap(String id, Map<dynamic, dynamic> map) {
    return CartItem(
      id: id,
      image: map['image']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
      price: map['price'] as int? ?? 0,
      quantity: map['quantity'] as int? ?? 0,
    );
  }
  CartItem copyWith({int? quantity}) {
    return CartItem(
      id: this.id,
      image: this.image,
      name: this.name,
      price: this.price,
      quantity: quantity ?? this.quantity,
    );
  }
}