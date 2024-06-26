// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables, library_private_types_in_public_api, prefer_final_fields, file_names, unused_element, avoid_unnecessary_containers, non_constant_identifier_names, unused_field

import 'package:coffee_house/main.dart';
import 'package:coffee_house/user/AllUserScreen/RegisterUserScreen.dart';
import 'package:coffee_house/user/AllUserWidgets/DetailPage.dart';
import 'package:coffee_house/user/ConfigsUser.dart';
import 'package:coffee_house/user/ModelsUser/PDr-User.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class PopularUserPage extends StatefulWidget {
  PopularUserPage({Key? key}) : super(key: key);

  @override
  _PopularUserPageState createState() => _PopularUserPageState();
}

class _PopularUserPageState extends State<PopularUserPage> {
  Map<String, int> _quantityMap = {};
  late DatabaseReference _ppsRef;
  List<Drink> _pps = [];
  List<Drink> _filteredpps = []; // Danh sách sản phẩm sau khi lọc
  bool isSearching = false; // Biến xác định trạng thái tìm kiếm

  void _searchProduct(String query) {
    query = query.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        // Nếu không có từ khóa tìm kiếm, hiển thị toàn bộ danh sách sản phẩm
        _filteredpps = List.from(_pps); // Sử dụng danh sách gốc _pps
        isSearching = false;
      } else {
        _filteredpps = _pps.where((drink) {
          return drink.name.toLowerCase().contains(query);
        }).toList();
        isSearching = true;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _ppsRef =
        FirebaseDatabase.instance.ref().child('product').child('populars');
    _loadpps();
  }

  void _loadpps() {
    _ppsRef.once().then((DatabaseEvent event) {
      if (event.snapshot.value != null) {
        dynamic drinksData = event.snapshot.value;

        if (drinksData is Map<dynamic, dynamic>) {
          if (mounted) {
            setState(() {
              _pps = drinksData.entries.map((entry) {
                Map<dynamic, dynamic> ppData =
                    entry.value as Map<dynamic, dynamic>;
                return Drink(
                  id: entry.key as String,
                  image: ppData['image'] as String,
                  price: double.parse(ppData['price'].toString()),
                  name: ppData['name'] as String,
                  quantity: int.parse(ppData['quantity'].toString()),
                  description: ppData['description'] as String,
                );
              }).toList();
            });
          }
        }
      }
    });
  }

  void AddCart(Drink pp, int quantity) {
    Map<String, dynamic> cartItem = {
      "name": pp.name,
      "image": pp.image,
      "price": pp.price,
      "quantity": quantity,
    };

    if (quantity == 0) {
      displayToastMessage("Vui lòng chọn số lượng", context);
      return;
    }

    usersCartRef.push().set(cartItem).then((_) {
      setState(() {
        totalQuantity += quantity;
      });
      //updateTotalCartQuantity(totalQuantity);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Sản phẩm đã được thêm vào giỏ hàng"),
        ),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Đã xảy ra lỗi khi thêm vào giỏ hàng"),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            onChanged: _searchProduct,
            decoration: InputDecoration(
              hintText: 'Tìm kiếm sản phẩm',
              prefixIcon: Icon(Icons.search),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: isSearching ? _filteredpps.length : _pps.length,
            itemBuilder: (context, index) {
              final pp = isSearching ? _filteredpps[index] : _pps[index];
              final itemId = pp.id;
              if (!_quantityMap.containsKey(itemId)) {
                _quantityMap[itemId] = 0;
              }
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DetailPage(product: pp)),
                  );
                },
                child: Container(
                  child: ListTile(
                    title: Text(pp.name),
                    leading: Image.network(
                      pp.image,
                      width: 50,
                      height: 50,
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(pp.price.toStringAsFixed(2)),
                        Text("VND"),
                        SizedBox(width: 1),
                        IconButton(
                          icon: Icon(Icons.remove),
                          onPressed: () {
                            setState(() {
                              int? quantity = _quantityMap[itemId];
                              if (quantity != null && quantity > 0) {
                                _quantityMap[itemId] = quantity - 1;
                              }
                            });
                          },
                        ),
                        Text(_quantityMap[itemId].toString()),
                        IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () {
                            setState(() {
                              int? quantity = _quantityMap[itemId];
                              if (quantity != null) {
                                _quantityMap[itemId] = quantity + 1;
                              }
                            });
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.add_shopping_cart),
                          onPressed: () {
                            AddCart(pp, _quantityMap[itemId]!);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
