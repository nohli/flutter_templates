import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';

// Expanded labels can span two backgrounds. Sample their painted text runs,
// so empty space cannot be mistaken for the foreground color
class PaintedTextContrastGuideline extends AccessibilityGuideline {
  const PaintedTextContrastGuideline(this.finder);

  final Finder finder;

  @override
  String get description => 'Painted text must meet the WCAG text contrast thresholds';

  @override
  Future<Evaluation> evaluate(WidgetTester tester) async {
    final elements = finder.evaluate().toList();
    if (elements.isEmpty) return const Evaluation.fail('No text was checked');
    var result = const Evaluation.pass();
    for (final view in tester.binding.renderViews) {
      final image = await tester.runAsync(
        () => (view.debugLayer! as OffsetLayer).toImage(
          view.paintBounds,
          pixelRatio: 1 / view.flutterView.devicePixelRatio,
        ),
      );
      if (image == null) return const Evaluation.fail('The painted frame was unavailable');
      try {
        final bytes = await tester.runAsync(() => image.toByteData());
        if (bytes == null) return const Evaluation.fail('The painted pixels were unavailable');
        for (final element in elements) {
          if (View.of(element) != view.flutterView) continue;
          final paragraph = element.renderObject! as RenderParagraph;
          final text = element.widget as Text;
          final defaults = DefaultTextStyle.of(element).style;
          final style = text.style == null || text.style!.inherit ? defaults.merge(text.style) : text.style!;
          final target = const MinimumTextContrastGuideline().targetContrastRatio(
            style.fontSize,
            bold: style.fontWeight == FontWeight.bold,
          );
          final runs = paragraph.getBoxesForSelection(
            TextSelection(baseOffset: 0, extentOffset: paragraph.text.toPlainText().length),
          );
          if (runs.isEmpty) return Evaluation.fail('No glyphs were painted for ${text.data}');
          for (final run in runs) {
            final inkBounds = MatrixUtils.transformRect(
              paragraph.getTransformTo(null),
              Rect.fromLTRB(run.left, run.top, run.right, run.bottom),
            );
            final bounds = MatrixUtils.transformRect(
              paragraph.getTransformTo(null),
              Rect.fromLTRB(run.left, run.top, run.right, run.bottom).inflate(4),
            );
            final histogram = <int, int>{};
            final ink = <int>{};
            for (var y = math.max(0, bounds.top.floor()); y < math.min(image.height, bounds.bottom.ceil()); y++) {
              for (var x = math.max(0, bounds.left.floor()); x < math.min(image.width, bounds.right.ceil()); x++) {
                final offset = (y * image.width + x) * 4;
                final rgb =
                    (bytes.getUint8(offset) << 16) | (bytes.getUint8(offset + 1) << 8) | bytes.getUint8(offset + 2);
                histogram.update(rgb, (count) => count + 1, ifAbsent: () => 1);
                if (inkBounds.contains(Offset(x + .5, y + .5))) ink.add(rgb);
              }
            }
            if (histogram.isEmpty) return Evaluation.fail('No visible pixels for ${text.data}');
            final samples = [
              for (final entry in histogram.entries) (color: Color(0xFF000000 | entry.key), count: entry.value),
            ];
            final count = samples.fold(0, (total, sample) => total + sample.count);
            final mean =
                samples.fold(
                  0.0,
                  (total, sample) => total + HSLColor.fromColor(sample.color).lightness * sample.count,
                ) /
                count;
            Color? light;
            Color? dark;
            var lightCount = 0;
            var darkCount = 0;
            for (final sample in samples) {
              if (HSLColor.fromColor(sample.color).lightness > mean) {
                if (sample.count > lightCount) {
                  light = sample.color;
                  lightCount = sample.count;
                }
              } else if (sample.count > darkCount) {
                dark = sample.color;
                darkCount = sample.count;
              }
            }
            final foreground = style.foreground?.color ?? style.color;
            if (foreground != null && ink.isNotEmpty) {
              // Frequency can select an antialiasing shade instead of the text paint
              final painted = ink.map((rgb) => Color(0xFF000000 | rgb)).reduce((first, second) {
                return _distance(first, foreground) <= _distance(second, foreground) ? first : second;
              });
              if (HSLColor.fromColor(foreground).lightness > mean) {
                light = painted;
              } else {
                dark = painted;
              }
            }
            final first = (light ?? dark!).computeLuminance();
            final second = (dark ?? light!).computeLuminance();
            final ratio = (math.max(first, second) + 0.05) / (math.min(first, second) + 0.05);
            if (ratio < target - 0.01) {
              result += Evaluation.fail('${text.data}: painted contrast ${ratio.toStringAsFixed(2)} is below $target');
            }
          }
        }
      } finally {
        image.dispose();
      }
    }
    return result;
  }

  double _distance(Color first, Color second) =>
      (first.r - second.r).abs() + (first.g - second.g).abs() + (first.b - second.b).abs();
}
