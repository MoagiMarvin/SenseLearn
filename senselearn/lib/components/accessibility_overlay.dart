import 'package:flutter/material.dart';

class AccessibilityOverlay extends StatelessWidget {
  final Widget child;
  final String screenName;
  final Function()? onBack;

  const AccessibilityOverlay({
    super.key,
    required this.child,
    required this.screenName,
    this.onBack,
  });

  void _announce(BuildContext context, String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("AI Voice: $message"),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragEnd: (details) {
        if (details.primaryVelocity! < -500) {
          // Swipe Up
          _announce(context, "You are currently in the $screenName.");
        } else if (details.primaryVelocity! > 500) {
          // Swipe Down
          if (onBack != null) {
            onBack!();
          } else {
            Navigator.maybePop(context);
            _announce(context, "Going back.");
          }
        }
      },
      child: child,
    );
  }
}
