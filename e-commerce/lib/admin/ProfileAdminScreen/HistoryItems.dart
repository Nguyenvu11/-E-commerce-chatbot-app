// ignore_for_file: prefer_const_constructors

import 'package:coffee_house/OrderItems.dart';
import 'package:flutter/material.dart';

class HistoryItem extends StatelessWidget {
  final OrderItems history;

  const HistoryItem({Key? key, required this.history}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.lime,
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Thông tin đơn hàng',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              buildInfoItem('Tên khách hàng', history.customerName),
              buildInfoItem('Số điện thoại', history.phoneNumber),
              buildInfoItem('Địa chỉ', history.address),
              SizedBox(height: 16),
              Text(
                'Sản phẩm:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              buildProductList(history.productList),
              SizedBox(height: 16),
              buildTotalAmount(history.totalAmount),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildInfoItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$title: ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  Widget buildProductList(List<Map<String, dynamic>> productList) {
    return Column(
      children: productList
          .map((product) => Card(
        margin: EdgeInsets.only(bottom: 8),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Tên sản phẩm: ${product["Tên sản phẩm"]}'),
              Text('Giá tiền: ${product["Giá"].toString()} VND'),
              Text('Số lượng: ${product["Số lượng"].toString()}'),
            ],
          ),
        ),
      )).toList(),
    );
  }

  Widget buildTotalAmount(double totalAmount) {
    return Text(
      'Tổng tiền: ${totalAmount.toString()} VND',
      style: TextStyle(
        color: Colors.blue,
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
    );
  }
}
