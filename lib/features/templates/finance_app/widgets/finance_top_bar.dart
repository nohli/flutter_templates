import 'package:flutter/material.dart';

class FinanceTopBar extends StatelessWidget {
  const FinanceTopBar({required this.title, super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    final canGoBack = Navigator.of(context).canPop();
    final usesLargeText = MediaQuery.textScalerOf(context).scale(1) >= 2;

    if (usesLargeText) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(8, 4, 16, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (canGoBack) _BackButton(onPressed: () => Navigator.of(context).pop()),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                title,
                key: ValueKey<String>(title),
                maxLines: 1,
                overflow: TextOverflow.fade,
                softWrap: false,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return SizedBox(
      height: 72,
      child: Row(
        children: <Widget>[
          if (canGoBack) _BackButton(onPressed: () => Navigator.of(context).pop()) else const SizedBox(width: 20),
          Expanded(
            child: AnimatedSwitcher(
              duration: MediaQuery.disableAnimationsOf(context) ? Duration.zero : const Duration(milliseconds: 240),
              switchInCurve: Curves.easeOutCubic,
              switchOutCurve: Curves.easeInCubic,
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(begin: const Offset(0, 0.18), end: Offset.zero).animate(animation),
                    child: child,
                  ),
                );
              },
              child: Text(
                title,
                key: ValueKey<String>(title),
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: IconButton(
        tooltip: 'Back to template gallery',
        onPressed: onPressed,
        icon: const Icon(Icons.arrow_back_rounded),
      ),
    );
  }
}
