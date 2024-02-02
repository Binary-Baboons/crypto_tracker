import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectedBrightness = StateProvider<Brightness>((ref) {
  return Brightness.light;
});
