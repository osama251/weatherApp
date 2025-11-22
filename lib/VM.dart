import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:weather/Models/Coordinates.dart';
import 'package:weather/Models/ForecastEntry.dart';


class VM extends ChangeNotifier {
  int vmCounter = 0;

  void increment() {
    vmCounter++;
    notifyListeners(); // tells the UI to update
  }

  Future<Coordinates> fetchCoordinates() async {
    final response = await http.get(
      Uri.parse('https://maceo.sth.kth.se/weather/search?location=Sigfridstorp'),
    );

    if(response.statusCode == 200) {

      final List<dynamic> data =  jsonDecode(response.body) as List<dynamic>;

      if(data.isEmpty) throw Exception('No data found!');

      return Coordinates.fromJson(data[0] as Map<String, dynamic>);
    }else{
      throw Exception('Failed to load coordinates');
    }
  }

  Future<ForecastEntry> fetchFirstForecast() async {
    final response = await http.get(
      Uri.parse(
        'https://maceo.sth.kth.se/weather/forecast?lonLat=lon/14.333/lat/60.383',
      ),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to load forecast');
    }

    final Map<String, dynamic> root =
    jsonDecode(response.body) as Map<String, dynamic>;

    final List<dynamic> timeSeries = root['timeSeries'] as List<dynamic>;
    final Map<String, dynamic> first =
    timeSeries.first as Map<String, dynamic>;

    return ForecastEntry.fromJson(first);
  }

  Future<List<ForecastEntry>> fetchHourlyForecast() async {
    final response = await http.get(
      Uri.parse(
        'https://maceo.sth.kth.se/weather/forecast?lonLat=lon/14.333/lat/60.383',
      ),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to load forecast');
    }

    final Map<String, dynamic> root =
    jsonDecode(response.body) as Map<String, dynamic>;

    final List<dynamic> ts = root['timeSeries'] as List<dynamic>;

    // 1) Convert to ForecastEntry, skip entries with empty parameters
    final allEntries = ts
        .cast<Map<String, dynamic>>()
        .where((e) => (e['parameters'] as List).isNotEmpty)
        .map((e) => ForecastEntry.fromJson(e))
        .toList();

    // 2) Filter: from today (local) to 7 days ahead
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day);           // today 00:00
    final end = start.add(const Duration(days: 7));                  // 7 days ahead

    final filtered = allEntries.where((e) {
      final d = DateTime(e.time.year, e.time.month, e.time.day);
      return !d.isBefore(start) && !d.isAfter(end);
    }).toList();

    // 3) Sort by time just to be sure
    filtered.sort((a, b) => a.time.compareTo(b.time));

    return filtered;
  }

}