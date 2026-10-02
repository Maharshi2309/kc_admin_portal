import 'package:flutter/material.dart';

import 'package:kc_admin_portal/app/theme/app_colors.dart';
import 'package:kc_admin_portal/core/widgets/app_feedback_view.dart';

/// Empty state, e.g. "No employees match these filters".
class AppEmptyView extends StatelessWidget {
  const AppEmptyView({
    required this.title,
    this.message,
    this.icon = Icons.inbox_outlined,
    this.action,
    this.compact = false,
    super.key,
  });

  final String title;
  final String? message;
  final IconData icon;

  /// e.g. a "Clear filters" or "Add employee" button.
  final Widget? action;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return AppFeedbackView(
      icon: icon,
      iconColor: AppColors.textSecondary,
      iconBackground: AppColors.neutralBg,
      title: title,
      message: message,
      action: action,
      compact: compact,
    );
  }
}
