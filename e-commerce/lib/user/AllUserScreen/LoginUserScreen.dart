// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, deprecated_member_use, library_private_types_in_public_api, prefer_interpolation_to_compose_strings, use_build_context_synchronously, prefer_const_literals_to_create_immutables, body_might_complete_normally_catch_error, file_names

import 'package:coffee_house/user/AllUserScreen/MainUserScreen.dart';
import 'package:coffee_house/user/AllUserScreen/RegisterUserScreen.dart';
import 'package:coffee_house/user/ConfigsUser.dart';
import 'package:coffee_house/user/UserServices/AuthServiceUser.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';


class LoginUserScreen extends StatefulWidget {

  static const String idScreen = "login";

  @override
  _LoginUserScreenState createState() => _LoginUserScreenState();
}

class _LoginUserScreenState extends State<LoginUserScreen> {
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
                         loginAndAuthenticatedUser(context);
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
                        MaterialPageRoute(builder: (context) => RegisterUserScreen()),
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
                  AuthUserServices auth = AuthUserServices();
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
                  Navigator.pushNamedAndRemoveUntil(context, MainUserScreen.idScreen, (route) => false);
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

  final DatabaseReference usersRef = FirebaseDatabase.instance.ref();
// Usage:
// Replace with the desired name
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  void loginAndAuthenticatedUser(BuildContext context) async {

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
      final snapshot = await usersRef.child('users/'+firebaseUser.uid).get();
      if (snapshot.exists) {
        currentfirebaseUser = firebaseUser;
        Navigator.pushNamedAndRemoveUntil(context, MainUserScreen.idScreen, (route) => false);
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