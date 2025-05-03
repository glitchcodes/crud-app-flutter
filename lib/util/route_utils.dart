import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

class RouteUtils {
  static bool isSeriesItemRoute(BuildContext context) {
    final state = GoRouterState.of(context);
    final pathSegments = state.uri.pathSegments;

    return pathSegments.length == 3 &&
        pathSegments[0] == 'directory' &&
        !pathSegments[1].contains('contribute') &&
        state.pathParameters.containsKey('seriesId') &&
        state.pathParameters.containsKey('itemId');
  }

  // static bool isOnRoute(BuildContext context, String routeName) {
  //   final router = GoRouter.of(context);
  //   return router.routeInformationProvider.value.uri.path == '/$routeName';
  // }
  //
  // static bool isOnParameterizedRoute(BuildContext context, String pathTemplate) {
  //   final router = GoRouter.of(context);
  //   final currentPath = router.routeInformationProvider.value.uri.path ?? '';
  //
  //   // Convert path template to regex
  //   final regexPattern = '^${pathTemplate.replaceAllMapped(
  //       RegExp(r':\w+'),
  //           (match) => r'[^\/]+'
  //   )}\$';
  //
  //   return RegExp(regexPattern).hasMatch(currentPath);
  // }
  //
  static Map<String, String>? getCurrentParams(BuildContext context) {
    return GoRouterState.of(context).pathParameters;
  }
}