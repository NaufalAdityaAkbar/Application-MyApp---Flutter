import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:myapp/pages/chat/chat.dart';

class ContactsPage extends StatefulWidget {
  final String loggedInPhoneNumber;

  ContactsPage({required this.loggedInPhoneNumber});

  @override
  _ContactsPageState createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  List<dynamic> contacts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchContacts();
  }

  Future<void> fetchContacts() async {
    final response = await http.get(
      Uri.parse('http://192.168.2.13:3000/api/users'),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      setState(() {
        contacts = json.decode(response.body);
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      print("Error fetching contacts: ${response.statusCode}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contacts"),
        backgroundColor: Colors.black,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : contacts.isEmpty
              ? Center(child: Text("No contacts available", style: TextStyle(color: Colors.white)))
              : ListView.builder(
                  itemCount: contacts.length,
                  itemBuilder: (context, index) {
                    var contact = contacts[index];

                    // Membuat URL foto dengan format yang benar
                    final String photoPath = contact['photo']?.replaceAll('\\', '/') ?? 'default.jpg';
                    final String imageUrl = 'http://192.168.2.13:3000/$photoPath';

                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(imageUrl),
                      ),
                      title: Text(contact['name'] ?? 'No Name'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.call, color: Colors.orange),
                            onPressed: () {
                              // Implement call feature if needed
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.chat, color: Colors.orange),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChatDetailPage(
                                    contactName: contact['name'] ?? 'No Name',
                                    contactPhoneNumber: contact['phone_number'],
                                    loggedInPhoneNumber: widget.loggedInPhoneNumber,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
      backgroundColor: Colors.black,
    );
  }
}
