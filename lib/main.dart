import 'package:flutter/material.dart';
import 'package:unitconverter/category_screen.dart';

void main() => runApp(UnitConverterApp());

class UnitConverterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: CategoryScreen(),
      theme: ThemeData(
        fontFamily: 'Raleway',
      ),
    );
  }
}
