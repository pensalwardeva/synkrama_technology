import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:synkrama_technology/view/dashboard.dart';
import 'package:synkrama_technology/view/sign_in.dart';
import 'package:synkrama_technology/view/sign_up.dart';
import 'controller/auth_controller.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthController()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => MyLogin(), // Ensure the widget name is correct
        '/signup': (context) =>  Signup (), // Ensure the widget name is correct
        '/dashboard': (context) => Dashboard(), // Ensure the widget name is correct
      },
    );
  }
}
