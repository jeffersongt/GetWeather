import 'package:flutter/material.dart';
import 'package:getweather/theme/style.dart';
import 'package:getweather/screens/home/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GetWeather',
      theme: appTheme(),
      home: const GetWeather(
        title: 'GetWeather',
      ),
    );
  }
}
