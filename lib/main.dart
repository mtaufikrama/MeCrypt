import 'package:flutter/material.dart';
import 'package:mecrypt/service.dart';
import 'package:mecrypt/splash_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => MoneyAssets(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Crypto Currency",
        home: const SplashScreen(),
      ),
    ),
  );
}
