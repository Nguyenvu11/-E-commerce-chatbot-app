// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, library_private_types_in_public_api

import 'package:coffee_house/admin/MenuAdminScreen/DrinkingAdminPage.dart';
import 'package:coffee_house/admin/MenuAdminScreen/FootAdminPage.dart';
import 'package:coffee_house/admin/MenuAdminScreen/PopularAdminPage.dart';
import 'package:flutter/material.dart';
import 'package:coffee_house/admin/ModelsAdmin/PDr-Admin.dart';

class MenuTabPageAdmin extends StatefulWidget {
  const MenuTabPageAdmin({Key? key}) : super(key: key);

  @override
  _MenuTabPageAdminState createState() => _MenuTabPageAdminState();
}

class _MenuTabPageAdminState extends State<MenuTabPageAdmin> {
  List<Drink> drinks = [];

  @override
  void initState() {
    super.initState();
    // getDrinksFromFirebase().then((drinksList) {
    //   setState(() {
    //     drinks = drinksList;
    //   });
    // });
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
                PopularAdminPage(),
                DrinkingAdminPage(),
                FootAdminPage(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
