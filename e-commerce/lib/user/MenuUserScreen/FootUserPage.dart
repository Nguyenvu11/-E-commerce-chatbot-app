// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables, library_private_types_in_public_api, prefer_final_fields, file_names, unused_element, avoid_unnecessary_containers, non_constant_identifier_names, unused_field

import 'package:coffee_house/admin/AllAdminScreen/RegisterAdminScreen.dart';
import 'package:coffee_house/main.dart';
import 'package:coffee_house/user/AllUserWidgets/DetailPage.dart';
import 'package:coffee_house/user/ConfigsUser.dart';
import 'package:coffee_house/user/ModelsUser/PDr-User.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class FootUserPage extends StatefulWidget {
  FootUserPage({Key? key}) : super(key: key);

  @override
  _FootPageState createState() => _FootPageState();
}

class _FootPageState extends State<FootUserPage> {
  Map<String, int> _quantityMap = {};
  late DatabaseReference _foodsRef;
  List<Drink> _foods = [];
  List<Drink> _filteredfoods = []; // Danh sách sản phẩm sau khi lọc
  bool isSearching = false; // Biến xác định trạng thái tìm kiếm

  void _searchProduct(String query) {
    query = query.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        // Nếu không có từ khóa tìm kiếm, hiển thị toàn bộ danh sách sản phẩm
        _filteredfoods = List.from(_foods); // Sử dụng danh sách gốc _pps
        isSearching = false;
      } else {
        _filteredfoods = _foods.where((drink) {
          return drink.name.toLowerCase().contains(query);
        }).toList();
        isSearching = true;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _foodsRef = FirebaseDatabase.instance.ref().child('product').child('foods');
    _loadFoods();
  }

  void _loadFoods() {
    _foodsRef.once().then((DatabaseEvent event) {
      if (event.snapshot.value != null) {
        dynamic foodsData = event.snapshot.value;

        if (foodsData is Map<dynamic, dynamic>) {
          if (mounted) {
            setState(() {
              _foods = foodsData.entries.map((entry) {
                Map<dynamic, dynamic> foodData =
                    entry.value as Map<dynamic, dynamic>;
                return Drink(
                  id: entry.key as String,
                  image: foodData['image'] as String,
                  price: double.parse(foodData['price'].toString()),
                  name: foodData['name'] as String,
                  quantity: int.parse(foodData['quantity'].toString()),
                  description: foodData['description'] as String,
                );
              }).toList();
            });
          }
        }
      }
    });
  }

  void AddCart(Drink food, int quantity) {
    Map<String, dynamic> cartItem = {
      "name": food.name,
      "image": food.image,
      "price": food.price,
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
            itemCount: isSearching ? _filteredfoods.length : _foods.length,
            itemBuilder: (context, index) {
              final food = isSearching ? _filteredfoods[index] : _foods[index];
              final itemId = food.id;
              if (!_quantityMap.containsKey(itemId)) {
                _quantityMap[itemId] = 0;
              }
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailPage(product: food),
                    ),
                  );
                },
                child: Container(
                  child: ListTile(
                    title: Text(food.name),
                    leading: Image.network(
                      food.image,
                      width: 50,
                      height: 50,
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(food.price.toStringAsFixed(2)),
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
                            AddCart(food, _quantityMap[itemId]!);
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
