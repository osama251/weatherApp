import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather/VM.dart';
import 'package:weather/Models/ForecastEntry.dart';


class Forecastview extends StatefulWidget {
  const Forecastview({super.key});
  @override
  State<Forecastview> createState() => _ForecastState();
}

class _ForecastState extends State<Forecastview>{
  late Future<List<ForecastEntry>> futureForecast;

  @override
  void initState(){
    super.initState();
    final vm = Provider.of<VM>(context, listen:false);
    futureForecast = vm.fetchHourlyForecast();
  }

  @override
  Widget build(BuildContext context){
    return Column(
        children: <Widget>[
          FutureBuilder<List<ForecastEntry>>(
            future: futureForecast,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final hours = snapshot.data!;
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: hours.length,
                  itemBuilder: (context, index) {
                    final f = hours[index];
                    final dateStr =
                        '${f.time.year}-${f.time.month.toString().padLeft(2, '0')}-${f.time.day.toString().padLeft(2, '0')}';
                    final timeStr =
                        '${f.time.hour.toString().padLeft(2, '0')}:00';

                    return ListTile(
                      title: Text('$dateStr  $timeStr'),
                      subtitle: Text('${f.temperature.toStringAsFixed(1)} °C • ${f.weatherDescription}'),
                    );
                  },
                );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              return const CircularProgressIndicator();
            },
          ),
        ]
    );
  }


}