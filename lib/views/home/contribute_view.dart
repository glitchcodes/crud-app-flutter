import 'package:flutter/material.dart';

class ContributeView extends StatelessWidget {
  const ContributeView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(16),
        child: Text('Contribute goes here'),
      ),
    );
  }
}