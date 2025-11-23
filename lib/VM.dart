import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:weather/Models/Coordinates.dart';
import 'package:weather/Models/ForecastEntry.dart';


class VM extends ChangeNotifier {
  int vmCounter = 0;
  List<ForecastEntry> _forecast = [];
  Timer? _forecastTimer;
  List<String> _favorites = [];

  List<ForecastEntry> get forecasts => _forecast;
  List<String> get favorites => _favorites;

  void increment() {
    vmCounter++;
    notifyListeners(); // tells the UI to update
  }

  void addFavorite(String favorite){
    _favorites.add(favorite);
    notifyListeners();
  }

  Future<void> startForecastUpdates(String placeName) async {
    await fetchForecast(placeName);

    _forecastTimer?.cancel();

    _forecastTimer = Timer.periodic(const Duration(hours:1), (_) async {
      try{
        await fetchForecast(placeName);
      }catch(e){
        print('Could not update forecasts! $e');
      }
    });
  }

  @override
  void dispose() {
    _forecastTimer?.cancel();
    super.dispose();
  }

  Future<void> fetchForecast(String placeName) async{
    Coordinates coordinates = await fetchCoordinates(placeName);
    final list = await fetchHourlyForecast(coordinates.lon, coordinates.lat);
    _forecast = list;
    notifyListeners();
  }

  Future<Coordinates> fetchCoordinates(String placeName) async {

    //Sigfridstorp
    final response = await http.get(
      Uri.parse('https://maceo.sth.kth.se/weather/search?location=$placeName'),
    );

    if(response.statusCode == 200) {

      final List<dynamic> data =  jsonDecode(response.body) as List<dynamic>;

      if(data.isEmpty) throw Exception('No data found!');

      return Coordinates.fromJson(data[0] as Map<String, dynamic>);
    }else{
      throw Exception('Failed to load coordinates');
    }
  }

  Future<List<ForecastEntry>> fetchHourlyForecast(double lon, double lat) async {
    final response = await http.get(
      Uri.parse(
        'https://maceo.sth.kth.se/weather/forecast?lonLat=lon/$lon/lat/$lat',
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

    // TEMP Debug prints so you see what you get
    print('ALL entries with parameters: ${allEntries.length}');
    if (allEntries.isNotEmpty) {
      print('first entry: ${allEntries.first.time}');
      print('last entry : ${allEntries.last.time}');
    }

    return allEntries;

    /*
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
    */
  }

}