import 'package:flutter/material.dart';

class GroupInfoPage extends StatelessWidget {
  final int groupId;
  final String groupName;
  final String groupDescription; // Add group description
  final String? groupPhoto;
  final List<String> groupMembers; // List of member phone numbers or names

  const GroupInfoPage({
    Key? key,
    required this.groupId,
    required this.groupName,
    required this.groupDescription,
    this.groupPhoto,
    required this.groupMembers, // Initialize the members list
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(groupName),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (groupPhoto != null)
              ClipOval(
                child: Image.network(
                  groupPhoto!,
                  fit: BoxFit.cover,
                  width: 100,
                  height: 100,
                ),
              ),
            SizedBox(height: 16),
            Text(
              groupName,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              groupDescription,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Members (${groupMembers.length}):',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            // Display the members in a ListView
            Expanded(
              child: ListView.builder(
                itemCount: groupMembers.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(groupMembers[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
