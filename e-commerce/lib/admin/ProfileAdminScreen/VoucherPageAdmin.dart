// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, deprecated_member_use, override_on_non_overriding_member, library_private_types_in_public_api

import 'package:coffee_house/VoucherCard.dart';
import 'package:coffee_house/admin/AllAdminScreen/RegisterAdminScreen.dart';
import 'package:coffee_house/main.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class VoucherPage extends StatefulWidget {
  const VoucherPage({Key? key}) : super(key: key);

  @override
  _VoucherPageState createState() => _VoucherPageState();
}

class _VoucherPageState extends State<VoucherPage> {
  final TextEditingController codeController = TextEditingController();
  final TextEditingController discountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Mã Khuyến Mãi',
          style: TextStyle(
            color: Colors.lime,
          ),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Text(
              'Danh sách mã giảm giá:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: StreamBuilder(
                stream: Voucher.onValue,
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data != null) {
                    DataSnapshot dataSnapshot = snapshot.data!.snapshot;

                    List<VoucherCard> vouchers = [];

                    if (dataSnapshot.value != null && dataSnapshot.value is Map) {
                      (dataSnapshot.value as Map).forEach((key, value) {
                        VoucherCard voucherCard = VoucherCard(
                          id: key,
                          code: value['code'] ?? '',
                          discount: (value['discount'] as num?)?.toDouble() ?? 0.0,
                        );
                        vouchers.add(voucherCard);
                      });
                    }
                    return ListView.builder(
                      itemCount: vouchers.length,
                      itemBuilder: (context, index) {
                        VoucherCard voucher = vouchers[index];
                        return Card(
                          elevation: 3,
                          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          child: ListTile(
                            title: Text('Mã: ${voucher.code}'),
                            subtitle: Text('Giảm giá: ${voucher.discount}%'),
                          ),
                        );
                      },
                    );
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              ),
            ),
            Text(
              'Tạo mới mã khuyến mãi:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: codeController,
              decoration: InputDecoration(
                labelText: 'Mã Khuyến Mãi',
              ),
            ),
            TextField(
              controller: discountController,
              decoration: InputDecoration(
                labelText: 'Giảm Giá (%)',
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                createVoucher();
              },
              child: Text('Tạo Mã Khuyến Mãi'),
            ),
          ],
        ),
      ),
    );
  }
  void createVoucher() {
    String code = codeController.text.trim();
    double discount = double.tryParse(discountController.text) ?? 0.0;

    if (code.isNotEmpty && discount > 0) {

      VoucherCard voucherCard = VoucherCard(
        id: Voucher.push().key ?? '',
        code: code,
        discount: discount,
      );
      Voucher.child(voucherCard.id).set(voucherCard.toJson());
      codeController.clear();
      discountController.clear();
      displayToastMessage("Thêm mã thành công", context);
    } else {
      displayToastMessage("Lỗi khi thêm mã", context);
    }
  }
}

extension VoucherCardExtension on VoucherCard {
  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'discount': discount,
    };
  }
}