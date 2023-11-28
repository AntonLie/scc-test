import 'package:flutter/material.dart';

class MouseRegionSpan extends WidgetSpan {
  MouseRegionSpan({
    MouseCursor? mouseCursor,
    required InlineSpan inlineSpan,
  }) : super(
          child: MouseRegion(
            cursor: mouseCursor ?? SystemMouseCursors.click,
            child: Text.rich(
              inlineSpan,
            ),
          ),
        );
}
