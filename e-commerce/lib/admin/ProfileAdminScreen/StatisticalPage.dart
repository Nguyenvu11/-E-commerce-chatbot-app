import 'package:coffee_house/OrderItems.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class SalesStatisticsPage extends StatefulWidget {
  const SalesStatisticsPage({Key? key}) : super(key: key);

  @override
  _SalesStatisticsPageState createState() => _SalesStatisticsPageState();
}

class _SalesStatisticsPageState extends State<SalesStatisticsPage> {
  late List<OrderItems> orderList;

  @override
  void initState() {
    super.initState();
    orderList = [];
    getOrders();
  }

  Future<void> getOrders() async {
    DatabaseReference orderRef =
        FirebaseDatabase.instance.ref().child("Orders");
    DatabaseEvent event = await orderRef.once();
    DataSnapshot snapshot = event.snapshot;

    if (snapshot.value != null) {
      try {
        if (snapshot.value is Map<dynamic, dynamic>?) {
          Map<String, dynamic>? ordersMap =
              (snapshot.value as Map<dynamic, dynamic>?)
                  ?.cast<String, dynamic>();

          if (ordersMap != null) {
            List<OrderItems> updatedOrderList = [];

            ordersMap.forEach((key, orderData) {
              try {
                OrderItems orderItem = OrderItems.fromMap(orderData);
                updatedOrderList.add(orderItem);
              } catch (e) {
                print('Unexpected data structure for key $key: $orderData');
              }
            });

            setState(() {
              orderList = updatedOrderList;
            });
          } else {
            print("Unexpected data structure at the root level: $ordersMap");
          }
        } else {
          print("Unexpected data type at the root level: ${snapshot.value}");
        }
      } catch (e) {
        print('Error parsing ordersMap: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Thống kê doanh số bán hàng',
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Biểu đồ thống kê doanh số bán hàng',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: LineChart(
                LineChartData(
                  lineBarsData: [
                    LineChartBarData(
                      spots: getSpots(),
                      isCurved: true,
                      belowBarData: BarAreaData(
                        show: true,
                        color: Colors.blue,
                      ),
                      dotData: FlDotData(show: true),
                      isStrokeCapRound: true,
                    ),
                  ],
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(
                      color: const Color(0xff37434d),
                      width: 1,
                    ),
                  ),
                  gridData: FlGridData(show: true),
                ),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Thống kê bán hàng theo sản phẩm',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: orderList.length,
                itemBuilder: (context, index) {
                  OrderItems order = orderList[index];
                  return ListTile(
                    title: Text('Sản phẩm: ${order.productList}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Giá trị đơn hàng : ${order.totalAmount} VND'),
                        Text('Khách hàng : ${order.customerName}'),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<FlSpot> getSpots() {
    List<FlSpot> spots = [];

    for (int i = 0; i < orderList.length; i++) {
      double x = i.toDouble();
      double y = orderList[i].totalAmount;

      spots.add(FlSpot(x, y));
    }

    return spots;
  }
}
