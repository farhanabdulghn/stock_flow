// ignore_for_file: avoid_print

import 'dart:io';

/// Jalankan dengan:
/// dart lib/tools/generate_routes.dart
///
/// Akan membuat file otomatis:
/// lib/app_routes.dart
///
/// Tambahkan anotasi @AutoRoute() di atas class yang ingin didaftarkan:
///
/// @AutoRoute()
/// class OnboardingScreen extends StatelessWidget { ... }

void main() {
  final libDir = Directory('lib');
  if (!libDir.existsSync()) {
    print('❌ Folder lib tidak ditemukan');
    return;
  }

  final dartFiles = libDir
      .listSync(recursive: true)
      .where((f) => f.path.endsWith('.dart'))
      .toList();

  final screenClasses = <String, String>{}; // {className: importPath}
  final classRegex = RegExp(r'@AutoRoute\(\)\s*class\s+(\w+)');

  for (final file in dartFiles) {
    if (file.path.endsWith('app_routes.dart')) continue;

    final content = File(file.path).readAsStringSync();

    for (final match in classRegex.allMatches(content)) {
      final className = match.group(1)!;
      final importPath = file.path
          .replaceAll('\\', '/')
          .replaceFirst('lib/', '')
          .replaceAll('//', '/');
      screenClasses[className] = importPath;
    }
  }

  if (screenClasses.isEmpty) {
    print('⚠️ Tidak ditemukan anotasi @AutoRoute');
    return;
  }

  final buffer = StringBuffer();
  buffer.writeln('// GENERATED FILE - DO NOT MODIFY BY HAND');
  buffer.writeln('// Run with: dart lib/tools/generate_routes.dart');
  buffer.writeln('');
  buffer.writeln("import 'package:flutter/material.dart';");

  // Import semua file screen
  for (final importPath in screenClasses.values) {
    buffer.writeln("import 'package:untitled/$importPath';");
  }

  buffer.writeln('');
  buffer.writeln('// ignore_for_file: constant_identifier_names');
  buffer.writeln('');

  // 🔹 Enumless routes (langsung property static)
  buffer.writeln('class AppRoute {');
  for (final className in screenClasses.keys) {
    final routeName = _toEnumName(className);
    final routePath = '/${_toKebab(routeName)}';
    buffer.writeln("  static const String $routeName = '$routePath';");
  }
  buffer.writeln('}\n');

  // 🔹 Map untuk MaterialApp
  buffer.writeln('class AppRoutes {');
  buffer.writeln('  static final Map<String, WidgetBuilder> routes = {');
  for (final className in screenClasses.keys) {
    final routeName = _toEnumName(className);
    buffer.writeln("    AppRoute.$routeName: (context) => const $className(),");
  }
  buffer.writeln('  };');
  buffer.writeln('}\n');

  // 💾 Simpan ke file
  File('lib/app_routes.dart').writeAsStringSync(buffer.toString());

  print(
    '✅ Berhasil generate ${screenClasses.length} route(s) ke lib/app_routes.dart',
  );
}

String _toEnumName(String className) {
  final base = className.replaceAll(RegExp(r'(Screen|Page|Section)$'), '');
  return base[0].toLowerCase() + base.substring(1);
}

/// Konversi camelCase atau PascalCase menjadi kebab-case
/// Contoh:
/// - onboarding → onboarding
/// - registerBirth → register-birth
/// - RegisterBirth → register-birth
/// - SuperVIPPage → super-vip
String _toKebab(String input) {
  return input
      .replaceAllMapped(
        RegExp(r'(?<=[a-z0-9])(?=[A-Z])'), // sisipkan '-' antara lower→Upper
        (m) => '-',
      )
      .toLowerCase();
}
