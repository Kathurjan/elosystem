import 'package:flutter/material.dart';

class SlideAnimationRoute<T> extends PageRouteBuilder<T> {
  final Widget child;
  final bool slideRight;

  SlideAnimationRoute({required this.child, this.slideRight = false})
      : super(
    pageBuilder: (context, animation, secondaryAnimation) => child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = slideRight ? const Offset(1.0, 0.0) : const Offset(-1.0, 0.0);
      var end = Offset.zero;
      var curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}