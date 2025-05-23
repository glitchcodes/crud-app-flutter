import 'package:flutter/material.dart';

import 'package:crud_app/ui/object_class_categories.dart';
import 'package:crud_app/ui/recent_scp_list.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // SearchSCP(),
          ObjectClassCategories(),
          RecentSCP()
        ],
      ),
    );
  }
}