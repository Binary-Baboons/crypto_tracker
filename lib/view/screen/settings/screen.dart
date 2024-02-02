import 'package:crypto_tracker/provider/general.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.primary),
        onPressed: () {
          var brightness = ref.watch(selectedBrightness);
          if (brightness == Brightness.light) {
            ref.watch(selectedBrightness.notifier).state = Brightness.dark;
          } else {
            ref.watch(selectedBrightness.notifier).state = Brightness.light;
          }
        },
        child: Text(
      "Click me!",
      style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
    ));
  }
}

