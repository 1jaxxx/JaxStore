import 'package:flutter/material.dart';
import 'screens/home_page.dart';
import 'screens/login_page.dart';
import 'screens/register_page.dart';
import 'screens/splash_screen.dart';

// Tema Warna
const Color backgroundColor = Color(0xFFC1E8FF);
const Color navbarColor = Color(0xFF021024);
const Color appbarColor = Color(0xFF7DA0CA);

void main() {
  runApp(const MyApp());
}

// --- FUNGSI INI DIPERBARUI ---
// Sekarang menerima RouteSettings untuk membawa data argumen
Route _createAnimatedRoute({required Widget page, required String type, required RouteSettings settings}) {
  return PageRouteBuilder(
    // Meneruskan settings yang berisi argumen
    settings: settings,
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      if (type == 'fade') {
        return FadeTransition(opacity: animation, child: child);
      }
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.ease;
      final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jasa Joki ML',
      theme: ThemeData(
        scaffoldBackgroundColor: backgroundColor,
        appBarTheme: const AppBarTheme(
          backgroundColor: appbarColor,
          foregroundColor: Colors.white,
          elevation: 2,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: navbarColor,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white54,
          elevation: 8,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: appbarColor,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        textTheme: Theme.of(context).textTheme.apply(
              bodyColor: navbarColor,
              displayColor: navbarColor,
            ),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      onGenerateRoute: (settings) {
        // --- BAGIAN INI DIPERBARUI ---
        // 'settings' sekarang diteruskan ke setiap rute
        switch (settings.name) {
          case '/':
            return _createAnimatedRoute(page: const SplashScreen(), type: 'fade', settings: settings);
          case '/login':
            return _createAnimatedRoute(page: const LoginPage(), type: 'fade', settings: settings);
          case '/register':
            return _createAnimatedRoute(page: const RegisterPage(), type: 'slide', settings: settings);
          case '/home':
            return _createAnimatedRoute(page: const HomePage(), type: 'slide', settings: settings);
          default:
            return _createAnimatedRoute(page: const SplashScreen(), type: 'fade', settings: settings);
        }
      },
    );
  }
}