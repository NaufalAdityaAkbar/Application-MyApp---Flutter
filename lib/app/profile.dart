import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../app/dasboard.dart';

class ProfileScreen extends StatefulWidget {
  final String phoneNumber;

  const ProfileScreen({super.key, required this.phoneNumber});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  File? _image;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadProfile() async {
    if (_image == null || nameController.text.isEmpty || bioController.text.isEmpty) {
      print('Please fill all fields and select an image.');
      return;
    }

    final request = http.MultipartRequest(
      'PUT',
      Uri.parse('http://10.0.2.2:3000/api/users/profile'), // Sesuaikan dengan endpoint
    );

    request.fields['phone_number'] = widget.phoneNumber; // Gunakan nomor telepon dari pendaftaran
    request.fields['name'] = nameController.text;
    request.fields['bio'] = bioController.text;
    request.files.add(await http.MultipartFile.fromPath('photo', _image!.path));

    try {
      final response = await request.send();

      if (response.statusCode == 200) {
        print('Profile completed successfully');
        // Navigasi ke halaman Home setelah sukses
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DashboardPage(phoneNumber: widget.phoneNumber)));
      } else {
        print('Failed to complete profile: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Complete Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: bioController,
              decoration: const InputDecoration(labelText: 'Bio'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text('Select Image'),
            ),
            if (_image != null) Image.file(_image!),
            ElevatedButton(
              onPressed: _uploadProfile,
              child: const Text('Upload Profile'),
            ),
          ],
        ),
      ),
    );
  }
}
