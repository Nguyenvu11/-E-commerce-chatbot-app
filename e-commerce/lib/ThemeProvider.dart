import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ThemeProvider with ChangeNotifier {
  bool _darkModeEnabled = false;

  bool get darkModeEnabled => _darkModeEnabled;

  set darkModeEnabled(bool value) {
    _darkModeEnabled = value;
    // Thực hiện logic cập nhật theme
    if (_darkModeEnabled) {
      // Áp dụng theme dark
      _applyDarkTheme();
    } else {
      // Áp dụng theme light
      _applyLightTheme();
    }
    notifyListeners();
  }

  ThemeData _lightTheme = ThemeData(
    // Cấu hình theme light ở đây
    brightness: Brightness.light,
    // ...
  );

  ThemeData _darkTheme = ThemeData(
    // Cấu hình theme dark ở đây
    brightness: Brightness.dark,
    // ...
  );

  ThemeData get currentTheme => _darkModeEnabled ? _darkTheme : _lightTheme;

  void _applyDarkTheme() {
    // Thực hiện các thay đổi cần thiết cho theme dark
  }

  void _applyLightTheme() {
    // Thực hiện các thay đổi cần thiết cho theme light
  }
}

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: Provider.of<ThemeProvider>(context).currentTheme,
      home: SettingsPage(),
    );
  }
}

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cài đặt'),
      ),
      body: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return SwitchListTile(
            title: const Text('Chế độ tối'),
            value: themeProvider.darkModeEnabled,
            onChanged: (value) {
              themeProvider.darkModeEnabled = value;
            },
          );
        },
      ),
    );
  }
}
