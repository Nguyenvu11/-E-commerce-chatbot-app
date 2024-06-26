// ignore_for_file: library_private_types_in_public_api, prefer_const_constructors, use_key_in_widget_constructors

import 'package:coffee_house/admin/ProfileAdminScreen/InformationUserPageAdmin.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../main.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool notificationEnabled = true;
  bool darkModeEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Cài đặt',
          style: TextStyle(
            color: Colors.lime,
          ),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      body: ListView(
        children: [
          buildSettingItem(
            'Thông báo',
            Switch(
              value: notificationEnabled,
              onChanged: (value) {
                setState(() {
                  notificationEnabled = value;
                  displayToastMessage(
                      notificationEnabled ? "Bật thông báo" : "Tắt thông báo",
                      context);
                });
              },
            ),
          ),
          buildSettingItem(
            'Ngôn ngữ',
            Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LanguageSettingsPage(),
                ),
              );
            },
          ),
          buildSettingItem(
            'Thông tin tài khoản',
            Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => InformationAdminPage())
              );
            },
          ),
        ],
      ),
    );
  }

  Widget buildSettingItem(String title, Widget trailing, {VoidCallback? onTap}) {
    return ListTile(
      title: Text(title),
      trailing: trailing,
      onTap: onTap,
    );
  }
  void displayToastMessage(String message, BuildContext context) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

class LanguageSettingsPage extends StatelessWidget {
  final List<String> languageList = ['Tiếng Việt', 'English', 'Español', 'Français', 'Deutsch', 'Italiano'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Ngôn ngữ',
          style: TextStyle(
            color: Colors.lime,
          ),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      body: ListView.builder(
        itemCount: languageList.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(languageList[index]),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Bạn đã chọn ngôn ngữ: ${languageList[index]}'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}