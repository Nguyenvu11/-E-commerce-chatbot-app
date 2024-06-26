// ignore_for_file: prefer_const_constructors, library_private_types_in_public_api, file_names

import 'package:coffee_house/admin/ProfileAdminScreen/VoucherPageAdmin.dart';
import 'package:coffee_house/main.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:coffee_house/VoucherCard.dart';

class VoucherPage extends StatefulWidget {
  const VoucherPage({Key? key}) : super(key: key);

  @override
  _VoucherPageState createState() => _VoucherPageState();
}

class _VoucherPageState extends State<VoucherPage> {

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
                            trailing: IconButton(
                              icon: Icon(Icons.save,color: Colors.blue,),
                              onPressed: () {
                                saveVoucher(voucher);
                              },
                            ),
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
            SizedBox(height: 20),
            Text(
              'Mã của tôi',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: StreamBuilder(
                stream: usersRefVoucher.onValue,
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
                            trailing: IconButton(
                              icon: Icon(Icons.delete,color: Colors.red,),
                              onPressed: () {
                                // Xử lý sự kiện xóa mã giảm giá
                                deleteVoucher(voucher.id);
                              },
                            ),
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
          ],
        ),
      ),
    );
  }

  void saveVoucher(VoucherCard voucher) {
    usersRefVoucher.child(voucher.id).set(voucher.toJson());
    displayToastMessage("Lưu mã giảm giá thành công", context);
  }

  void deleteVoucher(String voucherId) {
    usersRefVoucher.child(voucherId).remove();
    displayToastMessage("Xóa mã giảm giá thành công", context);
  }


  void displayToastMessage(String message, BuildContext context) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
