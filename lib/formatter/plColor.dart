import 'package:flutter/material.dart';

class PLColorFormatter {
  static Color getColor(double number, BuildContext context) {

    var brightness = Theme.of(context).brightness;
    if (number < 0 && brightness == Brightness.light) {
      return const Color.fromARGB(255, 139, 0, 0);
    }

    if (number >= 0 && brightness == Brightness.light) {
      return const Color.fromARGB(255, 0, 139, 0);
    }

    if (number < 0 && brightness == Brightness.dark) {
      return Colors.red;
    }

    if (number >= 0 && brightness == Brightness.dark) {
      return Colors.green;
    }

    return Theme.of(context).colorScheme.primary;
  }
}