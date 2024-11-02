import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dasboard.dart'; // Assuming this is your main menu screen
import 'register.dart'; // Import the register screen

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController phoneController = TextEditingController();

    void login() async {
      final response = await http.post(
        Uri.parse('http://localhost:3000/api/users/login'),
        body: json.encode({'phone_number': phoneController.text}),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        // Assuming successful login returns user data
        final userData = json.decode(response.body);
        String phoneNumber = phoneController.text; // Store phone number

        // Navigate to MenuScreen and pass the phone number
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => DashboardPage(
                phoneNumber: phoneNumber), // Pass phone number here
          ),
        );
      } else {
        print('Login failed: ${response.body}');
      }
    }

    return Scaffold(
      backgroundColor:
          Color.fromARGB(218, 254, 250, 224), // Set a clean white background
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
                horizontal: 24.0), // Add padding to the sides
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Hallo!',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(206, 59, 59, 58),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Log in to your account',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 40),
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(234, 60, 61, 55),
                    borderRadius: BorderRadius.circular(16.0),
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromARGB(255, 60, 61, 55)
                            .withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      TextField(
                        controller: phoneController,
                        decoration: InputDecoration(
                          labelText: 'Phone Number',
                          labelStyle: TextStyle(color:  Color.fromARGB(255, 187, 133, 52)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide(
                                color:
                                    Color.fromARGB(255, 187, 133, 52)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: const BorderSide(
                                color: Color.fromARGB(255, 254, 250, 224)),
                          ),
                        ),
                        keyboardType: TextInputType.phone,
                        style: TextStyle(
                            color: Color.fromARGB(218, 254, 250, 224)),
                      ),
                      const SizedBox(height: 20), // Add spacing between fields
                      SizedBox(
                        width: double.infinity, // Membuat tombol lebar penuh
                        child: ElevatedButton(
                          onPressed: login,
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            backgroundColor:
                                const Color.fromARGB(255, 187, 133, 52),
                            elevation: 5,
                          ),
                          child: const Text(
                            'Login',
                            style: TextStyle(
                                fontSize: 16,
                                color: Color.fromARGB(218, 254, 250, 224)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10), // Add some spacing
                      TextButton(
                        onPressed: () {
                          // Navigate to the registration screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const RegisterScreen()),
                          );
                        },
                        child: const Text(
                          'Dont have an account? Register here.',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
