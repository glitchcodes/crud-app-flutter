import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SearchSCP extends StatelessWidget {
  const SearchSCP({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: SearchBar(
        padding: const WidgetStatePropertyAll<EdgeInsets>(
          EdgeInsets.symmetric(horizontal: 16),
        ),
        leading: Icon(Icons.search),
        hintText: 'Search SCPs',
        onTap: () => context.go('/directory/search'),
      ),
      // child: TextField(
      //   decoration: InputDecoration(
      //       labelText: 'Search SCPs',
      //       floatingLabelBehavior: FloatingLabelBehavior.never,
      //       filled: true,
      //       border: OutlineInputBorder(
      //           borderRadius: BorderRadius.circular(10)
      //       ),
      //       prefixIcon: Icon(Icons.search)
      //   ),
      //   onTap: () => context.go('/directory/search'),
      // ),
    );
  }
}
