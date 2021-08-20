import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyFont {
  Widget tileCenter(String string) {
    return Center(
      child: Text(
        string,
        style: TextStyle(
          fontSize: 24.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }



  TextStyle white35 = GoogleFonts.prompt(
    textStyle: TextStyle(
      color: Colors.white,
      fontSize: 35.0,
      fontWeight: FontWeight.bold,
    ),
  );

  TextStyle white18 = GoogleFonts.prompt(
    textStyle: TextStyle(
      color: Colors.white,
      fontSize: 18.0
    ),
  );

  TextStyle white16 = GoogleFonts.prompt(
    textStyle: TextStyle(
      color: Colors.white,
      fontSize: 16.0
    ),
  );

  TextStyle white16Bold = GoogleFonts.prompt(
    textStyle: TextStyle(
      color: Colors.white,
      fontSize: 16.0,
      fontWeight: FontWeight.bold,
    ),
  );

  TextStyle white12 = GoogleFonts.prompt(
    textStyle: TextStyle(
      color: Colors.white,
      fontSize: 12.0,
      
    ),
  );
  
  TextStyle white = GoogleFonts.prompt(
    textStyle: TextStyle(
      color: Colors.white,
      
    ),
  );

  TextStyle grey = GoogleFonts.prompt(
    textStyle: TextStyle(
      color: Colors.grey,
      
    ),
  );

  TextStyle grey16 = GoogleFonts.prompt(
    textStyle: TextStyle(
      color: Colors.grey,
      fontSize: 16.0,
      
    ),
  );

  TextStyle black16 = GoogleFonts.prompt(
    textStyle: TextStyle(
      color: Colors.black,
      fontSize: 16.0
    ),
  );

  TextStyle black16Bold = GoogleFonts.prompt(
    textStyle: TextStyle(
      color: Colors.black,
      fontSize: 16.0,
      fontWeight: FontWeight.bold,
    ),
  );

  
}