import 'dart:math' as math;

import 'package:flutter/material.dart';

class IllustratedSupportLayout extends StatelessWidget {
  const IllustratedSupportLayout({
    required this.illustrationPath,
    required this.content,
    required this.action,
    super.key,
  });

  final String illustrationPath;
  final List<Widget> content;
  final Widget action;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final illustrationSize = math.min(600.0, math.max(0.0, constraints.maxWidth - 48));
        return CustomScrollView(
          slivers: <Widget>[
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
              sliver: SliverFillRemaining(
                hasScrollBody: false,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Center(
                          child: SizedBox.square(
                            dimension: illustrationSize,
                            child: Image.asset(illustrationPath, fit: BoxFit.contain, excludeFromSemantics: true),
                          ),
                        ),
                        ...content,
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 24, bottom: MediaQuery.paddingOf(context).bottom + 24),
                      child: action,
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
