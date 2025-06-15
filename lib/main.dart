import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/atm_provider.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(create: (_) => ATMProvider(), child: const ATMApp()),
  );
}

class ATMApp extends StatelessWidget {
  const ATMApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ATM Transaction App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.green),
      home: const LoginScreen(),
    );
  }
}
