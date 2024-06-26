// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, prefer_final_fields, use_key_in_widget_constructors, library_private_types_in_public_api, sort_child_properties_last, deprecated_member_use

import 'dart:io';

import 'package:coffee_house/admin/AllAdminScreen/RegisterAdminScreen.dart';
import 'package:coffee_house/main.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddPopularPage extends StatefulWidget {
  @override
  _AddPopularPageState createState() => _AddPopularPageState();
}

class _AddPopularPageState extends State<AddPopularPage> {
  File? _image;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _quantityController = TextEditingController();

  Future<void> _uploadImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

  Future<void> _saveProduct() async {
    if (_image == null) {
      displayToastMessage("Vui lòng chọn ảnh", context);
      return;
    }

    // Validate quantity and price
    int quantity = int.tryParse(_quantityController.text) ?? -1;
    double price = double.tryParse(_priceController.text) ?? -1;

    if (quantity <= 0 || price <= 0) {
      displayToastMessage("Số lượng hoặc giá không được là số âm", context);
      return;
    }

    // Upload image to Firebase Storage
    String imageName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference ref = storage.ref().child('images/$imageName');
    await ref.putFile(_image!);
    String imageUrl = await ref.getDownloadURL();

    // Save product data to database
    ppsRef.push().set({
      'name': _nameController.text,
      'description': _descriptionController.text,
      'price': price,
      'quantity': quantity,
      'image': imageUrl,
    });

    // Clear input fields
    _nameController.clear();
    _descriptionController.clear();
    _priceController.clear();
    _quantityController.clear();

    // Show success message
    displayToastMessage("Thêm thành công.", context);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Thêm sản phẩm',
          style: TextStyle(
            color: Colors.orange,
          ),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Tên sản phẩm'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Mô tả chi tiết'),
            ),
            TextField(
              controller: _priceController,
              decoration: InputDecoration(labelText: 'Giá'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _quantityController,
              decoration: InputDecoration(labelText: 'Số lượng'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _uploadImage,
              child: _image != null
                  ? Image.file(
                      _image!,
                      height: 200.0,
                      width: 200.0,
                      fit: BoxFit.cover,
                    )
                  : Text(
                      'Chọn hình ảnh',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                primary: Colors.grey[300],
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _saveProduct,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                primary: Colors.orange,
              ),
              child: Text(
                'Thêm sản phẩm',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
