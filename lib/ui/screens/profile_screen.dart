import 'package:crud_app/ui/typography/text_heading.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  final Widget child;

  const ProfileScreen({super.key, required this.child});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextHeading(
          text: 'Your Profile',
          style: TextStyle(
            fontSize: 24
          ),
          fontName: 'Grenze Gotisch',
        ),
      ),
      body: widget.child
    );
  }
}