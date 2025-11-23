import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather/VM.dart';
import 'package:weather/Views/CoordinatesView.dart';
import 'package:weather/Views/FavoriteView.dart';
import 'package:weather/Views/ForecastView.dart';
import 'package:weather/Views/SecondView.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});
  @override
  State<HomeView> createState() => _MyHomePageState();
}


class _MyHomePageState extends State<HomeView> {
  String? _placeName;

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<VM>(context);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // if (vm.vmCounter > 3) const Coordinatesview(),
                const SizedBox(height: 16),
                const Text(
                  "Hello from HomeView!",
                  style: TextStyle(fontSize: 24),
                  textDirection: TextDirection.rtl,
                ),
                const SizedBox(height: 16),
                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter area name',
                  ),
                  textInputAction: TextInputAction.done,
                  onSubmitted: (value) async {
                    setState(() {
                      _placeName = value.trim();
                    });
                    await vm.startForecastUpdates(value.trim());
                    //Forecastview(placeName:value);
                  },
                ),

                if (_placeName != null && _placeName!.isNotEmpty)
                  Forecastview(placeName: _placeName!),

                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const FavoriteView()),
                    );
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
                  child: const Text("Favorites"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}