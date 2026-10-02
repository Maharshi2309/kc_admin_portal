import 'package:flutter/widgets.dart';

import 'package:kc_admin_portal/app/theme/app_dimensions.dart';

/// Scrolls whatever gets keyboard focus into view.
///
/// Flutter scrolls to the next control while tabbing inside a page, but not
/// when focus enters a page from the navigation around it, which could
/// leave the focused control scrolled out of sight. Only keyboard use is
/// affected: taps and clicks never move the page.
class KeyboardFocusReveal extends StatefulWidget {
  const KeyboardFocusReveal({required this.child, super.key});

  final Widget child;

  @override
  State<KeyboardFocusReveal> createState() => _KeyboardFocusRevealState();
}

class _KeyboardFocusRevealState extends State<KeyboardFocusReveal> {
  FocusNode? _last;

  @override
  void initState() {
    super.initState();
    FocusManager.instance.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    FocusManager.instance.removeListener(_onFocusChanged);
    super.dispose();
  }

  void _onFocusChanged() {
    final focus = FocusManager.instance.primaryFocus;
    if (focus == _last) return;
    _last = focus;
    if (focus == null ||
        focus is FocusScopeNode ||
        FocusManager.instance.highlightMode != FocusHighlightMode.traditional) {
      return;
    }
    // After this frame, so the focused control has its final layout.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || FocusManager.instance.primaryFocus != focus) return;
      focus.context?.findRenderObject()?.showOnScreen(
        duration: AppDurations.hover,
      );
    });
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
