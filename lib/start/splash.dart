import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../app/login.dart'; // Pastikan ini mengarah ke halaman utama aplikasi Anda
import 'dart:async';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _opacity = 0; // Variabel untuk mengatur opacity

  @override
  void initState() {
    super.initState();

    // Timer untuk pindah ke halaman utama setelah beberapa detik
    Timer(const Duration(seconds: 8), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => LoginScreen()),
      );
    });

    // Mengatur opacity untuk teks agar muncul perlahan
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        _opacity = 1; // Meningkatkan opacity ke 1 untuk membuat teks muncul
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(120, 244, 234, 170), // Mengubah warna latar belakang
      body: Center(
        child: Stack(
          alignment: Alignment.center, // Mengatur agar anak-anak berada di tengah
          children: [
            // Tampilkan animasi Lottie dari URL
            Lottie.network(
              'https://lottie.host/304c4421-70f4-4a2d-95eb-9a627f726132/UaHfbyWMPR.json',
              width: 500,
              height: 700,
              fit: BoxFit.contain,
            ),
            // Tampilkan teks "Welcome to MyApp" dengan efek opacity
            Positioned(
              top: 90, // Mengatur jarak dari atas
              child: AnimatedOpacity(
                opacity: _opacity,
                duration: const Duration(seconds: 1), // Durasi animasi opacity
                child: const Text(
                  'Welcome to MyApp',
                  style: TextStyle(
                    fontSize: 24, // Ukuran font untuk teks
                    fontWeight: FontWeight.bold,
                    color:  Color.fromARGB(255, 60, 61, 55),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
