import 'package:flutter/material.dart';

import 'package:kc_admin_portal/app/theme/app_colors.dart';
import 'package:kc_admin_portal/app/theme/app_dimensions.dart';
import 'package:kc_admin_portal/app/theme/app_text_styles.dart';
import 'package:kc_admin_portal/core/utils/date_utils.dart';
import 'package:kc_admin_portal/core/utils/format_utils.dart';
import 'package:kc_admin_portal/core/widgets/app_avatar.dart';
import 'package:kc_admin_portal/core/widgets/app_card.dart';
import 'package:kc_admin_portal/core/widgets/ec_number_text.dart';

/// Live preview of the employee being added or edited (design board 04).
class EmployeePreviewCard extends StatelessWidget {
  const EmployeePreviewCard({
    required this.name,
    required this.ecNumber,
    required this.mobile,
    required this.departmentName,
    required this.positionName,
    required this.joiningDate,
    super.key,
  });

  final String name;
  final String ecNumber;
  final String mobile;
  final String? departmentName;
  final String? positionName;
  final DateTime? joiningDate;

  static const String _placeholder = '—';

  @override
  Widget build(BuildContext context) {
    final displayName = name.trim().isEmpty ? 'New employee' : name.trim();

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSpacing.s16,
        children: [
          Text('PREVIEW', style: AppTextStyles.overline),
          Row(
            spacing: AppSpacing.s12,
            children: [
              AppAvatar(name: displayName, size: AppSizes.avatarLarge),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: AppSpacing.s2,
                  children: [
                    Text(
                      displayName,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.sectionTitle,
                    ),
                    Text(
                      '${positionName ?? 'Position'} · '
                      '${departmentName ?? 'Department'}',
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.small.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          _Row(
            label: 'EC number',
            child: ecNumber.trim().isEmpty
                ? const Text(_placeholder)
                : EcNumberText(ecNumber.trim().toUpperCase()),
          ),
          _Row(
            label: 'Mobile',
            value: mobile.isEmpty ? '' : FormatUtils.mobile(mobile),
          ),
          _Row(
            label: 'Joins',
            value: joiningDate == null
                ? ''
                : AppDateFormat.medium(joiningDate!),
          ),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.label, this.value, this.child});

  final String label;
  final String? value;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final text = value == null || value!.trim().isEmpty
        ? EmployeePreviewCard._placeholder
        : value!.trim();

    return Row(
      spacing: AppSpacing.s12,
      children: [
        Text(
          label,
          style: AppTextStyles.small.copyWith(color: AppColors.textMuted),
        ),
        Expanded(
          child: Align(
            alignment: AlignmentDirectional.centerEnd,
            child:
                child ??
                Text(
                  text,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.small,
                ),
          ),
        ),
      ],
    );
  }
}
