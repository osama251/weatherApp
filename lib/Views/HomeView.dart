import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather/VM.dart';
import 'package:weather/Views/FavoriteView.dart';
import 'package:weather/Views/ForecastView.dart';
import 'package:weather/Views/SettingsView.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});
  @override
  State<HomeView> createState() => _MyHomePageState();
}


class _MyHomePageState extends State<HomeView> {


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

                const SizedBox(height: 16),
                Text(
                  vm.placeName,
                  style: const TextStyle(fontSize: 24),
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
                      vm.placeName = value.trim();
                    });
                    await vm.startForecastUpdates();

                  },
                ),

                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SettingsView()),
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
                  child: const Text("Settings"),
                ),
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

                if (vm.placeName.isNotEmpty)
                    Forecastview(placeName: vm.placeName),

              ],
            ),
          ),
        ),
      ),
    );
  }
}