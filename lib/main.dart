import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mecrypt/service.dart';
import 'package:mecrypt/splash_screen.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => MoneyAssets(),
        ),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "MeCrypt",
        home: SplashScreen(),
      ),
    ),
  );
}
