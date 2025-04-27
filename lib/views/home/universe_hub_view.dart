import 'package:flutter/material.dart';

class UniverseHubView extends StatelessWidget {
  const UniverseHubView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(16),
        child: Text('Universe Hub goes here'),
      ),
    );
  }
}