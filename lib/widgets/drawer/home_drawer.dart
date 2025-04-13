import 'package:flutter/material.dart';

import 'package:crud_app/widgets/typography/text_heading.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: ListView(
          children: [
            Padding(padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextHeading(
                  text: 'SCP Foundation',
                  style: TextStyle(
                      fontSize: 12
                  ),
                ),
                TextHeading(
                  text: 'The Hub',
                  style: TextStyle(
                      fontSize: 24
                  ),
                  fontName: 'Grenze Gotisch',
                ),
              ],
            ),
            ),
            SizedBox(height: 16),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: TextHeading(
                text: 'Getting Started',
                style: TextStyle(fontSize: 14)
              )
            ),
            ListTile(
                leading: Icon(Icons.book_rounded),
                title: Text('Guide for Newcomers'),
                onTap: () {
                  // TODO
                }
            ),
            ListTile(
                leading: Icon(Icons.accessibility_new_rounded),
                title: Text('Contribute'),
                onTap: () {
                  // TODO
                }
            ),
            ListTile(
                leading: Icon(Icons.quiz_rounded),
                title: Text('FAQ'),
                onTap: () {
                  // TODO
                }
            ),
            ListTile(
                leading: Icon(Icons.forum_rounded),
                title: Text('Universe Hub'),
                onTap: () {
                  // TODO
                }
            ),
          ],
        ),
      )
    );
  }
}