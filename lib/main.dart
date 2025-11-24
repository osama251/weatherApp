import 'package:flutter/material.dart';
import 'package:weather/Models/Coordinates.dart';
import 'package:weather/Views/HomeView.dart';
import 'package:weather/VM.dart';
import 'package:provider/provider.dart';


void main() {

    runApp(
        ChangeNotifierProvider(
          create: (_) => VM()..init(),
          child: const MyApp(),

        ),
    );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<VM>(context);
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        scaffoldBackgroundColor: vm.color,

        textTheme: TextTheme(
          bodyLarge: TextStyle(color: vm.textColor),
          bodyMedium: TextStyle(color: vm.textColor),
          bodySmall: TextStyle(color: vm.textColor),

          titleLarge: TextStyle(color: vm.textColor),
          titleMedium: TextStyle(color: vm.textColor),
          titleSmall: TextStyle(color: vm.textColor),
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const HomeView(),
    );
  }
}

