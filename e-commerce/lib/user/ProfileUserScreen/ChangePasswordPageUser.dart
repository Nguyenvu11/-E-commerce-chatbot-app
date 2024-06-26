// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, deprecated_member_use, must_be_immutable, file_names, library_private_types_in_public_api, unused_field, prefer_final_fields, unrelated_type_equality_checks, non_constant_identifier_names, avoid_print

import 'package:coffee_house/user/AllUserScreen/RegisterUserScreen.dart';
import 'package:coffee_house/user/ConfigsUser.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';



class ChangePasswordPageUser extends StatefulWidget {

  @override
  _ChangePasswordStateUser createState() => _ChangePasswordStateUser();
}


class _ChangePasswordStateUser extends State<ChangePasswordPageUser> {
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _obscureConfirmNewPassword = true;

  TextEditingController oldPasswordTextEdittingController = TextEditingController();
  TextEditingController passwordTextEdittingController = TextEditingController();
  TextEditingController confirmpasswordTextEdittingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Đổi mật khẩu',
          style: TextStyle(
            color: Colors.lime,
          ),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 15),
            ListTile(
              leading: Icon(Icons.account_box_sharp),
              title: Text(
                'Tên đăng nhập',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              subtitle: Text(
                userInformation?.username ?? '',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ),
            Container(
              height: 1,
              color: Colors.grey,
              margin: EdgeInsets.symmetric(horizontal: 16),
            ),
            SizedBox(height: 10.0),
            TextField(
              controller: oldPasswordTextEdittingController,
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                labelText: 'Mật khẩu cũ',
                prefixIcon: Icon(Icons.lock),
                suffixIcon: IconButton(
                  icon: Icon(_obscurePassword ? Icons.visibility_off : Icons
                      .visibility),
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
              controller: passwordTextEdittingController,
              obscureText: _obscureConfirmPassword,
              decoration: InputDecoration(
                labelText: 'Mật khẩu mới',
                prefixIcon: Icon(Icons.lock),
                suffixIcon: IconButton(
                  icon: Icon(
                      _obscureConfirmPassword ? Icons.visibility_off : Icons
                          .visibility),
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
              controller: confirmpasswordTextEdittingController,
              obscureText: _obscureConfirmNewPassword,
              decoration: InputDecoration(
                labelText: 'Nhập lại mật khẩu mới ',
                prefixIcon: Icon(Icons.lock),
                suffixIcon: IconButton(
                  icon: Icon(
                      _obscureConfirmNewPassword ? Icons.visibility_off : Icons
                          .visibility),
                  onPressed: () {
                    setState(() {
                      _obscureConfirmNewPassword = !_obscureConfirmNewPassword;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 30),
            const SizedBox(height: 30),
            Container(
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      String textValue = oldPasswordTextEdittingController.text;
                      String textValueOld = passwordTextEdittingController.text;
                      String textValueNew = confirmpasswordTextEdittingController
                          .text;
                      if (textValue != userInformation!.password.toString() ||
                          oldPasswordTextEdittingController.text.isEmpty) {
                        displayToastMessage("Lỗi mật khẩu cũ.", context);
                      } else if (textValueOld != textValueNew ||
                          passwordTextEdittingController.text.isEmpty ||
                          confirmpasswordTextEdittingController.text.isEmpty) {
                        displayToastMessage("Vui lòng không để trống trường nào.", context);
                      } else {
                        UpdatePassword();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      onPrimary: Colors.black,
                      textStyle: TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                        fontFamily: 'Brand Bold',
                      ),
                      padding: EdgeInsets.symmetric(
                          vertical: 12, horizontal: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: Colors.yellow,
                          width: 2,
                        ),
                      ),
                    ),
                    child: Text('Cập Nhật'),
                  ),
                  SizedBox(width: 55),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.black,
                      onPrimary: Colors.white,
                      textStyle: TextStyle(
                        fontSize: 15,
                        fontFamily: 'Brand Bold',
                      ),
                      padding: EdgeInsets.symmetric(
                          vertical: 12, horizontal: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text('Hủy'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  void UpdatePassword() {
    String newPassword = passwordTextEdittingController.text;
    String confirmPassword = confirmpasswordTextEdittingController.text;

    if (newPassword == confirmPassword) {
      DatabaseReference usersRef = FirebaseDatabase.instance.ref().child("users").child(currentfirebaseUser!.uid);
      usersRef.update({
        "password": newPassword,
        "passwordConfirm": confirmPassword,
      }).then((value) {
        displayToastMessage("Cập nhật mật khẩu thành công.", context);
        Navigator.pop(context);
      }).catchError((error) {
        displayToastMessage("Lỗi khi cập nhật mật khẩu + $error", context  );
      });
    } else {
      displayToastMessage("Mật khẩu mới và xác nhận mật khẩu không khớp", context);
    }
  }
}

