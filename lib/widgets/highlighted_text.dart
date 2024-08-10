import 'package:flutter/material.dart';

class HighlightedText extends StatelessWidget {
  final String text;
  final String highlight;
  final TextStyle style;
  final TextStyle highlightStyle;

  HighlightedText({
    required this.text,
    required this.highlight,
    required this.style,
    required this.highlightStyle,
  });

  @override
  Widget build(BuildContext context) {
    if (highlight.isEmpty) {
      return Text(text, style: style);
    }
    List<InlineSpan> spans = [];
    int start = 0;
    int indexOfHighlight = text.indexOf(highlight, start);
    while (indexOfHighlight >= 0) {
      if (indexOfHighlight > start) {
        spans.add(TextSpan(
          text: text.substring(start, indexOfHighlight),
          style: style,
        ));
      }
      spans.add(TextSpan(
        text: text.substring(indexOfHighlight, indexOfHighlight + highlight.length),
        style: highlightStyle,
      ));
      start = indexOfHighlight + highlight.length;
      indexOfHighlight = text.indexOf(highlight, start);
    }
    if (start < text.length) {
      spans.add(TextSpan(
        text: text.substring(start),
        style: style,
      ));
    }
    return RichText(
      text: TextSpan(children: spans),
    );
  }
}
