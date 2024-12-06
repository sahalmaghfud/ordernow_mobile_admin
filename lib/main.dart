import 'package:flutter/material.dart';
import 'package:ordernow/screens/histories_screen.dart';
import 'package:ordernow/screens/pesanan_screen.dart';
import 'package:ordernow/screens/menu_screen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Order Now',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => MenuScreen(),
        '/pesanan': (context) => PesananScreen(),
        '/histories': (context) => HistoriesScreen(),
      },
    );
  }
}
