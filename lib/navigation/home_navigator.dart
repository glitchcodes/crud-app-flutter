import 'package:crud_app/views/home/home_view.dart';
import 'package:flutter/material.dart';


class HomeNavigator extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  const HomeNavigator({
    super.key,
    required this.navigatorKey
  });

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      initialRoute: '/home',
      onGenerateRoute: (RouteSettings settings) {
        late Widget page;

        switch (settings.name) {
          case '/home':
          default:
            page = HomeView();
            break;
        }

        return MaterialPageRoute(
          builder: (_) => page,
          settings: settings
        );
      }
    );
  }
}