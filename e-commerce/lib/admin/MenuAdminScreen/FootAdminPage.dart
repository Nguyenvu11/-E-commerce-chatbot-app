// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, library_private_types_in_public_api, use_build_context_synchronously, file_names, unused_field, deprecated_member_use, avoid_unnecessary_containers
import 'package:coffee_house/admin/AllAdminScreen/RegisterAdminScreen.dart';
import 'package:coffee_house/admin/AllAdminWidgets/AddFoodPage.dart';
import 'package:coffee_house/admin/AllAdminWidgets/DetailPage.dart';
import 'package:coffee_house/admin/AllAdminWidgets/EditFoodPage.dart';
import 'package:coffee_house/admin/ModelsAdmin/PDr-Admin.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class FootAdminPage extends StatefulWidget {
  @override
  _FoodAdminPageState createState() => _FoodAdminPageState();
}

class _FoodAdminPageState extends State<FootAdminPage> {
  late DatabaseReference _foodsRef;
  List<Drink> _foods = [];
  bool _showDeleteDialog = false;
  bool _isDeleting = false;
  Drink? _selectedDrink;

  @override
  void initState() {
    super.initState();
    _foodsRef = FirebaseDatabase.instance.ref().child('product').child('foods');
    _loadFoods();
  }

  void _loadFoods() {
    _foodsRef.once().then((DatabaseEvent event) {
      if (event.snapshot.value != null) {
        dynamic foodData = event.snapshot.value;

        if (foodData is Map<dynamic, dynamic>) {
          if (mounted) {
            setState(() {
              _foods = foodData.entries.map((entry) {
                Map<dynamic, dynamic> foodData = entry.value as Map<dynamic, dynamic>;
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

  void _showConfirmationDialog(Drink food) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Xác nhận xóa'),
          content: Text('Bạn có chắc chắn muốn xóa sản phẩm này?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Hủy',
                style: TextStyle(color: Colors.black),
              ),
            ),
            TextButton(
              onPressed: () async {
                setState(() {
                  _isDeleting = true;
                });
                String productId = food.id.toString();
                String imageUrl = food.image;
                await deleteProduct(productId, imageUrl);
                displayToastMessage("Xóa thành công", context);
                Navigator.pop(context);
              },
              child: Text(
                'Xóa',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> deleteProduct(String productId, String imageUrl) async {
    DatabaseReference foodsRef = FirebaseDatabase.instance.ref().child('product').child('foods').child(productId);
    await foodsRef.remove();
    final FirebaseStorage storage = FirebaseStorage.instance;
    Reference imageRef = storage.refFromURL(imageUrl);
    await imageRef.delete();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance!.addPostFrameCallback((_) { // ignore: unnecessary_non_null_assertion
      if (_showDeleteDialog) {
        _showConfirmationDialog(_selectedDrink!);
        _showDeleteDialog = false;
      }
    });

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: _foods.length,
            itemBuilder: (context, index) {
              final drink = _foods[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DetailPage(product: drink)),
                  );
                },
                child: Container(
                  child: ListTile(
                    title: Text(drink.name),
                    subtitle: Text(drink.description),
                    leading: Image.network(
                      drink.image,
                      width: 50,
                      height: 50,
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(drink.price.toStringAsFixed(2)),
                        Text("VND"),
                        SizedBox(width: 10),
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => EditFoodPage(food: drink)),
                            );
                          },
                          icon: Icon(Icons.edit),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _showDeleteDialog = true;
                              _selectedDrink = drink;
                            });
                          },
                          icon: Icon(Icons.delete, color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddFoodPage()),
              );
            },
            icon: Icon(Icons.add),
            label: Text('Thêm'),
            style: ElevatedButton.styleFrom(
              primary: Colors.orange,
              onPrimary: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}