// ignore_for_file: file_names

import 'package:coffee_house/user/ModelsUser/Users-User.dart';
import 'package:firebase_auth/firebase_auth.dart';


User? currentfirebaseUser;
Users? userInformation;
late final Function(int) updateTotalCartQuantity;
int totalQuantity = 0;

String name = "";