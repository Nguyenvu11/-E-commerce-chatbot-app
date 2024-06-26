// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, deprecated_member_use, override_on_non_overriding_member, library_private_types_in_public_api, use_build_context_synchronously

import 'package:coffee_house/main.dart';
import 'package:coffee_house/user/AllUserScreen/RegisterUserScreen.dart';
import 'package:coffee_house/user/ConfigsUser.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class ContactAddressPage extends StatefulWidget {
  @override
  _ContactAddressPageState createState() => _ContactAddressPageState();
}

class _ContactAddressPageState extends State<ContactAddressPage> {
  TextEditingController addressController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController nameController = TextEditingController();


  @override
  void initState() {
    super.initState();
    addressController.text = "";
    phoneNumberController.text = "";
    nameController.text = "";

    usersRef
        .child(currentfirebaseUser!.uid)
        .child("contactInfo")
        .once()
        .then((DatabaseEvent event) {
          DataSnapshot snapshot = event.snapshot;
      if (snapshot.value != null) {
        setState(() {
          Map<dynamic, dynamic>? data = snapshot.value as Map<dynamic, dynamic>?;
          if (data != null) {
            nameController.text = data["name"] ?? "";
            addressController.text = data["address"] ?? "";
            phoneNumberController.text = data["phoneNumber"] ?? "";
          }
        });
      }
    });
  }

  Future<void> saveContactInfo() async {
    try {
      String address = addressController.text;
      String phoneNumber = phoneNumberController.text;
      String name = nameController.text;

      await usersRef
          .child(currentfirebaseUser!.uid)
          .child("contactInfo")
          .set({
        "address": address,
        "phoneNumber": phoneNumber,
        "name" : name,
      });

      displayToastMessage("Đã lưu thông tin liên hệ", context);

      setState(() {
        addressController.text = address;
        phoneNumberController.text = phoneNumber;
        nameController.text = name;
      });
    } catch (error) {
      displayToastMessage("Lỗi: $error", context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Thông tin liên hệ',
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
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Tên khách hàng',
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: addressController,
              decoration: InputDecoration(
                labelText: 'Địa chỉ',
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: phoneNumberController,
              decoration: InputDecoration(
                labelText: 'Số điện thoại',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                saveContactInfo();
              },
              child: Text('Lưu'),
            ),
          ],
        ),
      ),
    );
  }
}