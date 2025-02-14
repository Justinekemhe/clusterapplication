import 'package:clusterapplication/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth/login_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn =
      prefs.getBool('isLoggedIn') ?? false; // Use ?? to provide a default value
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Clustering',
    theme: ThemeData(
      primarySwatch: Colors.blue,
      hintColor: Colors.amberAccent,
      textTheme: GoogleFonts.ubuntuTextTheme(),
    ),
    home: isLoggedIn ? HomePage(0) : LoginPage(),
  ));
}
