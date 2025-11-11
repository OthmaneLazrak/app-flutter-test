import 'package:flutter/material.dart';
import 'package:flutter_application_test/screens/home.page.dart';
import 'package:flutter_application_test/screens/login.page.dart';
import 'package:flutter_application_test/screens/register.page.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      title: 'Flutter Application',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
        
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) =>  LoginPage(),
        '/home': (context) => const HomePage(),
        '/register': (context) => const RegisterPage(),
      },
    );
  }
}
