import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:myapp/pages/chat/chat_detail.dart';
import '../pages/status/status.dart';
import '../pages/group/community.dart';
import '../pages/call/call.dart';

class DashboardPage extends StatefulWidget {
  final String phoneNumber;

  const DashboardPage({super.key, required this.phoneNumber});

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _currentIndex = 0;

  // Menggunakan widget.phoneNumber untuk mengakses phoneNumber yang diteruskan
  final List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    // Inisialisasi list _pages di dalam initState
    _pages.addAll([
      ChatPage(loggedInPhoneNumber: widget.phoneNumber), // Perbaikan di sini
      StatusPage(),
      CommunityPage(),
      CallPage(),
    ]);
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[
      Icon(Icons.chat, size: 30, color: Color.fromARGB(255, 187, 133, 52)),
      Icon(Icons.message, size: 30, color: Color.fromARGB(255, 187, 133, 52)),
      Icon(Icons.people, size: 30, color: Color.fromARGB(255, 187, 133, 52)),
      Icon(Icons.call, size: 30, color: Color.fromARGB(255, 187, 133, 52)),
    ];

    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: CurvedNavigationBar(
        index: _currentIndex,
        height: 60,
        backgroundColor: Color.fromARGB(218, 254, 250, 224) , // Latar belakang konten utama diganti menjadi hitam
        color: Color.fromARGB(255, 60, 61, 55), // Warna latar belakang bar diganti menjadi oranye
        buttonBackgroundColor: Color.fromARGB(255, 60, 61, 55), // Warna item yang dipilih diganti menjadi oranye
        items: items,
        onTap: _onItemTapped,
        animationDuration: const Duration(milliseconds: 400),
        animationCurve: Curves.easeInOut,
      ),
    );
  }
}
