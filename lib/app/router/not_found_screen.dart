import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:kc_admin_portal/app/router/route_names.dart';
import 'package:kc_admin_portal/app/theme/app_dimensions.dart';
import 'package:kc_admin_portal/core/widgets/app_button.dart';
import 'package:kc_admin_portal/core/widgets/app_empty_view.dart';
import 'package:kc_admin_portal/shared/widgets/brand_mark.dart';

class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(AppSpacing.s24),
              child: BrandMark(),
            ),
            Expanded(
              child: AppEmptyView(
                icon: Icons.explore_off_outlined,
                title: 'Page not found',
                message: 'The address may be mistyped, or the page has moved.',
                action: AppButton(
                  label: 'Go to dashboard',
                  onPressed: () => context.goNamed(AppRouteNames.dashboard),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
