import 'package:flutter/material.dart';

class SearchSCP extends StatelessWidget {
  const SearchSCP({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: TextField(
        decoration: InputDecoration(
            labelText: 'Search SCPs',
            floatingLabelBehavior: FloatingLabelBehavior.never,
            filled: true,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10)
            ),
            prefixIcon: Icon(Icons.search)
        ),
      ),
    );
  }
}
