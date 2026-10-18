import 'package:flutter/material.dart';

import '../dating_app_theme.dart';
import '../../../../l10n/localizations.dart';

class DatingActionBar extends StatelessWidget {
  const DatingActionBar({required this.onDismiss, required this.onLike, required this.onSpark, this.onUndo, super.key});

  final VoidCallback onDismiss;
  final VoidCallback onLike;
  final VoidCallback onSpark;
  final VoidCallback? onUndo;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        _DatingAction(
          tooltip: context.l10n.undoLastChoice,
          icon: Icons.undo_rounded,
          color: DatingAppTheme.lavender,
          onPressed: onUndo,
        ),
        const SizedBox(width: 12),
        _DatingAction(
          tooltip: context.l10n.passOnProfile,
          icon: Icons.close_rounded,
          color: DatingAppTheme.coral,
          onPressed: onDismiss,
          prominent: true,
        ),
        const SizedBox(width: 12),
        _DatingAction(
          tooltip: context.l10n.sendASpark,
          icon: Icons.auto_awesome_rounded,
          color: const Color(0xFFFFC857),
          onPressed: onSpark,
        ),
        const SizedBox(width: 12),
        _DatingAction(
          tooltip: context.l10n.likeProfile,
          icon: Icons.favorite_rounded,
          color: DatingAppTheme.primary,
          onPressed: onLike,
          prominent: true,
        ),
      ],
    );
  }
}

class _DatingAction extends StatelessWidget {
  const _DatingAction({
    required this.tooltip,
    required this.icon,
    required this.color,
    required this.onPressed,
    this.prominent = false,
  });

  final String tooltip;
  final IconData icon;
  final Color color;
  final VoidCallback? onPressed;
  final bool prominent;

  @override
  Widget build(BuildContext context) {
    final size = prominent ? 64.0 : 52.0;
    final colors = Theme.of(context).colorScheme;

    return SizedBox.square(
      dimension: size,
      child: IconButton.filledTonal(
        tooltip: tooltip,
        onPressed: onPressed,
        style: IconButton.styleFrom(
          backgroundColor: colors.surfaceContainerHighest,
          disabledBackgroundColor: colors.surfaceContainerHighest.withValues(alpha: 0.38),
          shape: CircleBorder(side: BorderSide(color: color.withValues(alpha: 0.7))),
        ),
        icon: Icon(icon, color: onPressed == null ? colors.outline : color, size: prominent ? 30 : 24),
      ),
    );
  }
}
