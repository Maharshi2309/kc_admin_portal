import 'package:flutter/material.dart';

import 'package:kc_admin_portal/app/theme/app_colors.dart';
import 'package:kc_admin_portal/app/theme/app_dimensions.dart';
import 'package:kc_admin_portal/app/theme/app_text_styles.dart';

/// The Keshav Clothing "KC" logo on a tile, optionally followed by
/// "Keshav Clothing / Admin Portal".
class BrandMark extends StatelessWidget {
  const BrandMark({this.showName = true, this.inverted = false, super.key});

  final bool showName;

  /// Light tile on a dark background (login brand panel).
  final bool inverted;

  static const double _tileSize = 38;

  /// The logo's height as a share of the tile.
  static const double _logoShare = 0.7;
  static const double _nameSize = 15;

  @override
  Widget build(BuildContext context) {
    final tile = Container(
      width: _tileSize,
      height: _tileSize,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: inverted ? AppColors.onInverse : AppColors.inverse,
        borderRadius: AppRadius.mdAll,
      ),
      child: KcLogo(
        height: _tileSize * _logoShare,
        color: inverted ? AppColors.inverse : AppColors.onPrimary,
      ),
    );
    if (!showName) {
      return Semantics(label: 'Keshav Admin Portal', child: tile);
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: AppSpacing.s12,
      children: [
        ExcludeSemantics(child: tile),
        // Shrinks with an ellipsis in the narrow sidebar at large font sizes.
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Keshav Clothing',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.bodyBold.copyWith(
                  fontSize: _nameSize,
                  color: inverted ? AppColors.onInverse : null,
                ),
              ),
              Text(
                'Admin Portal',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption.copyWith(
                  color: inverted
                      ? AppColors.onInverseMuted
                      : AppColors.textMuted,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// The "KC" mark alone, in one colour (it is a single-colour logo).
class KcLogo extends StatelessWidget {
  const KcLogo({
    required this.height,
    this.color = AppColors.inverse,
    super.key,
  });

  final double height;
  final Color color;

  static const String asset = 'assets/brand/kc_logo.png';

  /// Width : height of the artwork.
  static const double aspectRatio = 238 / 512;

  @override
  Widget build(BuildContext context) => Image.asset(
    asset,
    height: height,
    width: height * aspectRatio,
    color: color,
    colorBlendMode: BlendMode.srcIn,
    filterQuality: FilterQuality.medium,
    excludeFromSemantics: true,
  );
}
