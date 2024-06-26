// ignore_for_file: library_private_types_in_public_api, prefer_const_constructors, prefer_const_literals_to_create_immutables, await_only_futures, avoid_function_literals_in_foreach_calls, avoid_print, file_names


import 'package:coffee_house/main.dart';
import 'package:coffee_house/user/ConfigsUser.dart';
import 'package:coffee_house/user/ModelsUser/Users-User.dart';
import 'package:coffee_house/user/TabPagesUser/HomeTabPageUser.dart';
import 'package:coffee_house/user/TabPagesUser/MenuTabPageUser.dart';
import 'package:coffee_house/user/TabPagesUser/ProfileTabpageUser.dart';
import 'package:coffee_house/user/TabPagesUser/StoreTabPageUser.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';


class MainUserScreen extends StatefulWidget {
  const MainUserScreen({Key? key}) : super(key: key);
  static const String idScreen = "mainUserScreen";
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainUserScreen> with SingleTickerProviderStateMixin {
  late TabController tabController;
  int selectedIndex = 0;

  List<Widget> tabIcons = [
    Image(image: AssetImage('images/house.png')),
    Image(image: AssetImage('images/menu.png')),
    Image(image: AssetImage('images/store.png')),
    Image(image: AssetImage('images/user.png')),
  ];

  List<String> tabNames = [
    "Home",
    "Menu",
    "Store",
    "Account",
  ];

  void onItemClicked(int index) {
    setState(() {
      selectedIndex = index;
      tabController.index = selectedIndex;
    });
  }

  @override
  void initState() {
    super.initState();
    getCurrentUserInfo();
    tabController = TabController(length: 4, vsync: this);

  }

  @override
  void dispose() {
    super.dispose();
    tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        controller: tabController,
        children: [
          HomeTabPageUser(),
          MenuTabPageUser(),
          StoreTabPageUser(),
          ProfileTabPageUser(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: List.generate(
          tabIcons.length,
              (index) => BottomNavigationBarItem(
            icon: tabIcons[index],
            label: selectedIndex == index ? tabNames[index] : '',
          ),
        ),
        unselectedItemColor: Colors.blueGrey,
        selectedItemColor: Color(0xFF00CCFF),
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: TextStyle(fontSize: 12.0),
        showUnselectedLabels: true,
        currentIndex: selectedIndex,
        onTap: onItemClicked,
      ),
    );
  }
}

void getCurrentUserInfo() async{
  currentfirebaseUser = await FirebaseAuth.instance.currentUser;

  try {
    DatabaseReference reference = usersRef.child(currentfirebaseUser?.uid ?? "");
    DatabaseEvent event = await reference.once();
    DataSnapshot dataSnapshot = event.snapshot;

    if (dataSnapshot.value != null) {
      userInformation = Users.fromSnapshot(dataSnapshot);
    }
  } catch (error) {
    print("Error: $error");
  }
}