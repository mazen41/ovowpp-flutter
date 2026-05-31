import 'package:flutter/material.dart';

import '../../../core/utils/dimensions.dart';

class StatusBadge extends StatelessWidget {
  final String text;
  final Color color;
  const StatusBadge({super.key, required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.space10, vertical: Dimensions.space2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(Dimensions.badgeRadius),
        border: Border.all(color: color, width: .2),
      ),
      child: Text(
        text,
        style: theme.textTheme.labelMedium?.copyWith(color: color, fontWeight: FontWeight.w500, fontSize: 14),
      ),
    );
  }
}
