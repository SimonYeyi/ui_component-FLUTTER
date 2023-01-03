import 'package:flutter/material.dart';

class LineDivider extends StatelessWidget {
  final Axis direction;
  final double? space;
  final double? thickness;
  final double? indent;
  final double? startIndent;
  final double? endIndent;
  final Color? color;
  final bool dash;

  const LineDivider({
    Key? key,
    this.direction = Axis.horizontal,
    this.space = 0,
    this.thickness = 0.5,
    this.indent,
    this.startIndent,
    this.endIndent,
    this.color = const Color(0xFFE7E7E7),
    this.dash = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget widget;
    if (dash) {
      widget = DashLineDivider();
    } else {
      widget = Divider(
          height: space,
          thickness: thickness,
          indent: startIndent ?? indent,
          endIndent: endIndent ?? indent,
          color: color);
      if (direction == Axis.vertical) {
        widget = RotatedBox(quarterTurns: 1, child: widget);
      }
    }
    return widget;
  }

  Widget DashLineDivider() {
    return LayoutBuilder(builder: (context, constraints) {
      final constrainSize = direction == Axis.horizontal
          ? constraints.constrainWidth()
          : constraints.constrainHeight();

      assert(constrainSize != double.infinity && constrainSize != double.nan,
          "unknown size");

      const dashSize = 4.0;

      final startIndent = this.startIndent ?? this.indent ?? 0;
      final endIndent = this.endIndent ?? this.indent ?? 0;
      final indent = startIndent + endIndent;

      final dashCount = ((constrainSize - indent) / (dashSize * 1.25)).floor();

      final dashWidth = direction == Axis.horizontal ? dashSize : thickness;
      final dashHeight = direction == Axis.horizontal ? thickness : dashSize;

      final space = this.space ?? 0;
      final double paddingStart =
          direction == Axis.horizontal ? startIndent : space / 2;
      final double paddingTop =
          direction == Axis.horizontal ? space / 2 : startIndent;
      final double paddingEnd =
          direction == Axis.horizontal ? endIndent : space / 2;
      final double paddingBottom =
          direction == Axis.horizontal ? space / 2 : endIndent;

      return Container(
        padding: EdgeInsetsDirectional.only(
            start: paddingStart,
            top: paddingTop,
            end: paddingEnd,
            bottom: paddingBottom),
        child: Flex(
          direction: direction,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            dashCount,
            (index) => SizedBox(
              width: dashWidth,
              height: dashHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(color: color),
              ),
            ),
          ),
        ),
      );
    });
  }
}

class TextDivider extends StatelessWidget {
  final String text;
  final double? textSize;
  final double? textIndent;
  final double? height;
  final double? lineThickness;
  final double? indent;
  final Color color;
  final bool dash;

  const TextDivider({
    Key? key,
    required this.text,
    this.textSize = 13,
    this.textIndent = 30,
    this.height,
    this.lineThickness = 1,
    this.indent,
    this.color = const Color(0xFFE7E7E7),
    this.dash = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (lineThickness != 0)
            Expanded(
              child: LineDivider(
                thickness: lineThickness,
                startIndent: indent,
                endIndent: textIndent,
                color: color,
                dash: dash,
              ),
            ),
          Text(
            text,
            style: TextStyle(color: color, fontSize: textSize),
          ),
          if (lineThickness != 0)
            Expanded(
              child: LineDivider(
                thickness: lineThickness,
                startIndent: textIndent,
                endIndent: indent,
                color: color,
                dash: dash,
              ),
            ),
        ],
      ),
    );
  }
}

class SpaceDivider extends StatelessWidget {
  final Axis direction;
  final double space;

  const SpaceDivider(this.space, {Key? key, Axis? direction})
      : direction = direction ?? Axis.horizontal,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    if (direction == Axis.horizontal) {
      return SizedBox(height: space);
    } else {
      return SizedBox(width: space);
    }
  }
}
