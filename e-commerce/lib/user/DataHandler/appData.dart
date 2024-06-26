import 'package:coffee_house/OrderItems.dart';
import 'package:flutter/cupertino.dart';

class AppData extends ChangeNotifier{
  List<OrderItems> listItem = [];

  void updateOrderHistoryData(OrderItems eachHistory){
    listItem.add(eachHistory);
    notifyListeners();
  }
}