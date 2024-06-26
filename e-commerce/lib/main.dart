// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, override_on_non_overriding_member, equal_keys_in_map, library_private_types_in_public_api, deprecated_member_use, prefer_final_fields, non_constant_identifier_names

import 'dart:async';
import 'dart:io';
import 'package:coffee_house/admin/AllAdminScreen/LoginAdminScreen.dart';
import 'package:coffee_house/admin/AllAdminScreen/MainAdminScreen.dart';
import 'package:coffee_house/admin/AllAdminScreen/RegisterAdminScreen.dart';
import 'package:coffee_house/user/AllUserScreen/LoginUserScreen.dart';
import 'package:coffee_house/user/AllUserScreen/MainUserScreen.dart';
import 'package:coffee_house/user/AllUserScreen/RegisterUserScreen.dart';
import 'package:coffee_house/user/ConfigsUser.dart';
import 'package:coffee_house/user/DataHandler/appData.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
// ignore: depend_on_referenced_packages
import 'package:kommunicate_flutter/kommunicate_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

DatabaseReference usersRef = FirebaseDatabase.instance.ref().child("users");
DatabaseReference adminsRef = FirebaseDatabase.instance.ref().child("admins");
DatabaseReference drinksRef =
    FirebaseDatabase.instance.reference().child('product').child('drinks');
DatabaseReference foodsRef =
    FirebaseDatabase.instance.reference().child('product').child('foods');
DatabaseReference ppsRef =
    FirebaseDatabase.instance.reference().child('product').child('populars');
DatabaseReference usersCartRef = FirebaseDatabase.instance
    .ref()
    .child("users")
    .child(currentfirebaseUser!.uid)
    .child("cart");
DatabaseReference usersContact = FirebaseDatabase.instance
    .ref()
    .child("users")
    .child(currentfirebaseUser!.uid)
    .child("contactInfo");
DatabaseReference adminOrder = FirebaseDatabase.instance.ref().child("Orders");
DatabaseReference Order = FirebaseDatabase.instance.ref();
DatabaseReference Voucher = FirebaseDatabase.instance.ref().child("vouchers");
DatabaseReference usersRefVoucher = FirebaseDatabase.instance
    .ref()
    .child("users")
    .child(currentfirebaseUser!.uid)
    .child("voucher");

final FirebaseStorage storage = FirebaseStorage.instance;

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<NotifierClass?>(
          create: (BuildContext context) => NotifierClass(),
        ),
        Provider<DatabaseReference>(
          create: (BuildContext context) => usersRef,
        ),
        ChangeNotifierProvider(create: (BuildContext context) => AppData()),
      ],
      child: MaterialApp(
        title: 'Coffee house',
        theme: ThemeData(
          fontFamily: "Brand Bold",
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: HomeScreen(),
        routes: {
          MainUserScreen.idScreen: (context) => MainUserScreen(),
          LoginUserScreen.idScreen: (context) => LoginUserScreen(),
          RegisterUserScreen.idScreen: (context) => RegisterUserScreen(),
          MainAdminScreen.idScreen: (context) => MainAdminScreen(),
          LoginAdminScreen.idScreen: (context) => LoginAdminScreen(),
          RegisterAdminScreen.idScreen: (context) => RegisterAdminScreen(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;
  int _imageCount = 4;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _stopTimer();
    _pageController.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 3), (Timer timer) {
      if (_currentPage < _imageCount - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  void _stopTimer() {
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              children: List.generate(_imageCount, (index) {
                return Image.asset(
                  'images/house${index + 1}.png',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                );
              }),
            ),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List<Widget>.generate(_imageCount, (int index) {
              return AnimatedContainer(
                duration: Duration(milliseconds: 300),
                margin: EdgeInsets.symmetric(horizontal: 8),
                width: _currentPage == index ? 16 : 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentPage == index ? Colors.blue : Colors.grey,
                  border: Border.all(color: Colors.blue),
                ),
              );
            }),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(MainUserScreen.idScreen);
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.transparent,
                  onPrimary: Colors.green,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                    side: BorderSide(
                      color: Colors.orange,
                      width: 2,
                    ),
                  ),
                  backgroundColor: Colors.white,
                ),
                child: Text(
                  'Người dùng',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(MainAdminScreen.idScreen);
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.transparent,
                  onPrimary: Colors.green,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                    side: BorderSide(
                      color: Colors.orange,
                      width: 2,
                    ),
                  ),
                  backgroundColor: Colors.white,
                ),
                child: Text(
                  'Quản Trị Viên',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class NotifierClass extends ChangeNotifier {
  static const String idScreen = "/";

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}
