// ignore_for_file: prefer_const_constructors, prefer_final_fields, use_key_in_widget_constructors, library_private_types_in_public_api, prefer_const_constructors_in_immutables, file_names, sort_child_properties_last, deprecated_member_use

import 'package:coffee_house/admin/AllAdminScreen/RegisterAdminScreen.dart';
import 'package:coffee_house/admin/ConfigsAdmin.dart';
import 'package:coffee_house/admin/ModelsAdmin/PDr-Admin.dart';
import 'package:coffee_house/main.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class EditDrinkPage extends StatefulWidget {
  final Drink drink;
  EditDrinkPage({required this.drink});
  @override
  _EditDrinkPageState createState() => _EditDrinkPageState();
}

class _EditDrinkPageState extends State<EditDrinkPage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _quantityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.drink.name;
    _descriptionController.text = widget.drink.description;
    _priceController.text = widget.drink.price.toString();
    _quantityController.text = widget.drink.quantity.toString();
  }

  void saveChanges() {
    String productId = widget.drink.id.toString();
    String newName = _nameController.text;
    String newDescription = _descriptionController.text;
    double newPrice = double.parse(_priceController.text);
    int newQuantity = int.parse(_quantityController.text);

    Map<String, dynamic> updatedData = {
      "description": newDescription,
      "name": newName,
      "price": newPrice,
      "quantity": newQuantity,
    };

    DatabaseReference drinksRef = FirebaseDatabase.instance.reference().child('product').child('drinks');

    drinksRef.child(productId).update(updatedData).then((_) {
      displayToastMessage("Cập nhật thành công", context);
      Navigator.pop(context);
    }).catchError((error) {
      displayToastMessage(error.toString(), context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Chỉnh sửa mục',
          style: TextStyle(
            color: Colors.orange,
          ),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Tên sản phẩm'),
                ),
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(labelText: 'Mô tả'),
                ),
                TextFormField(
                  controller: _priceController,
                  decoration: InputDecoration(labelText: 'Giá'),
                ),
                TextFormField(
                  controller: _quantityController,
                  decoration: InputDecoration(labelText: 'Số lượng'),
                ),
                SizedBox(height: 16.0),
                Center(
                  child: GestureDetector(
                    onTap: () {

                    },
                    child: Container(
                      width: 300.0,
                      height: 300.0,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: widget.drink.image.isNotEmpty
                          ? Image.network(
                        widget.drink.image,
                        height: 200,
                        width: 200,
                        fit: BoxFit.cover,
                      )
                          : Icon(
                        Icons.add_a_photo,
                        size: 40.0,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        saveChanges();
                      },
                      child: Text('Lưu'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Hủy'),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

