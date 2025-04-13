import 'package:crud_app/views/home/home_view.dart';
import 'package:flutter/material.dart';


class HomeNavigator extends StatefulWidget {
  const HomeNavigator({super.key});

  @override
  State<HomeNavigator> createState() => _HomeNavigatorState();
}

class _HomeNavigatorState extends State<HomeNavigator> {
  GlobalKey<NavigatorState> homeNavigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: homeNavigatorKey,
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
          settings: settings, builder: (BuildContext context) {
            if (settings.name == '') {
              return Container();
            }

            return HomeView();
          }
        );
      }
    );
  }
}