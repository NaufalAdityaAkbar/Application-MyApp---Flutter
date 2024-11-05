import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../app/profile.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController phoneController = TextEditingController();

    void _showAlertDialog(BuildContext context, String title, String message, Color color) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Text(message),
            backgroundColor: color.withOpacity(0.1),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }

    void register() async {
      final response = await http.post(
        Uri.parse('http://192.168.2.13:3000/api/users/register'),
        body: json.encode({'phone_number': phoneController.text}),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Simpan phone number ke SharedPreferences sebagai "token"
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', phoneController.text);
        await prefs.setString('phoneNumber', phoneController.text); // Simpan nomor telepon


        _showAlertDialog(context, 'Success', 'Registration successful!', Colors.green);
        
        // Navigasi ke halaman Profile setelah registrasi berhasil
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ProfileScreen(phoneNumber: phoneController.text),
          ),
        );
      } else {
        _showAlertDialog(context, 'Error', 'Registration failed: ${response.body}', Colors.red);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: phoneController,
              decoration: InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.teal),
                ),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: register,
              child: const Text('Register'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
