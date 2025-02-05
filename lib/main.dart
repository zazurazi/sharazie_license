import 'package:flutter/material.dart';
import 'auth/main_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
//import "package:flutter_windowmanager/flutter_windowmanager.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  //await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainPage(),
    );
  }

  void checkAssetExists(String assetPath) async {
    try {
      await rootBundle.load(assetPath);
      print('✅ Asset found: $assetPath');
    } catch (e) {
      print('❌ Asset not found: $assetPath. Error: $e');
    }
  }
}
