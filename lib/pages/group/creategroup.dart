import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

// Model User
class User {
  final int id;
  final String phoneNumber;
  final String name;
  final String? bio;
  final String? photo;

  User({
    required this.id,
    required this.phoneNumber,
    required this.name,
    this.bio,
    this.photo,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      phoneNumber: json['phone_number'] ?? '',
      name: json['name'] ?? '',
      bio: json['bio'],
      photo: json['photo'] != null ? 'http://192.168.2.13:3000/' + json['photo'].replaceAll('\\', '/') : null,
    );
  }
}

class CreateGroupPage extends StatefulWidget {
  final String loggedInPhoneNumber;

  const CreateGroupPage({Key? key, required this.loggedInPhoneNumber}) : super(key: key);

  @override
  _CreateGroupPageState createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends State<CreateGroupPage> {
  String? groupName, groupDescription;
  List<String> selectedMembers = [];
  String? groupPhoto;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Group', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Group Name', style: TextStyle(fontSize: 18, color: Colors.black)),
            TextField(
              onChanged: (value) {
                groupName = value;
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            Text('Group Description', style: TextStyle(fontSize: 18, color: Colors.black)),
            TextField(
              onChanged: (value) {
                groupDescription = value;
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _selectGroupPhoto,
              child: Text('Select Group Photo'),
            ),
            if (groupPhoto != null) ...[
              SizedBox(height: 10),
              Text('Selected Photo:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Image.file(File(groupPhoto!), width: 100, height: 100, fit: BoxFit.cover),
            ],
            SizedBox(height: 10),
            Text('Select Members', style: TextStyle(fontSize: 18, color: Colors.black)),
            Expanded(
              child: FutureBuilder<List<User>>(
                future: fetchUsers(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error fetching users', style: TextStyle(color: Colors.red)));
                  } else {
                    return _buildUserList(snapshot.data!);
                  }
                },
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _createGroup,
              child: Text('Create Group'),
            ),
          ],
        ),
      ),
    );
  }

  void _createGroup() async {
    if (groupName == null || groupName!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please enter a group name.')));
      return;
    }
    if (groupDescription == null || groupDescription!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please enter a group description.')));
      return;
    }
    if (selectedMembers.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please select at least one member.')));
      return;
    }

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('http://192.168.2.13:3000/api/create-group'),
    );

    request.fields['group_name'] = groupName!;
    request.fields['group_description'] = groupDescription!;
    request.fields['members'] = json.encode(selectedMembers);
    request.fields['creator_phone_number'] = widget.loggedInPhoneNumber; // Menambahkan nomor telepon pembuat grup

    if (groupPhoto != null) {
      request.files.add(await http.MultipartFile.fromPath('group_photo', groupPhoto!));
    }

    final response = await request.send();
    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Group created successfully')));
      Navigator.pop(context); // Kembali ke halaman sebelumnya setelah grup dibuat
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to create group. Error: ${response.reasonPhrase}')));
    }
  }

  // Widget _buildUserList
  Widget _buildUserList(List<User> users) {
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(users[index].name),
          subtitle: Text(users[index].bio ?? 'No bio available'),
          leading: users[index].photo != null 
            ? Image.network(users[index].photo!, width: 40, height: 40, fit: BoxFit.cover) 
            : Icon(Icons.person, color: Colors.grey),
          trailing: IconButton(
            icon: selectedMembers.contains(users[index].phoneNumber)
                ? Icon(Icons.check, color: Colors.green)
                : Icon(Icons.add, color: Colors.orange),
            onPressed: () {
              setState(() {
                if (selectedMembers.contains(users[index].phoneNumber)) {
                  selectedMembers.remove(users[index].phoneNumber);
                } else {
                  selectedMembers.add(users[index].phoneNumber);
                }
              });
            },
          ),
        );
      },
    );
  }

  void _selectGroupPhoto() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        groupPhoto = pickedFile.path;
      });
    }
  }

  Future<List<User>> fetchUsers() async {
    try {
      final response = await http.get(Uri.parse('http://192.168.2.13:3000/api/contact'));

      if (response.statusCode == 200) {
        final List<dynamic> userList = json.decode(response.body);
        return userList.map((user) => User.fromJson(user)).toList();
      } else {
        throw Exception('Failed to load users, status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching users: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error fetching users: $e')));
      return []; // Kembalikan daftar kosong jika ada kesalahan
    }
  }
}
