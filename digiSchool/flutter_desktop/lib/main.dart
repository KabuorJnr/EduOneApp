import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

import 'app_config.dart';
import 'app_shell.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  runApp(const DigiSchoolDesktopApp());

  windowManager.waitUntilReadyToShow(
    const WindowOptions(
      size: Size(1440, 900),
      minimumSize: Size(1180, 760),
      center: true,
      title: AppConfig.appName,
      backgroundColor: Color(0xFF07111F),
      skipTaskbar: false,
    ),
    () async {
      await windowManager.show();
      await windowManager.focus();
    },
  );
}

class DigiSchoolDesktopApp extends StatelessWidget {
  const DigiSchoolDesktopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppConfig.appName,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF34D399),
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF07111F),
        textTheme: Typography.whiteMountainView,
      ),
      home: const DesktopShell(),
    );
  }
}
