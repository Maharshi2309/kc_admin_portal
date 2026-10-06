import 'package:flutter/material.dart';

import 'package:kc_admin_portal/app/theme/app_colors.dart';
import 'package:kc_admin_portal/app/theme/app_dimensions.dart';
import 'package:kc_admin_portal/app/theme/app_text_styles.dart';
import 'package:kc_admin_portal/core/utils/format_utils.dart';

/// An organization's logo on a square tile, or its initials when it has
/// none (or the image can't load).
///
/// [logoUrl] is normally an https URL from the API. The dev mock also uses
/// `data:` URLs (uploaded logos) and `asset:` paths (Keshav's bundled logo).
class OrganizationLogo extends StatelessWidget {
  const OrganizationLogo({
    required this.name,
    required this.logoUrl,
    this.size = defaultSize,
    super.key,
  });

  final String name;
  final String? logoUrl;
  final double size;

  static const double defaultSize = 38;

  /// Space around the image inside the tile.
  static const double _imageInset = 0.12;

  @override
  Widget build(BuildContext context) {
    final initials = Center(
      child: Text(
        FormatUtils.initials(name),
        style: AppTextStyles.bodyBold.copyWith(
          color: AppColors.primary,
          fontSize: size * 0.36,
        ),
      ),
    );
    final image = _image(initials);

    return Semantics(
      label: '$name logo',
      image: true,
      excludeSemantics: true,
      child: Container(
        width: size,
        height: size,
        clipBehavior: Clip.antiAlias,
        padding: image == null ? null : EdgeInsets.all(size * _imageInset),
        decoration: BoxDecoration(
          color: image == null ? AppColors.primarySoft : AppColors.surface,
          border: Border.all(color: AppColors.border),
          borderRadius: AppRadius.mdAll,
        ),
        child: image ?? initials,
      ),
    );
  }

  Widget? _image(Widget fallback) {
    final url = logoUrl;
    if (url == null || url.isEmpty) return null;
    Widget onError(BuildContext context, Object error, StackTrace? stack) =>
        fallback;
    if (url.startsWith('asset:')) {
      return Image.asset(
        url.substring('asset:'.length),
        fit: BoxFit.contain,
        errorBuilder: onError,
      );
    }
    if (url.startsWith('data:')) {
      final data = Uri.tryParse(url)?.data;
      if (data == null) return null;
      return Image.memory(
        data.contentAsBytes(),
        fit: BoxFit.contain,
        errorBuilder: onError,
      );
    }
    return Image.network(url, fit: BoxFit.contain, errorBuilder: onError);
  }
}
