import 'package:flutter/material.dart';

import 'package:kc_admin_portal/app/theme/app_dimensions.dart';

/// The design's soft blue ring (3 px) around an input while anything inside
/// it has focus. Wraps inputs that don't manage their own focus node.
class AppFocusRing extends StatefulWidget {
  const AppFocusRing({required this.child, super.key});

  final Widget child;

  @override
  State<AppFocusRing> createState() => _AppFocusRingState();
}

class _AppFocusRingState extends State<AppFocusRing> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    return Focus(
      // Only listens: focus stays with the input inside.
      canRequestFocus: false,
      skipTraversal: true,
      onFocusChange: (focused) => setState(() => _focused = focused),
      child: AnimatedContainer(
        duration: AppDurations.hover,
        decoration: BoxDecoration(
          borderRadius: AppRadius.mdAll,
          boxShadow: _focused ? AppShadows.focusRing : const [],
        ),
        child: widget.child,
      ),
    );
  }
}
