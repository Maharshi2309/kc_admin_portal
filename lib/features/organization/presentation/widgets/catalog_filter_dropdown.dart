import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kc_admin_portal/core/widgets/app_dropdown.dart';
import 'package:kc_admin_portal/core/widgets/app_filter_dropdown.dart';
import 'package:kc_admin_portal/features/organization/data/models/organization_models.dart';
import 'package:kc_admin_portal/features/organization/presentation/providers/organization_providers.dart';

/// "Department: All" / "Position: All" filter with the organization's own
/// list. Deactivated items are offered too: employees may still have them.
class CatalogFilterDropdown extends ConsumerWidget {
  const CatalogFilterDropdown({
    required this.kind,
    required this.value,
    required this.onChanged,
    super.key,
  });

  final CatalogKind kind;

  /// The chosen item's id; null for all.
  final String? value;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items =
        ref.watch(catalogProvider(kind)).value ?? const <CatalogItemModel>[];
    return AppFilterDropdown<String>(
      label: kind.singular,
      value: items.any((i) => i.id == value) ? value : null,
      onChanged: onChanged,
      items: [
        for (final item in items)
          AppDropdownItem(
            value: item.id,
            label: item.isActive ? item.name : '${item.name} (inactive)',
          ),
      ],
    );
  }
}
