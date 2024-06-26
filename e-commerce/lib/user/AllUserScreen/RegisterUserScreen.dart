// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, deprecated_member_use, must_be_immutable, file_names, use_build_context_synchronously, prefer_interpolation_to_compose_strings, body_might_complete_normally_catch_error, library_private_types_in_public_api, prefer_final_fields

import 'package:coffee_house/main.dart';
import 'package:coffee_house/user/AllUserScreen/LoginUserScreen.dart';
import 'package:coffee_house/user/AllUserWidgets/progressUserDialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegisterUserScreen extends StatefulWidget {
  static const String idScreen = "register";
  const RegisterUserScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}


class _RegisterScreenState extends State<RegisterUserScreen> {
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  TextEditingController nameTextEdittingController = TextEditingController();
  TextEditingController usernameTextEdittingController = TextEditingController();
  TextEditingController passwordTextEdittingController = TextEditingController();
  TextEditingController confirmpasswordTextEdittingController = TextEditingController();
  TextEditingController phoneTextEdittingController = TextEditingController();
  TextEditingController emailTextEdittingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            children: [
              Image(
                image: AssetImage('images/logo.png'),
                width: 170,
                height: 170,
              ),
              SizedBox(height: 20.0),
              TextField(
                controller: nameTextEdittingController,
                decoration: InputDecoration(
                  labelText: 'Tên người dùng',
                ),
              ),
              SizedBox(height: 10.0),
              TextField(
                controller: usernameTextEdittingController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Username',
                ),
              ),
              SizedBox(height: 10.0),
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
              SizedBox(height: 10.0),
              TextField(
                controller: confirmpasswordTextEdittingController,
                obscureText: _obscureConfirmPassword,
                decoration: InputDecoration(
                  labelText: 'Nhập lại mật khẩu',
                  suffixIcon: IconButton(
                    icon: Icon(_obscureConfirmPassword ? Icons.visibility_off : Icons.visibility),
                    onPressed: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 10.0),
              TextField(
                controller: phoneTextEdittingController,
                decoration: InputDecoration(
                  labelText: 'Số điện thoại',
                ),
              ),
              SizedBox(height: 10.0),
              TextField(
                controller: emailTextEdittingController,
                decoration: InputDecoration(
                  labelText: 'Nhập email',
                ),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  if (nameTextEdittingController.text.length < 4) {
                    displayToastMessage("Tên có ít nhất 3 kí tự", context);
                  } else if (nameTextEdittingController.text.isEmpty) {
                    displayToastMessage("Tên không được trống", context);
                  } else
                  if (usernameTextEdittingController.text.length < 6) {
                    displayToastMessage("Tên người dùng phải có ít nhất 5 kí tự", context);
                  } else if (phoneTextEdittingController.text.isEmpty) {
                    displayToastMessage(
                        "Số điện thoại không được để trống.", context);
                  } else if (passwordTextEdittingController.text.length < 6) {
                    displayToastMessage(
                        "Password must be at least 6 characters.", context);
                  } else if (passwordTextEdittingController.text !=
                      confirmpasswordTextEdittingController.text) {
                    displayToastMessage(
                        "Mật khẩu không khớp.", context);
                  } else
                  if (!emailTextEdittingController.text.contains("@")) {
                    displayToastMessage("Email không đầy đủ", context);
                  }else {
                    registerNewUser(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.lime,
                  side: BorderSide(color: Colors.lime),
                ),
                child: Text(
                  'Đăng ký tài khoản',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 10.0),
              Text(
                'Khi ấn đăng kí thì bạn đã đồng ý với điều khoản và chính sách của chúng tôi',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10.0),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Đã có tài khoản? quay lại đăng nhập',
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<void> registerNewUser(BuildContext context) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return ProgressDialog(message: "...",);
        }
    );

    final User? firebaseUser = (await _firebaseAuth // "?" is mean that user can be null
        .createUserWithEmailAndPassword( //This function is used for create user
      email: emailTextEdittingController.text,
      password: passwordTextEdittingController.text,
    ).catchError((errMsg) {
      Navigator.pop(context);
      displayToastMessage("Lỗi: " + errMsg.toString(), context);
    })).user;

    if (firebaseUser != null) {
      usersRef.child(firebaseUser.uid);
      Map userDateMap = {
        "name": nameTextEdittingController.text.trim(),
        "username": usernameTextEdittingController.text.trim(),
        "password": passwordTextEdittingController.text.trim(),
        "passwordConfirm": confirmpasswordTextEdittingController.text.trim(),
        "phone": phoneTextEdittingController.text.trim(),
        "email": emailTextEdittingController.text.trim()
      };
      usersRef.child(firebaseUser.uid).set(userDateMap).then((_) {
        displayToastMessage("Đăng kí thành công", context);
        Navigator.pushNamedAndRemoveUntil(
            context, LoginUserScreen.idScreen, (route) => false);
      }).catchError((error) {
        Navigator.pop(context);
        displayToastMessage(
            "Lỗi, người dùng không được tạo. Hãy thử lại!", context);
      });
    }
  }
}
displayToastMessage(String message, BuildContext context){
  Fluttertoast.showToast(msg: message);
  }
