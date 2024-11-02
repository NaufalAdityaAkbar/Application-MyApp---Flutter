import 'package:flutter/material.dart';

class StatusPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Status',
          style: TextStyle(fontWeight: FontWeight.bold, color: Color.fromARGB(255, 187, 133, 52)),
        ),
        backgroundColor: Color.fromARGB(218, 254, 250, 224),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.camera_alt, color: Color.fromARGB(255, 187, 133, 52)),
            onPressed: () {
              // Aksi untuk kamera
            },
          ),
          IconButton(
            icon: Icon(Icons.more_vert, color: Color.fromARGB(255, 187, 133, 52)),
            onPressed: () {
              // Aksi untuk menu lainnya
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          // Status Saya
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Color.fromARGB(255, 60, 61, 55),
                      child: Icon(Icons.person, color: Colors.orange, size: 40),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 60, 61, 55),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.orange, width: 2),
                        ),
                        child: Icon(Icons.add, size: 18, color: Colors.orange),
                      ),
                    )
                  ],
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Status Saya',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 187, 133, 52),
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'Ketuk untuk menambahkan pembaruan status',
                        style: TextStyle(color: Colors.grey[400]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          Container(
            color: Color.fromARGB(80, 215, 215, 205),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'Pembaruan Terbaru',
              style: TextStyle(
                color: Colors.orange,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          // Daftar status pengguna lain
          ListTile(
            leading: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.orange, width: 2),
              ),
              child: CircleAvatar(
                radius: 28,
              backgroundColor: Color.fromARGB(255, 60, 61, 55),
                child: Icon(Icons.person, color: Colors.orange),
              ),
            ),
            title: Text(
              'User 1',
              style: TextStyle(fontWeight: FontWeight.bold, color: Color.fromARGB(255, 187, 133, 52)),
            ),
            subtitle: Text(
              'Hari ini, 10:00 AM',
              style: TextStyle(color: Colors.grey[400]),
            ),
            onTap: () {
              // Aksi untuk melihat status
            },
          ),
          ListTile(
            leading: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.orange, width: 2),
              ),
              child: CircleAvatar(
                radius: 28,
                backgroundColor: Color.fromARGB(255, 60, 61, 55),
                child: Icon(Icons.person, color: Colors.orange),
              ),
            ),
            title: Text(
              'User 2',
              style: TextStyle(fontWeight: FontWeight.bold, color: Color.fromARGB(255, 187, 133, 52)),
            ),
            subtitle: Text(
              'Hari ini, 8:30 AM',
              style: TextStyle(color: Colors.grey[400]),
            ),
            onTap: () {
              // Aksi untuk melihat status
            },
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            mini: true,
            heroTag: "edit_status",
            onPressed: () {
              // Aksi untuk edit status
            },
            backgroundColor: Color.fromARGB(255, 187, 133, 52),
            child: Icon(Icons.edit, color: Color.fromARGB(255, 60, 61, 55)),
          ),
          SizedBox(height: 8),
          FloatingActionButton(
            heroTag: "add_status",
            onPressed: () {
              // Aksi untuk menambahkan status baru
            },
            backgroundColor: Color.fromARGB(255, 187, 133, 52),
            child: Icon(Icons.camera_alt, color: Color.fromARGB(255, 60, 61, 55)),
          ),
        ],
      ),
      backgroundColor: Color.fromARGB(218, 254, 250, 224),
    );
  }
}
