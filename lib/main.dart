import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'utils/app_theme.dart';
import 'screens/splash_screen.dart';
import 'audio_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: AppColors.background,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  // Start music + load saved preference before the first frame
  await AudioService.instance.init();

  runApp(const TypeDropXApp());
}

class TypeDropXApp extends StatelessWidget {
  const TypeDropXApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TypeDrop X',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: const SplashScreen(),
    );
  }
}