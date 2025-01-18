import 'package:flutter/material.dart';
import '../login_page.dart'; // Import the LoginPage for navigation

class NavBar extends StatelessWidget {
  final String username;
  final String userId;

  NavBar({required this.username, required this.userId});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false, // Removes default back button
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.orange.shade300, const Color.fromARGB(255, 148, 85, 8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
      title: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.brown[200],
            child: Icon(Icons.person, color: Colors.brown[700]),
          ),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Welcome, $username',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                'User ID: $userId',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withAlpha(120),
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.notifications, color: Colors.white),
          onPressed: () {
            // Add notification functionality
          },
        ),
        IconButton(
          icon: Icon(Icons.settings, color: Colors.white),
          onPressed: () {
            // Add settings functionality
          },
        ),
        IconButton(
          icon: Icon(Icons.logout, color: Colors.white),
          onPressed: () {
            // Navigate back to the LoginPage
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
            );
          },
        ),
      ],
    );
  }
}
