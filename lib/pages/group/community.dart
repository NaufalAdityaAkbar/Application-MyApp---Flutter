import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:myapp/pages/group/creategroup.dart';
import 'package:myapp/pages/group/group_detail.dart';

class Group {
  final int id;
  final String name;
  final String description;
  final String? photo;

  Group(
      {required this.id,
      required this.name,
      required this.description,
      this.photo});

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      id: json['group_id'],
      name: json['group_name'],
      description: json['group_description'],
      photo: json['group_photo'] != null
          ? 'http://192.168.2.13:3000/uploads/' + json['group_photo']
          : null,
    );
  }
}

class CommunityPage extends StatefulWidget {
  final String loggedInPhoneNumber;

  const CommunityPage({Key? key, required this.loggedInPhoneNumber})
      : super(key: key);

  @override
  _CommunityPageState createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  List<Group> groups = [];
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    fetchGroups();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      fetchGroups();
    });
  }

  Future<void> fetchGroups() async {
    final url =
        'http://192.168.2.13:3000/api/user-groups/${widget.loggedInPhoneNumber}';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> groupList = json.decode(response.body);
      setState(() {
        groups = groupList.map((json) => Group.fromJson(json)).toList();
      });
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to load groups')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Community', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Color.fromARGB(218, 254, 250, 224),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CreateGroupPage(
                        loggedInPhoneNumber: widget.loggedInPhoneNumber)),
              );
            },
          ),
        ],
      ),
      body: groups.isEmpty
          ? Center(
              child:
                  Text('No groups available', style: TextStyle(fontSize: 18)))
          : ListView.builder(
              itemCount: groups.length,
              itemBuilder: (context, index) {
                final group = groups[index];
                return Card(
                  elevation: 2,
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                  child: ListTile(
                    leading: group.photo != null
                        ? ClipOval(
                            child: Image.network(
                              group.photo!,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Icon(Icons.group,
                            size: 50, color: Color.fromARGB(255, 187, 133, 52)),
                    title: Text(group.name,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18)),
                    subtitle: Text(group.description,
                        maxLines: 1, overflow: TextOverflow.ellipsis),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GroupDetailPage(
                            groupId: group.id,
                            groupName: group.name,
                            groupDescription: group.description,
                            loggedInPhoneNumber: widget.loggedInPhoneNumber,
                            groupPhoto: group.photo,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
      backgroundColor: Color.fromARGB(218, 254, 250, 224),
    );
  }
}
