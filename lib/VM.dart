import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather/Models/Coordinates.dart';
import 'package:weather/Models/ForecastEntry.dart';


class VM extends ChangeNotifier {
  int vmCounter = 0;
  List<ForecastEntry> _forecast = [];
  Timer? _forecastTimer;
  List<String> _favorites = [];
  String _placeName = "";
  double _updateValue = 1;
  Color _color = Color.fromARGB(255, 255, 255, 255);
  Color _textColor = Color.fromARGB(255, 0, 0, 0);

  List<ForecastEntry> get forecasts => _forecast;
  List<String> get favorites => _favorites;
  String get placeName => _placeName;
  double get updateValue => _updateValue;
  Color get color => _color;
  Color get textColor => _textColor;

  set placeName(String value) {
    _placeName = value;
    notifyListeners();
  }

  set updateValue(double value){
    _updateValue = value;
    notifyListeners();
  }

  set color(Color value){
    _color = value;
    notifyListeners();
  }

  set textColor(Color value){
    _textColor = value;
    notifyListeners();
  }

  Future<void> init() async {
    await loadFavorites();
    print("Loaded favorites: $_favorites");
  }

  void increment() {
    vmCounter++;
    notifyListeners();
  }

  void addFavorite(String favorite){
    _favorites.add(favorite);
    saveFavorites();
    notifyListeners();
  }

  Future<void> saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('favorites', _favorites);
  }

  Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    _favorites = prefs.getStringList('favorites') ?? [];
    notifyListeners();
  }

  Future<void> startForecastUpdates() async {
    await fetchForecast(placeName);

    _forecastTimer?.cancel();

    _forecastTimer = Timer.periodic(Duration(hours:_updateValue.ceil()), (_) async {
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
    final url = Uri.parse(
      'https://geocode.maps.co/search'
          '?q=${Uri.encodeComponent(placeName)}'
          '&api_key=69241deb61ed3331456023vend752de',
    );

    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception('Failed to search location: ${response.statusCode}');
    }

    final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;

    if (data.isEmpty) {
      throw Exception('No results found for "$placeName"');
    }

    final first = data.first as Map<String, dynamic>;
    final coords = Coordinates.fromJson(first);

    return coords;
  }

  Future<List<ForecastEntry>> fetchHourlyForecast(double lon, double lat) async {
    final response = await http.get(
      Uri.parse(
        'https://api.open-meteo.com/v1/forecast'
            '?latitude=$lat&longitude=$lon'
            '&hourly=temperature_2m,weather_code'
            '&timezone=auto',
      ),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to load forecast');
    }

    final Map<String, dynamic> root =
    jsonDecode(response.body) as Map<String, dynamic>;

    final hourly = root['hourly'] as Map<String, dynamic>;
    final List<dynamic> times = hourly['time'] as List<dynamic>;
    final List<dynamic> temps = hourly['temperature_2m'] as List<dynamic>;
    final List<dynamic> codes = hourly['weather_code'] as List<dynamic>;

    final int len = [
      times.length,
      temps.length,
      codes.length,
    ].reduce((a, b) => a < b ? a : b);

    final List<ForecastEntry> entries = [];

    for (int i = 0; i < len; i++) {
      final map = <String, dynamic>{
        'time': times[i] as String,
        'temperature_2m': temps[i] as num,
        'weather_code': codes[i] as num,
      };

      entries.add(ForecastEntry.fromJson(map));
    }

    return entries;
  }

}