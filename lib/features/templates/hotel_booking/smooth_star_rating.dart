// The MIT License (MIT)

// Copyright (c) 2019 Thangrobul Infimate

// Permission is hereby granted, free of charge, to any person obtaining a copy of this
// software and associated documentation files (the "Software"), to deal in the Software
// without restriction, including without limitation the rights to use, copy, modify, merge,
// publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons
// to whom the Software is furnished to do so, subject to the following conditions:

// The above copyright notice and this permission notice shall be included in all copies or
// substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
// INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
// PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
// FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
// ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import 'package:flutter/material.dart';

typedef RatingChangeCallback = void Function(double rating);

class SmoothStarRating extends StatelessWidget {
  const SmoothStarRating({
    this.onRatingChanged,
    this.starCount = 5,
    this.spacing = 0.0,
    this.rating = 0.0,
    this.defaultIconData = Icons.star_border,
    this.color,
    this.borderColor,
    this.size = 25,
    this.filledIconData = Icons.star,
    this.halfFilledIconData = Icons.star_half,
    this.allowHalfRating = true,
    super.key,
  });

  final int starCount;
  final double rating;
  final RatingChangeCallback? onRatingChanged;
  final Color? color;
  final Color? borderColor;
  final double size;
  final bool allowHalfRating;
  final IconData filledIconData;
  final IconData halfFilledIconData;
  final IconData defaultIconData;
  final double spacing;

  Widget _buildStar(BuildContext context, int index) {
    final remainingRating = rating - index;
    Icon icon;
    if (remainingRating >= 1) {
      icon = Icon(filledIconData, color: color ?? Theme.of(context).colorScheme.secondary, size: size);
    } else if (allowHalfRating && remainingRating >= 0.5) {
      icon = Icon(halfFilledIconData, color: color ?? Theme.of(context).colorScheme.secondary, size: size);
    } else {
      icon = Icon(defaultIconData, color: borderColor ?? Theme.of(context).colorScheme.secondary, size: size);
    }

    return icon;
  }

  double _ratingForPosition(double position) {
    final itemWidth = size + spacing;
    final rawRating = position / itemWidth;
    final selectedRating = allowHalfRating ? (rawRating * 2).ceil() / 2 : rawRating.ceilToDouble();

    return selectedRating.clamp(0, starCount).toDouble();
  }

  double _steppedRating(double direction) {
    final increment = allowHalfRating ? 0.5 : 1.0;

    return (rating + increment * direction).clamp(0, starCount).toDouble();
  }

  String _formattedRating(double value) {
    final hasWholeRating = value == value.roundToDouble();

    return hasWholeRating ? value.round().toString() : value.toStringAsFixed(1);
  }

  @override
  Widget build(BuildContext context) {
    final stars = Wrap(
      spacing: spacing,
      children: List<Widget>.generate(starCount, (int index) => _buildStar(context, index)),
    );
    final callback = onRatingChanged;
    final isInteractive = callback != null;
    final ratingValue = '${_formattedRating(rating)} out of $starCount';
    final interactiveStars = ConstrainedBox(
      constraints: BoxConstraints(minHeight: isInteractive ? 48 : size),
      child: Align(alignment: Alignment.centerLeft, widthFactor: 1, heightFactor: 1, child: stars),
    );

    return Semantics(
      label: 'Rating',
      value: ratingValue,
      slider: isInteractive,
      readOnly: !isInteractive,
      increasedValue: isInteractive ? _formattedRating(_steppedRating(1)) : null,
      decreasedValue: isInteractive ? _formattedRating(_steppedRating(-1)) : null,
      onIncrease: isInteractive ? () => callback(_steppedRating(1)) : null,
      onDecrease: isInteractive ? () => callback(_steppedRating(-1)) : null,
      child: ExcludeSemantics(
        child: Material(
          color: Colors.transparent,
          child: callback == null
              ? interactiveStars
              : GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTapUp: (TapUpDetails details) => callback(_ratingForPosition(details.localPosition.dx)),
                  onHorizontalDragUpdate: (DragUpdateDetails details) =>
                      callback(_ratingForPosition(details.localPosition.dx)),
                  child: interactiveStars,
                ),
        ),
      ),
    );
  }
}
