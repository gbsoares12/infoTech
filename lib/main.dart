import 'package:flutter/material.dart';
import 'package:infoTech/features/apresentation/home_screen.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(primaryColor: Colors.indigo),
    home: HomeScreen(),
    title: "InfoTech",
  ));
}
