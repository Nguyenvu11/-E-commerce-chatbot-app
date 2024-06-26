// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, deprecated_member_use, library_private_types_in_public_api, prefer_interpolation_to_compose_strings, use_build_context_synchronously, prefer_const_literals_to_create_immutables, body_might_complete_normally_catch_error, file_names

import 'package:coffee_house/admin/AdminServices/AuthServiceAdmin.dart';
import 'package:coffee_house/admin/AllAdminScreen/MainAdminScreen.dart';
import 'package:coffee_house/admin/AllAdminScreen/RegisterAdminScreen.dart';
import 'package:coffee_house/admin/ConfigsAdmin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';


class LoginAdminScreen extends StatefulWidget {

  static const String idScreen = "loginAdmin";

  @override
  _LoginAdminScreenState createState() => _LoginAdminScreenState();
}

class _LoginAdminScreenState extends State<LoginAdminScreen> {
  bool rememberMe = false;
  bool _obscurePassword = true;
  TextEditingController emailTextEdittingController = TextEditingController();
  TextEditingController passwordTextEdittingController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              SizedBox(height: 75.0),
              Image(
                image: AssetImage('images/logo.png'),
                width: 170,
                height: 170,
              ),
              SizedBox(height: 30.0),
              TextField(
                controller: emailTextEdittingController,
                decoration: InputDecoration(
                  labelText: 'Tên đăng nhập',
                ),
              ),
              SizedBox(height: 15.0),
              TextField(
                controller: passwordTextEdittingController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: 'Mật khẩu',
                  suffixIcon: IconButton(
                    icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 15.0),
              Row(
                children: [
                  Checkbox(
                    value: rememberMe,
                    onChanged: (value) {
                      setState(() {
                        rememberMe = value!;
                      });
                    },
                  ),
                  Text('Lưu đăng nhập'),
                  Spacer(),
                ],
              ),
              SizedBox(height: 30.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if(!emailTextEdittingController.text.contains("@")){
                        displayToastMessage("Hãy nhập email đúng.", context);
                      }else if(passwordTextEdittingController.text.isEmpty){
                        displayToastMessage("Sai mật khẩu.", context);
                      }else{
                         loginAndAuthenticatedAdmin(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                    ),
                    child: Text(
                      'Đăng nhập',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RegisterAdminScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.lime,
                      side: BorderSide(color: Colors.lime),
                    ),
                    child: Text(
                      'Đăng ký',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30.0),
              OutlinedButton.icon(
                onPressed: () {
                  AuthAdminServices auth = AuthAdminServices();
                  auth.signWithGoogle(context);
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 16),
                            Text("Đợi chút..."),
                          ],
                        ),
                      );
                    },
                  );
                  displayToastMessage("Đăng nhập thành công.", context);
                  Navigator.pushNamedAndRemoveUntil(context, MainAdminScreen.idScreen, (route) => false);
                },
                icon: Image(
                  image: AssetImage('images/search.png'),
                ),
                label: Text('Đăng nhập với Google'),
              ),
            ],
          ),
        ),
      ),
    );

}

  final DatabaseReference adminsRef = FirebaseDatabase.instance.ref();
// Usage:
// Replace with the desired name
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  void loginAndAuthenticatedAdmin(BuildContext context) async {

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text("Đợi chút..."),
            ],
          ),
        );
      },
    );

    final User? firebaseUser = (await _firebaseAuth.signInWithEmailAndPassword(
      email: emailTextEdittingController.text,
      password: passwordTextEdittingController.text,
    ).catchError((errMsg){
      Navigator.pop(context);
      displayToastMessage(" Lỗi: " + errMsg.toString(), context);
    })).user;
    if (firebaseUser != null)
    {
      final snapshot = await adminsRef.child('admins/'+firebaseUser.uid).get();
      if (snapshot.exists) {
        currentfirebaseAdmin = firebaseUser;
        Navigator.pushNamedAndRemoveUntil(context, MainAdminScreen.idScreen, (route) => false);
        displayToastMessage("Đã đăng nhập.", context);
      } else {
        Navigator.pop(context);
        _firebaseAuth.signOut();
        displayToastMessage("Tài khoản không có sẵn. Hãy tạo mới", context);
      }

    }
    else {
      Navigator.pop(context);
      displayToastMessage("Không thể đăng nhập", context);
    }
  }
}