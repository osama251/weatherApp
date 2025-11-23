import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather/VM.dart';
import 'package:weather/Views/CoordinatesView.dart';
import 'package:weather/Views/FavoriteView.dart';
import 'package:weather/Views/ForecastView.dart';
import 'package:weather/Views/SecondView.dart';

class FavoriteView extends StatefulWidget{
  const FavoriteView({super.key});
  @override
  State<FavoriteView> createState() => _FavoriteState();
}

class _FavoriteState extends State<FavoriteView>{

  @override
  Widget build(BuildContext context){
    final vm = Provider.of<VM>(context);
    return Scaffold(
      appBar: AppBar(title: const Text("Favorites")),
      body: SafeArea(child: SingleChildScrollView(
        child:Center(
          child:Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
              ElevatedButton(
                onPressed: () => {
                  vm.addFavorite("Test")
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigoAccent,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 50, vertical: 20),
                  textStyle: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                  elevation: 20,
                ),
                child: const Text("Add Favorite"),
              ),
            ]
          )
        )
      ))
    );
  }
}