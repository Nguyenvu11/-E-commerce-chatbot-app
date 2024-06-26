// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, library_private_types_in_public_api

import 'package:coffee_house/user/MenuUserScreen/CheckoutPage.dart';
import 'package:coffee_house/user/MenuUserScreen/DrinkingUserPage.dart';
import 'package:coffee_house/user/MenuUserScreen/FootUserPage.dart';
import 'package:coffee_house/user/MenuUserScreen/PopularUserPage.dart';
import 'package:flutter/material.dart';

class MenuTabPageUser extends StatefulWidget {
  const MenuTabPageUser({Key? key}) : super(key: key);

  @override
  _MenuTabPageUserState createState() => _MenuTabPageUserState();
}

class _MenuTabPageUserState extends State<MenuTabPageUser> {
  int _totalCartQuantity = 0;
  void updateTotalCartQuantity(int quantity) {
    setState(() {
      _totalCartQuantity = quantity;
    });
  }

  void navigateToCheckoutPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CheckoutPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          Divider(
            height: 30.0,
            thickness: 20.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: Icon(Icons.add_shopping_cart),
                onPressed: navigateToCheckoutPage,
              ),
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  _totalCartQuantity.toString(),
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          Divider(
            height: 5.0,
            thickness: 0.0,
          ),
          TabBar(
            labelStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: 'Brand bold',
            ),
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.amber,
            tabs: [
              Tab(text: 'PHỔ BIẾN'),
              Tab(text: 'MỚI NHẤT'),
              Tab(text: 'MUA NHIỀU'),
            ],
          ),
          Divider(height: 2.0, thickness: 2.0),
          Expanded(
            child: TabBarView(
              children: [
                PopularUserPage(),
                DrinkingUserPage(),
                FootUserPage(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
