import 'package:flutter/material.dart';

import 'package:crud_app/widgets/drawer/home_drawer.dart';
import 'package:crud_app/widgets/object_class_categories.dart';
import 'package:crud_app/widgets/recent_scp_list.dart';
import 'package:crud_app/widgets/typography/text_heading.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

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
                    });
              }),
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