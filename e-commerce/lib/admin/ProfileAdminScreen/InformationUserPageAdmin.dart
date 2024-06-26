// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, deprecated_member_use, override_on_non_overriding_member

import 'package:coffee_house/admin/AllAdminScreen/MainAdminScreen.dart';
import 'package:coffee_house/admin/ConfigsAdmin.dart';
import 'package:coffee_house/admin/ProfileAdminScreen/ChangePasswordPageAdmin.dart';
import 'package:flutter/material.dart';


class InformationAdminPage extends StatelessWidget {
  const InformationAdminPage({Key? key}) : super(key: key);

  @override
  Future<void> initState() async {
    getCurrentAdminInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Thông tin tài khoản',
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
            const SizedBox(height: 10),
            InkWell(
              onTap: () {},
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                child: Column(
                  children: [
                    Image.asset(
                      'images/astronaut.png',
                      width: 120,
                      height: 120,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      andminInformation?.name ?? "Ly",
                      style: const TextStyle(
                        fontSize: 20,
                        fontFamily: "Brand Bold",
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Nhân viên mới',
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              color: Colors.grey,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Thông tin cá nhân',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ChangePasswordPageAdmin()),
                      );
                    },
                    child: Text(
                      'Đổi mật khẩu',
                      style: TextStyle(
                        color: Colors.deepPurple,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            ListTile(
              leading: Icon(Icons.email),
              title: Text(
                'Email',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              subtitle: Text(
                andminInformation?.email ?? '',
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
            ListTile(
              leading: Icon(Icons.phone),
              title: Text(
                'Số điện thoại',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              subtitle: Text(
                andminInformation?.phone ?? '',
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
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {

              },
              style: ElevatedButton.styleFrom(
                primary: Colors.lime,
                onPrimary: Colors.black,
                textStyle: TextStyle(
                  fontSize: 15,
                  color: Colors.black,
                  fontFamily: 'Brand Bold',
                ),
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              child: Text('Sửa thông tin'),
            ),
          ],
        ),
      ),
    );
  }
}