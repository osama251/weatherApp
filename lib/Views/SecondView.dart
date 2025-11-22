import 'package:flutter/material.dart';

class SecondView extends StatefulWidget {
  const SecondView ({super.key});
  @override
  State<SecondView> createState() => _MySecondViewState();
}

class _MySecondViewState extends State<SecondView>{
  //final TextScaler? textScaler;

  @override
  Widget build(BuildContext context){
    return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text("I am second view", textScaler: TextScaler.linear(2),),

              ],
           );
  }
}