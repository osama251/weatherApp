import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather/VM.dart';
import 'package:weather/Views/HomeView.dart';

class FavoriteView extends StatefulWidget{
  const FavoriteView({super.key});
  @override
  State<FavoriteView> createState() => _FavoriteState();
}

class _FavoriteState extends State<FavoriteView>{

  @override
  Widget build(BuildContext context){
    final vm = Provider.of<VM>(context);
    final favorites = vm.favorites;
    return Scaffold(
      appBar: AppBar(title: const Text("Favorites")),
      body: SafeArea(child: SingleChildScrollView(
        child:Center(
          child:Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Add favorite',
                  ),
                  textInputAction: TextInputAction.done,
                  onSubmitted: (value) {
                    setState(() {
                      vm.addFavorite(value.trim());
                    });
                  },
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: favorites.length,
                  itemBuilder: (context, index) {
                    return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                        child: ElevatedButton(
                          onPressed: () async => {
                            setState(() {
                              vm.placeName = favorites[index].trim();
                            }),
                            await vm.startForecastUpdates(),
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const HomeView()),
                            )
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
                            shape: RoundedRectangleBorder(),
                          ),
                          child: Text(favorites[index]),
                        )
                    );
                  },
                ),
            ]
          )
        )
      ))
    );
  }
}