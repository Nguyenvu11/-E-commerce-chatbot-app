// ignore_for_file: file_names, non_constant_identifier_names

import 'package:firebase_database/firebase_database.dart';

class Admins{
  late String id;
  late String name;
  late String username;
  late String phone;
  late String email;
  late String password;
  late String confirmPassword;


  Admins({
    required this.id,
    required this.name,
    required this.username,
    required this.phone,
    required this.email,
    required this.password,
    required this.confirmPassword,
  });

  Admins.fromSnapshot(DataSnapshot dataSnapshot) {
    id = dataSnapshot.key!;
    var value = dataSnapshot.value as Map<Object?, Object?>?;
    if (value != null) {
      email = value["email"] as String? ?? "";
      name = value["name"] as String? ?? "";
      password = value["password"] as String? ?? "";
      confirmPassword = value["passwordConfirm"] as String? ?? "";
      phone = value["phone"] as String? ?? "";
      username = value["username"] as String? ?? "";
    }
  }
}
