// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, avoid_print, file_names, deprecated_member_use
import 'package:coffee_house/admin/ConfigsAdmin.dart';
import 'package:coffee_house/admin/ProfileAdminScreen/ControlClient.dart';
import 'package:coffee_house/admin/ProfileAdminScreen/InformationUserPageAdmin.dart';
import 'package:coffee_house/admin/ProfileAdminScreen/PurchaseHistoryPageAdmin.dart';
import 'package:coffee_house/admin/ProfileAdminScreen/SettingsPage.dart';
import 'package:coffee_house/admin/ProfileAdminScreen/StatisticalPage.dart';
import 'package:coffee_house/admin/ProfileAdminScreen/VoucherPageAdmin.dart';
import 'package:coffee_house/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileTabPageAdmin extends StatelessWidget {
  const ProfileTabPageAdmin({Key? key}) : super(key: key);

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
                  MaterialPageRoute(builder: (context) => InformationAdminPage()),
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
                      andminInformation!.name ?? "Ly", // ignore: dead_null_aware_expression
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
            SizedBox(height: 7),//Thong tin nguoi dung
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => InformationAdminPage()),
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
                    'Thông tin người dùng',
                    style: TextStyle(fontSize: 20,fontFamily: "Brand Bold"),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
            SizedBox(height: 7),//Quan li khach hang
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ControlClientPage()),
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
                    'Quản lý khách hàng',
                    style: TextStyle(fontSize: 20,fontFamily: "Brand Bold"),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
            SizedBox(height: 7),//Quan li don hang
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
                    'Quản lý đơn hàng',
                    style: TextStyle(fontSize: 20,fontFamily: "Brand Bold"),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
            SizedBox(height: 7),//Quan li ma khuyen mai
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
                    'Quản lý mã khuyến mãi',
                    style: TextStyle(fontSize: 20,fontFamily: "Brand Bold"),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
            SizedBox(height: 7),//Thong ke
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SalesStatisticsPage()),
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
                  Image.asset('images/description.png'),
                  SizedBox(width: 16),
                  Text(
                    'Thống kê',
                    style: TextStyle(fontSize: 20,fontFamily: "Brand Bold"),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
            SizedBox(height: 7),//Cai dat
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsPage()),
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
            SizedBox(height: 45),
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