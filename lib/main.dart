import 'package:flutter/material.dart';
import 'package:localin/presentation/login_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Localin App',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          canvasColor: Colors.white,
          fontFamily: 'OpenSans',
          textTheme: ThemeData.light().textTheme.copyWith(
              body1:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
              body2: TextStyle(color: Colors.black87),
              title: TextStyle(fontSize: 24.0, fontFamily: 'OpenSans'))),
      initialRoute: '/',
      routes: {
        '/': (_) => LoginPage(),
      },
    );
  }
}
