import 'package:flutter/material.dart';
import '../app/login.dart';
import 'app/register.dart';
import 'app/dasboard.dart';

void main() => runApp(MyApp(phoneNumber: ''));

class MyApp extends StatelessWidget {
  final String phoneNumber;

  const MyApp({super.key, required this.phoneNumber});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyApp',
      theme: ThemeData(
      primarySwatch: Colors.teal,
      ),
      home: LoginScreen(),
      routes: {
        '/register': (context) => RegisterScreen(),
        '/dashboard': (context) => DashboardPage(phoneNumber: phoneNumber),
        '/login': (context) => LoginScreen(),
      },
    );
  }
}
