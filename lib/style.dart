import 'package:flutter/material.dart';

var theme = ThemeData(
  appBarTheme: AppBarTheme(
      color: Colors.white,
      elevation: 1 ,
      actionsIconTheme: IconThemeData(
          color: Colors.black,
          size: 25
      ),
      titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 25
      )
  ),

  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    selectedItemColor: Colors.black
  ),


  textTheme: TextTheme(
    titleLarge: TextStyle(
      fontWeight: FontWeight.bold
    )
  )
);

