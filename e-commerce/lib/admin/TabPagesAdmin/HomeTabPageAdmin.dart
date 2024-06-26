// ignore_for_file: prefer_const_constructors, library_private_types_in_public_api, use_key_in_widget_constructors, prefer_const_literals_to_create_immutables, deprecated_member_use, sized_box_for_whitespace, file_names, file_names, file_names, unused_field, duplicate_ignore
import 'package:coffee_house/admin/AllAdminScreen/LoginAdminScreen.dart';
import 'package:coffee_house/admin/ConfigsAdmin.dart';
import 'package:coffee_house/admin/ModelsAdmin/News-Admin.dart';
import 'package:coffee_house/admin/ProfileAdminScreen/InformationUserPageAdmin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class HomeTabPageAdmin extends StatefulWidget {
  @override
  _HomeTabPageStateAdmin createState() => _HomeTabPageStateAdmin();
}

class _HomeTabPageStateAdmin extends State<HomeTabPageAdmin>
    with SingleTickerProviderStateMixin {
  AnimationController? _animationController;
  Animation<double>? _slideAnimation;

  final List<News> newsList = [
    News(
      image: 'images/bannermini1.jpg',
    ),
    News(
      image: 'images/bannermini2.jpg',
    ),
    News(
      image: 'images/bannermini3.jpg',
    ),
  ];

  @override
  void initState() {
    super.initState();
    checkAdminLoggedIn();

    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _slideAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController!);
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Divider(
            height: 30.0,
            thickness: 20.0,
          ),
          Row(
            children: [
              IconButton(
                icon: Image(
                  image: AssetImage('images/man.png'),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => InformationAdminPage()),
                  );
                },
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(left: 2.0, right: 2.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.amber),
                        borderRadius: BorderRadius.circular(27.0),
                      ),
                      child: TextButton(
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all<EdgeInsets>(
                            const EdgeInsets.all(5),
                          ),
                        ),
                        onPressed: name.isEmpty
                            ? () {
                                Navigator.pushNamedAndRemoveUntil(
                                    context,
                                    LoginAdminScreen.idScreen,
                                    (route) => false);
                              }
                            : null,
                        child: Text(name.isEmpty ? "Đăng nhập" : name),
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Image(
                  image: AssetImage('images/bell.png'),
                ),
                onPressed: () {},
              ),
            ],
          ),
          const Divider(
            height: 15.0,
            thickness: 2.0,
          ),
          Expanded(
            child: Container(
              color: Colors.grey,
              child: ListView(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 1.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Ưu đãi đặt biệt',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 8.0),
                          ],
                        ),
                        SizedBox(height: 3.0),
                        LayoutBuilder(
                          builder: (BuildContext context,
                              BoxConstraints constraints) {
                            return Container(
                              height: 200.0,
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.5),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: AnimatedBuilder(
                                  animation: _animationController!,
                                  builder:
                                      (BuildContext context, Widget? child) {
                                    return Stack(
                                      children: [
                                        Positioned(
                                          left: -_slideAnimation!.value *
                                              MediaQuery.of(context).size.width,
                                          child: Image(
                                            image: AssetImage(
                                                'images/banner.webp'),
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            height: 200.0,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        Positioned(
                                          left: (1 - _slideAnimation!.value) *
                                                  MediaQuery.of(context)
                                                      .size
                                                      .width +
                                              30,
                                          child: Container(
                                            color: Colors.grey,
                                            width: 0,
                                            height: 200.0,
                                          ),
                                        ),
                                        Positioned(
                                          left: (1 - _slideAnimation!.value) *
                                                  MediaQuery.of(context)
                                                      .size
                                                      .width +
                                              0 +
                                              30,
                                          child: Image(
                                            image: AssetImage(
                                                'images/banner2.jpg'),
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            height: 200.0,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24.0),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Tin Tức',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 8.0),
                        ],
                      ),
                      SizedBox(height: 3.0),
                      // Nội dung tin tức
                      Container(
                        height: 200.0,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: newsList.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: 200.0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.5),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 200.0,
                                      height: 170.0,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image:
                                              AssetImage(newsList[index].image),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24.0),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Dành cho bạn ',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 8.0),
                        ],
                      ),
                      SizedBox(height: 3.0),
                      // Nội dung tin tức
                      Container(
                        height: 200.0,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: newsList.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: 200.0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.5),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 200.0,
                                      height: 170.0,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image:
                                              AssetImage(newsList[index].image),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String getCurrentUserId() {
    final User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      return currentUser.uid;
    }
    return '';
  }

  Future<String> getAdminName(String userId) async {
    final DatabaseReference adminsRef =
        FirebaseDatabase.instance.ref().child('admins/$userId');
    final snapshot = await adminsRef.once();
    final DataSnapshot dataSnapshot = snapshot.snapshot;
    if (dataSnapshot.value != null && dataSnapshot.value is Map) {
      final Map userData = dataSnapshot.value as Map;
      if (userData.containsKey('name')) {
        return userData['name'];
      }
    }
    return '';
  }

  void checkAdminLoggedIn() async {
    final User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final String userId = getCurrentUserId();
      final String userName = await getAdminName(userId);
      setState(() {
        name = userName;
      });
    }
  }
}
