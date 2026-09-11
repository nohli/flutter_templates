import 'package:flutter/material.dart';

class TemplateEntrance extends StatelessWidget {
  const TemplateEntrance({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.disableAnimationsOf(context)) {
      return child;
    }

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 520),
      curve: Curves.easeOutCubic,
      child: child,
      builder: (BuildContext context, double value, Widget? child) {
        return Opacity(
          opacity: 0.72 + 0.28 * value,
          child: Transform.translate(offset: Offset(0, 12 * (1 - value)), child: child),
        );
      },
    );
  }
}

class TemplateSectionSwitcher extends StatefulWidget {
  const TemplateSectionSwitcher({required this.selectedIndex, required this.children, super.key});

  final int selectedIndex;
  final List<Widget> children;

  @override
  State<TemplateSectionSwitcher> createState() => _TemplateSectionSwitcherState();
}

class _TemplateSectionSwitcherState extends State<TemplateSectionSwitcher> with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(duration: const Duration(milliseconds: 320), value: 1, vsync: this);

  late final _animation = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _controller.value = 1;
    }
  }

  @override
  void didUpdateWidget(TemplateSectionSwitcher oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedIndex == oldWidget.selectedIndex) {
      return;
    }

    if (MediaQuery.disableAnimationsOf(context)) {
      _controller.value = 1;
    } else {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    assert(widget.selectedIndex >= 0 && widget.selectedIndex < widget.children.length);
    final sections = IndexedStack(index: widget.selectedIndex, children: widget.children);
    if (MediaQuery.disableAnimationsOf(context)) {
      return sections;
    }

    return FadeTransition(
      opacity: Tween<double>(begin: 0.45, end: 1).animate(_animation),
      child: SlideTransition(
        position: Tween<Offset>(begin: const Offset(0, 0.025), end: Offset.zero).animate(_animation),
        child: sections,
      ),
    );
  }
}
