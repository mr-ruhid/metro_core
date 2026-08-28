// lib/core/settings_links.dart
import 'package:flutter/material.dart';

// Bütün səhifələrin səhifə widget-ları (import edilir)
import '../home/home.dart';
import '../apps/settings/settings.dart';
import '../apps/settings/system.dart';

class AppRoutes {
  // Əsas səhifələr
  static const String splash = '/';
  static const String welcome = '/welcome';
  static const String wifi = '/wifi';
  static const String update = '/update';
  static const String finish = '/finish';
  static const String home = '/home';

  // Settings hissəsi
  static const String settings = '/settings';
  static const String systemSettings = '/settings/system';

  // Səhifə widget-ları (const dəyişənlər)
  static const Widget homePage = HomeScreen();
  static const Widget settingsPage = SettingsPage();
  static const Widget systemSettingsPage = SystemSettingsPage();
}