// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, deprecated_member_use, override_on_non_overriding_member, file_names, library_private_types_in_public_api, unused_local_variable

import 'package:coffee_house/user/ModelsUser/Users-User.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';


class ControlClientPage extends StatefulWidget {
  const ControlClientPage({Key? key}) : super(key: key);

  @override
  _ControlClientPageState createState() => _ControlClientPageState();
}

class _ControlClientPageState extends State<ControlClientPage> {
  List<Users> userList = [];

  @override
  void initState() {
    super.initState();
    getCurrentClientInfo();
  }

  void getCurrentClientInfo() async {
    List<Users> users = await getData();
    setState(() {
      userList = users;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tài khoản khách hàng',
          style: TextStyle(
            color: Colors.lime,
          ),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      body: ListView.builder(
        itemCount: userList.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              ListTile(
                title: Text(userList[index].name),
                subtitle: Text('Email: ${userList[index].email}\nPhone: ${userList[index].phone}'),
              ),
              Divider(),
            ],
          );
        },
      ),
    );
  }

}


void getCurrentClientInfo() async {
  List<Users> userList = await getData();
}

Future<List<Users>> getData() async {
  List<Users> userList = [];

  DatabaseReference usersRef = FirebaseDatabase.instance.ref().child("users");
  DatabaseEvent event = await usersRef.once();

  DataSnapshot dataSnapshot = event.snapshot;

  Map<dynamic, dynamic>? values = dataSnapshot.value as Map<dynamic, dynamic>?;

  if (values != null) {
    values.forEach((key, user) {
      Users newUser = Users(
        id: key,
        name: user["name"] ?? "",
        username: user["username"] ?? "",
        phone: user["phone"] ?? "",
        email: user["email"] ?? "",
        password: user["password"] ?? "",
        confirmPassword: user["passwordConfirm"] ?? "",
      );

      userList.add(newUser);
    });
  }

  return userList;
}



