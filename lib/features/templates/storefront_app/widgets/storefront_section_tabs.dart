import 'package:flutter/material.dart';

import '../models/storefront_section.dart';

class StorefrontSectionTabs extends StatelessWidget {
  const StorefrontSectionTabs({
    required this.selectedSection,
    required this.bagItemCount,
    required this.onSelected,
    super.key,
  });

  final StorefrontSection selectedSection;
  final int bagItemCount;
  final ValueChanged<StorefrontSection> onSelected;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: colors.outlineVariant),
          bottom: BorderSide(color: colors.outlineVariant),
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: <Widget>[
            for (final section in StorefrontSection.values)
              _SectionTab(
                section: section,
                label: _labelFor(section),
                count: section == StorefrontSection.bag ? bagItemCount : 0,
                isSelected: selectedSection == section,
                onPressed: () => onSelected(section),
              ),
          ],
        ),
      ),
    );
  }

  String _labelFor(StorefrontSection section) => switch (section) {
    StorefrontSection.shop => 'Collection',
    StorefrontSection.saved => 'Saved',
    StorefrontSection.bag => 'Bag',
  };
}

class _SectionTab extends StatelessWidget {
  const _SectionTab({
    required this.section,
    required this.label,
    required this.count,
    required this.isSelected,
    required this.onPressed,
  });

  final StorefrontSection section;
  final String label;
  final int count;
  final bool isSelected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Semantics(
      selected: isSelected,
      button: true,
      child: InkWell(
        borderRadius: const BorderRadius.all(Radius.circular(2)),
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 0),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    _numberFor(section),
                    style: TextStyle(
                      color: isSelected ? colors.primary : colors.onSurfaceVariant,
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.7,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    label,
                    style: TextStyle(
                      color: isSelected ? colors.onSurface : colors.onSurfaceVariant,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                  if (count > 0) ...<Widget>[const SizedBox(width: 6), Badge(label: Text('$count'))],
                ],
              ),
              const SizedBox(height: 10),
              AnimatedContainer(
                duration: MediaQuery.disableAnimationsOf(context) ? Duration.zero : const Duration(milliseconds: 220),
                width: isSelected ? 58 : 0,
                height: 4,
                decoration: BoxDecoration(
                  color: colors.primary,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(1)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _numberFor(StorefrontSection section) => switch (section) {
    StorefrontSection.shop => '01',
    StorefrontSection.saved => '02',
    StorefrontSection.bag => '03',
  };
}
