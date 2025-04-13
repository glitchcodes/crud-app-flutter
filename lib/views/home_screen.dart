import 'dart:ui' as ui;

import 'package:crud_app/main.dart';
import 'package:crud_app/widgets/drawer/home_drawer.dart';
import 'package:crud_app/widgets/typography/text_heading.dart';
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
        leading: Builder(
          builder: (context) {
            return IconButton(
                icon: Icon(Icons.menu),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                }
            );
          }
        ),
        title: TextHeading(
          text: 'The Hub',
          style: TextStyle(
              fontSize: 24
          ),
          fontName: 'Grenze Gotisch',
        ),
      ),
      drawer: HomeDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // SearchSCP(),
            ObjectClassCategories(),
            RecentSCP()
          ],
        ),
      )
    );
  }
}