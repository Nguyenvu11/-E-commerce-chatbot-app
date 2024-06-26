class VoucherCard {
  final String id;
  final String code;
  final double discount;

  VoucherCard({
    required this.id,
    required this.code,
    required this.discount
  });

  factory VoucherCard.fromMap(String id, Map<Object?, Object?>? data) {
    if (data == null) {
      return VoucherCard(id: '', code: '', discount: 0.0);
    }

    return VoucherCard(
      id: id,
      code: data['code']?.toString() ?? '',
      discount: (data['discount'] as num?)?.toDouble() ?? 0.0,
    );
  }


}