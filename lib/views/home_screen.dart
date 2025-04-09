import 'package:flutter/material.dart';

import '../widgets/search_scp.dart';
import '../widgets/object_class_categories.dart';
import '../widgets/recent_scp_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('The Directory'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SearchSCP(),
            ObjectClassCategories(),
            RecentSCP()
          ],
        ),
      )
    );
  }
}