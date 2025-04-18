import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextHeading extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final String? fontName;

  const TextHeading({
    super.key,
    required this.text,
    this.style,
    this.fontName
  });

  @override
  Widget build(BuildContext context) {
    final baseStyle = Theme.of(context).textTheme.bodyMedium!;
    final mergedStyle = baseStyle.copyWith(
      color: const Color(0xFFEDC30D),
      fontSize: 18,
      fontWeight: FontWeight.bold,
    ).merge(style);

    var fontStyle = mergedStyle;

    // Check if the font name exists on Google Font
    if (fontName != null) {
      try {
        fontStyle = GoogleFonts.getFont(fontName!, textStyle: mergedStyle);
      } catch (e) {
        // Handle the case where the font is not found
        if (kDebugMode) {
          print('Font not found: $fontName');
        }
      }
    }

    return Text(text, style: fontStyle);
  }
}