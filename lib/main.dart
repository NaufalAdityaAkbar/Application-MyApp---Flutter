import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:myapp/start/splash.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/dasboard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token') ?? '';
  final phoneNumber = prefs.getString('phoneNumber') ?? ''; // Ambil nomor telepon

  runApp(MyApp(token: token, phoneNumber: phoneNumber));
}

class MyApp extends StatelessWidget {
  final String token;
  final String phoneNumber; // Tambahkan parameter nomor telepon

  const MyApp({super.key, required this.token, required this.phoneNumber});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
       debugShowCheckedModeBanner: false,
      title: 'MyApp',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: token.isNotEmpty ? DashboardPage(phoneNumber: phoneNumber) : SplashScreen(), // Kirim nomor telepon ke DashboardPage
    );
  }
}
