import 'package:flutter/material.dart';
import 'package:recipes/routes/home_page.dart';
import 'package:recipes/utils/them.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Recipes',
      theme: AplicationTheme.getTheme()
          .copyWith(backgroundColor: Colors.grey.shade200),
      home: const HomePage(),
    );
  }
}
