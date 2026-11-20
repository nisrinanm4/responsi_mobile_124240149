import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'services/auth_service.dart';
import 'services/notification_service.dart';
import 'views/character_view.dart';
import 'views/login_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Inisialisasi Hive & Buka Box Favorite Spells
  await Hive.initFlutter();
  await Hive.openBox('favorite_spells');

  // 2. Inisialisasi Notification Service (Immediate Notification)
  await NotificationService.init();

  // 3. Cek Status Login dari SharedPreferences
  final bool isLoggedIn = await AuthService.isLoggedIn();

  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Harry Potter App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'sans-serif',
        // scaffoldBackgroundColor: Colors.white,  <- DIHAPUS agar background lavender
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true, // <- DIUBAH dari false agar Card, FAB, tombol tonal sesuai screenshot
      ),
      home: isLoggedIn ? const CharacterView() : const LoginView(),
    );
  }
}