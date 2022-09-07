import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:rustenburg/globals.dart' as global;

/// App Colors Class - Resource class for storing app level color constants
class AppColors {
  Color hexToColor(String code) {
    Color color = code != null ? new Color(int.parse(code.trim().substring(1, 7), radix: 16) + 0xFF000000) : Colors.white;
    return color;
  }
  static Color PRIMARY_COLOR = global.brand_color_primary_action!=null? HexColor(global.brand_color_primary_action) : Color(0xffDE626C);
//  static const Color PRIMARY_COLOR_LIGHT = Color(0xFFDE626C);
//  static const Color PRIMARY_COLOR_DARK = Color(0xFFDE626C);
//  static const Color ACCENT_COLOR = Color(0xFFDE626C);
}