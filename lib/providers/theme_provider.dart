import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThemeProvider extends StateNotifier<bool> {
  ThemeProvider() : super(false);

  void toggle() {
    state = !state;
  }
}

final darkModeProvider = StateNotifierProvider<ThemeProvider, bool>(
  (ref) => ThemeProvider(),
);

final buttonIconProvider = Provider<IconData>((ref) {
  final isDarkMode = ref.watch(darkModeProvider);
  return isDarkMode ? Icons.wb_sunny : Icons.brightness_3;
});