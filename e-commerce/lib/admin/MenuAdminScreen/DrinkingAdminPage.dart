// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, library_private_types_in_public_api, use_build_context_synchronously, file_names, unused_field, deprecated_member_use, avoid_unnecessary_containers
import 'dart:ffi';

import 'package:coffee_house/admin/AllAdminScreen/RegisterAdminScreen.dart';
import 'package:coffee_house/admin/AllAdminWidgets/AddDrinkPage.dart';
import 'package:coffee_house/admin/AllAdminWidgets/DetailPage.dart';
import 'package:coffee_house/admin/AllAdminWidgets/EditDrinkPage.dart';
import 'package:coffee_house/admin/ModelsAdmin/PDr-Admin.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class DrinkingAdminPage extends StatefulWidget {
  @override
  _DrinkingAdminPageState createState() => _DrinkingAdminPageState();
}

class _DrinkingAdminPageState extends State<DrinkingAdminPage> {
  late DatabaseReference _drinksRef;
  List<Drink> _drinks = [];
  bool _showDeleteDialog = false;
  bool _isDeleting = false;
  Drink? _selectedDrink;

  @override
  void initState() {
    super.initState();
    _drinksRef = FirebaseDatabase.instance.ref().child('product').child('drinks');
    _loadDrinks();
  }

  void _loadDrinks() {
    _drinksRef.once().then((DatabaseEvent event) {
      if (event.snapshot.value != null) {
        dynamic drinksData = event.snapshot.value;

        if (drinksData is Map<dynamic, dynamic>) {
          if (mounted) {
            setState(() {
              _drinks = drinksData.entries.map((entry) {
                Map<dynamic, dynamic> drinkData = entry.value as Map<dynamic, dynamic>;
                return Drink(
                  id: entry.key as String,
                  image: drinkData['image'] as String,
                  price: double.parse(drinkData['price'].toString()),
                  name: drinkData['name'] as String,
                  quantity: int.parse(drinkData['quantity'].toString()),
                  description: drinkData['description'] as String,
                );
              }).toList();
            });
          }
        }
      }
    });
  }

  void _showConfirmationDialog(Drink drink) {
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
                String productId = drink.id.toString();
                String imageUrl = drink.image;
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
    DatabaseReference drinksRef = FirebaseDatabase.instance.ref().child('product').child('drinks').child(productId);
    await drinksRef.remove();
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
    itemCount: _drinks.length,
      itemBuilder: (context, index) {
        final drink = _drinks[index];
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
                        MaterialPageRoute(builder: (context) => EditDrinkPage(drink: drink)),
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
                MaterialPageRoute(builder: (context) => AddDrinkPage()),
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