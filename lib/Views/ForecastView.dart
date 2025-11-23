import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather/VM.dart';
import 'package:weather/Models/ForecastEntry.dart';

class Forecastview extends StatelessWidget {
  const Forecastview({super.key, required this.placeName});
  final String placeName;
  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<VM>(context, listen: false);
    final forecast = vm.forecasts;

    if (forecast.isEmpty) {
      return const Text('No forecast entries');
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: forecast.length,
      itemBuilder: (context, index) {

        final f = forecast[index];
        final dateStr =
            '${f.time.year}-${f.time.month.toString().padLeft(2, '0')}-${f.time.day.toString().padLeft(2, '0')}';
        final timeStr =
            '${f.time.hour.toString().padLeft(2, '0')}:00';

        return ListTile(
          leading: Image.asset(
            f.weatherDescription,
            width: 40,
            height: 40,
          ),
          title: Text('$dateStr  $timeStr'),
          subtitle: Text(
              '${f.temperature.toStringAsFixed(1)} °C'),
        );
      },
    );
  }
}
