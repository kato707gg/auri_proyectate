import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LabelUtils {
  static Widget buildTextLabel(
      String text, double fontSize, FontWeight fontWeight) {
    return Text(
      text,
      style: GoogleFonts.quicksand(
        fontSize: fontSize,
        fontWeight: fontWeight,
      ),
    );
  }
}
