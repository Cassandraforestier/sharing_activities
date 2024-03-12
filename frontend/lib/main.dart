import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/features/authentication/screens/login_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  await dotenv.load();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Color(0xff23597d),
        brightness: Brightness.light,
        buttonTheme: ButtonThemeData(
          buttonColor: Color(0xff23597d),
          textTheme: ButtonTextTheme.primary,
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xff23597d),
            foregroundColor: Colors.white,
          ),
        ),
        iconTheme: IconThemeData(
          color: Color(0xff23597d),
        ),
        appBarTheme: AppBarTheme(
          color: Color(0xff23597d),
        ),
      ),
      home: LoginPage(),
    );
  }
}
