import 'package:flutter/material.dart';

import '../finance_app_theme.dart';

class FinanceTopBar extends StatelessWidget {
  const FinanceTopBar({required this.title, super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    final canGoBack = Navigator.of(context).canPop();
    final usesLargeText = MediaQuery.textScalerOf(context).scale(1) >= 2;

    return Padding(
      padding: EdgeInsets.fromLTRB(usesLargeText ? 8 : 14, 8, 16, 10),
      child: usesLargeText
          ? _LargeTopBar(title: title, canGoBack: canGoBack)
          : _StandardTopBar(title: title, canGoBack: canGoBack),
    );
  }
}

class _StandardTopBar extends StatelessWidget {
  const _StandardTopBar({required this.title, required this.canGoBack});

  final String title;
  final bool canGoBack;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 64,
      child: Row(
        children: <Widget>[
          if (canGoBack) const _BackButton() else const SizedBox(width: 46),
          const SizedBox(width: 12),
          Expanded(child: _AnimatedTitle(title: title)),
          const SizedBox(width: 10),
          const _MarketStatus(),
        ],
      ),
    );
  }
}

class _LargeTopBar extends StatelessWidget {
  const _LargeTopBar({required this.title, required this.canGoBack});

  final String title;
  final bool canGoBack;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (canGoBack) const _BackButton(),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: _AnimatedTitle(title: title),
        ),
      ],
    );
  }
}

class _AnimatedTitle extends StatelessWidget {
  const _AnimatedTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          'ORBIT / PERSONAL FINANCE',
          maxLines: 1,
          overflow: TextOverflow.fade,
          softWrap: false,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontSize: 9,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.4,
          ),
        ),
        const SizedBox(height: 4),
        AnimatedSwitcher(
          duration: MediaQuery.disableAnimationsOf(context) ? Duration.zero : const Duration(milliseconds: 240),
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
            maxLines: 1,
            overflow: TextOverflow.fade,
            softWrap: false,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 24,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.8,
              height: 1,
            ),
          ),
        ),
      ],
    );
  }
}

class _MarketStatus extends StatelessWidget {
  const _MarketStatus();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Semantics(
      label: 'Markets live',
      child: ExcludeSemantics(
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(color: colors.outlineVariant),
            borderRadius: const BorderRadius.all(Radius.circular(6)),
          ),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 9, vertical: 7),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                DecoratedBox(
                  decoration: BoxDecoration(color: FinanceAppTheme.mint, shape: BoxShape.circle),
                  child: SizedBox.square(dimension: 6),
                ),
                SizedBox(width: 6),
                Text('LIVE', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, letterSpacing: 1)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton();

  @override
  Widget build(BuildContext context) {
    return IconButton.outlined(
      tooltip: 'Back to template gallery',
      onPressed: () => Navigator.of(context).pop(),
      style: IconButton.styleFrom(
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
      ),
      icon: const Icon(Icons.arrow_back_rounded),
    );
  }
}
