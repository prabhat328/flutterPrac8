import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:prac8/screens/splash_screen.dart';
import 'package:prac8/services/theme_service.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ThemeService(),
      builder: (context, _) {
        final themeService = Provider.of<ThemeService>(context);
        return MaterialApp(
          title: 'Todo App',
          debugShowCheckedModeBanner: false,
          themeMode:
              themeService.isDarkModeOn ? ThemeMode.dark : ThemeMode.light,
          theme: ThemeData(
            primarySwatch: Colors.teal,
            brightness: Brightness.light,
            appBarTheme: const AppBarTheme(
              elevation: 0,
            ),
          ),
          darkTheme: ThemeData(
            primarySwatch: Colors.teal,
            brightness: Brightness.dark,
            appBarTheme: const AppBarTheme(
              elevation: 0,
            ),
          ),
          home: const SplashScreen(),
        );
      },
    );
  }
}
