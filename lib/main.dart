import 'package:flutter/material.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:recipes/routes/home_page.dart';

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
      theme: FlexColorScheme.light(
              colors: FlexColor.schemes[FlexScheme.hippieBlue]!.light)
          .toTheme
          .copyWith(backgroundColor: Colors.grey.shade300),
      home: const HomePage(),
    );
  }
}
