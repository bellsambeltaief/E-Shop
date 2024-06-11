import 'package:e_shop/providers/p_products.dart';
import 'package:e_shop/widgets/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      appId: '1:786668023689:android:3ec0fe95de6385d7787b58',
      apiKey: 'AIzaSyDlf9tOT63ooga_enyCDYc3QRJWKypJZi8',
      projectId: 'e-shop-7a2f1',
      messagingSenderId: '8439247517659643284',
      storageBucket: "e-shop-7a2f1.appspot.com",
    ),
  );
  runApp(
    ChangeNotifierProvider(
      create: (context) => PProducts(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E-Shop',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
        ),
        useMaterial3: true,
      ),
      home: const Home(),
    );
  }
}
