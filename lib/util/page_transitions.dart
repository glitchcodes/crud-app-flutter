import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

CustomTransitionPage slideFromRight({
  required BuildContext context,
  required GoRouterState state,
  required Widget child
}) {
  return CustomTransitionPage(
    key: ValueKey(state.uri.path),
    child: Material(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: child
    ),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      var curve = Curves.easeInOut;

      return SlideTransition(
          position: Tween(begin: begin, end: end).animate(
            CurvedAnimation(parent: animation, curve: curve),
          ),
          child: FadeTransition(
              opacity: animation,
              child: child
          )
      );
    },
    transitionDuration: Duration(milliseconds: 300),
    reverseTransitionDuration: Duration(milliseconds: 300)
  );
}