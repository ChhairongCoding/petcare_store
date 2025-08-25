import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    textTheme: const TextTheme(
      titleLarge: TextStyle(fontSize: 20, fontFamily: 'Poppins', fontWeight: FontWeight.w700 ),
      titleMedium: TextStyle(fontSize: 18, fontFamily: 'Poppins', fontWeight: FontWeight.w600 ),
      titleSmall: TextStyle(fontSize: 16, fontFamily: 'Poppins', fontWeight: FontWeight.w500 ),
      bodyLarge: TextStyle(fontSize: 16, fontFamily: 'Poppins', fontWeight: FontWeight.w400),
      bodyMedium: TextStyle(fontSize: 14, fontFamily: 'Poppins', fontWeight: FontWeight.normal),
      bodySmall: TextStyle(fontSize: 12, fontFamily: 'Poppins', fontWeight: FontWeight.normal),
      
    ),
  );
}
