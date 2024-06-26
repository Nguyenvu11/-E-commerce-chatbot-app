// ignore_for_file: prefer_const_constructors, library_private_types_in_public_api, file_names, avoid_print

import 'package:coffee_house/OrderItems.dart';
import 'package:coffee_house/user/ProfileUserScreen/HistoryItems.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:coffee_house/user/ConfigsUser.dart';

class PurchaseHistoryPage extends StatefulWidget {
  const PurchaseHistoryPage({Key? key}) : super(key: key);

  @override
  _PurchaseHistoryPageState createState() => _PurchaseHistoryPageState();
}

class _PurchaseHistoryPageState extends State<PurchaseHistoryPage> {
  List<OrderItems> orderHistory = [];

  @override
  void initState() {
    super.initState();
    getCurrentUserInfo();
  }
  void getCurrentUserInfo() async {
    DatabaseReference historyRef =
    FirebaseDatabase.instance.ref().child('users').child(currentfirebaseUser!.uid).child('HistoryOrders');
    historyRef.onValue.listen((DatabaseEvent event) {
      DataSnapshot snapshot = event.snapshot;
      if (snapshot.value != null) {
        setState(() {
          orderHistory = [];
          if (snapshot.value is Map) {
            (snapshot.value as Map).forEach((orderId, orderData) {
              OrderItems orderItem = OrderItems.fromMap(orderData);
              orderHistory.add(orderItem);
              print(orderItem.productList);
            });
          } else if (snapshot.value is Iterable) {
            List<dynamic> orderItemsList = snapshot.value as List;
            orderHistory = orderItemsList.map((item) => OrderItems.fromMap(item as Map)).toList();
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Hóa Đơn Mua Hàng',
          style: TextStyle(
            color: Colors.lime,
          ),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      body: ListView.builder(
        itemCount: orderHistory.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
            },
            child: HistoryItem(
              history: orderHistory[index],
            ),
          );
        },
      ),
    );
  }
}
