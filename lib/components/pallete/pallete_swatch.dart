import 'dart:math' as math;

import 'package:flutter/material.dart';

const Color _kBackgroundColor = Color(0xffa0a0a0);
const Color _kSelectionRectangleBackground = Color(0x15000000);
const Color _kSelectionRectangleBorder = Color(0x80000000);
const Color _kPlaceholderColor = Color(0x80404040);

/// A small square of color with an optional label.
@immutable
class PaletteSwatch extends StatelessWidget {
  /// Creates a PaletteSwatch.
  ///
  /// If the [color] argument is omitted, then the swatch will show a
  /// placeholder instead, to indicate that there is no color.
  const PaletteSwatch({
    Key key,
    this.color,
    this.label,
  }) : super(key: key);

  /// The color of the swatch. May be null.
  final Color color;

  /// The optional label to display next to the swatch.
  final String label;

  @override
  Widget build(BuildContext context) {
    // Compute the "distance" of the color swatch and the background color
    // so that we can put a border around those color swatches that are too
    // close to the background's saturation and lightness. We ignore hue for
    // the comparison.
    final HSLColor hslColor = HSLColor.fromColor(color ?? Colors.transparent);
    final HSLColor backgroundAsHsl = HSLColor.fromColor(_kBackgroundColor);
    final double colorDistance = math.sqrt(
        math.pow(hslColor.saturation - backgroundAsHsl.saturation, 2.0) +
            math.pow(hslColor.lightness - backgroundAsHsl.lightness, 2.0));

    Widget swatch = Padding(
      padding: const EdgeInsets.all(2.0),
      child: color == null
          ? const Placeholder(
              fallbackWidth: 34.0,
              fallbackHeight: 20.0,
              color: Color(0xff404040),
              strokeWidth: 2.0,
            )
          : Container(
              decoration: BoxDecoration(
                  color: color,
                  border: Border.all(
                    width: 1.0,
                    color: _kPlaceholderColor,
                    style: colorDistance < 0.2
                        ? BorderStyle.solid
                        : BorderStyle.none,
                  )),
              width: 34.0,
              height: 20.0,
            ),
    );

    if (label != null) {
      swatch = ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 130.0, minWidth: 130.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            swatch,
            Container(width: 5.0),
            Text(label),
          ],
        ),
      );
    }
    return swatch;
  }
}
