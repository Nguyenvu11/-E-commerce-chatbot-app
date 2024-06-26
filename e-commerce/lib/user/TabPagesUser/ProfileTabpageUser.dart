// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, avoid_print, file_names, deprecated_member_use

import 'package:coffee_house/main.dart';
import 'package:coffee_house/user/AllUserScreen/LoginUserScreen.dart';
import 'package:coffee_house/user/ConfigsUser.dart';
import 'package:coffee_house/user/ProfileUserScreen/ContactAddressPage.dart';
import 'package:coffee_house/user/ProfileUserScreen/InformationUserPageUser.dart';
import 'package:coffee_house/user/ProfileUserScreen/PurchaseHistoryPageUser.dart';
import 'package:coffee_house/user/ProfileUserScreen/SettingsPage.dart';
import 'package:coffee_house/user/ProfileUserScreen/VoucherPageUser.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileTabPageUser extends StatelessWidget {
  const ProfileTabPageUser({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Center(
        child: Column(
          children: [
            SizedBox(height: 50),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => InformationUserPage()),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  //color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                child: Column(
                  children: [
                    Image.asset(
                      'images/astronaut.png',
                      width: 120,
                      height: 120,
                    ),
                    SizedBox(height: 8),
                    Text(
                      userInformation!.name ?? "Ly",
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: "Brand Bold",
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => InformationUserPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.white,
                onPrimary: Colors.black,
                textStyle: TextStyle(fontSize: 18),
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset('images/farmer.png'),
                  SizedBox(width: 16),
                  Text(
                    'Thông tin khách hàng',
                    style: TextStyle(fontSize: 20,fontFamily: "Brand Bold"),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PurchaseHistoryPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.white,
                onPrimary: Colors.black,
                textStyle: TextStyle(fontSize: 18),
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset('images/history.png'),
                  SizedBox(width: 16),
                  Text(
                    'Lịch sử mua hàng',
                    style: TextStyle(fontSize: 20,fontFamily: "Brand Bold"),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => VoucherPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.white,
                onPrimary: Colors.black,
                textStyle: TextStyle(fontSize: 18),
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset('images/voucher.png'),
                  SizedBox(width: 16),
                  Text(
                    'Mã khuyến mãi',
                    style: TextStyle(fontSize: 20,fontFamily: "Brand Bold"),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ContactAddressPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.white,
                onPrimary: Colors.black,
                textStyle: TextStyle(fontSize: 18),
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset('images/call.png'),
                  SizedBox(width: 16),
                  Text(
                    'Liên hệ',
                    style: TextStyle(fontSize: 20,fontFamily: "Brand Bold"),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsPageUser()),
                );
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.white,
                onPrimary: Colors.black,
                textStyle: TextStyle(fontSize: 18),
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset('images/gear.png'),
                  SizedBox(width: 16),
                  Text(
                    'Cài đặt',
                    style: TextStyle(fontSize: 20,fontFamily: "Brand Bold"),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
            SizedBox(height: 55),
            ElevatedButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                      (route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.lime,
                onPrimary: Colors.black,
                textStyle: TextStyle(
                  fontSize: 24,
                  color: Colors.black,
                  fontFamily: 'Brand Bold',
                ),
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text('Đăng xuất'),
            ),
          ],
        ),
      ),
    );
  }
}