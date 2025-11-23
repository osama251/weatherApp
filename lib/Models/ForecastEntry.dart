class ForecastEntry {
  final DateTime time;
  final double temperature;

  // 1	Clear sky
  // 2	Nearly clear sky
  // 3	Variable cloudiness
  // 4	Halfclear sky
  // 5	Cloudy sky
  // 6	Overcast
  // 7	Fog
  // 8	Light rain showers
  // 9	Moderate rain showers
  // 10	Heavy rain showers
  // 11	Thunderstorm
  // 12	Light sleet showers
  // 13	Moderate sleet showers
  // 14	Heavy sleet showers
  // 15	Light snow showers
  // 16	Moderate snow showers
  // 17	Heavy snow showers
  // 18	Light rain
  // 19	Moderate rain
  // 20	Heavy rain
  // 21	Thunder
  // 22	Light sleet
  // 23	Moderate sleet
  // 24	Heavy sleet
  // 25	Light snowfall
  // 26	Moderate snowfall
  // 27	Heavy snowfall
  final int weatherSymbol;

  ForecastEntry({
    required this.time,
    required this.temperature,
    required this.weatherSymbol,
  });

  // Nice helper to turn Wsymb2 into text
  String get weatherDescription {
    switch (weatherSymbol) {
      case 1:
        return 'lib/Icons/sun.png';
      case 2:
        return 'lib/Icons/cloudsun.png';
      case 3:
        return 'lib/Icons/cloudsun.png';
      case 4:
        return 'lib/Icons/cloudsun.png';
      case 5:
        return 'lib/Icons/cloud.png';
      case 6:
        return 'lib/Icons/cloud.png';
      case 7:
        return 'lib/Icons/windcloudsun.png';
      case 8:
        return 'lib/Icons/rain.png';
      case 18:
        return 'lib/Icons/rainsun.png';
      case 19:
      case 20:
        return 'lib/Icons/rain.png';
      case 25:
        return 'lib/Icons/snowsun.png';
      case 26:
      case 27:
        return 'lib/Icons/snow.png';
      default:
        return 'lib/Icons/unknown.png';
    }
  }

  factory ForecastEntry.fromJson(Map<String, dynamic> json) {
    final params =
    (json['parameters'] as List).cast<Map<String, dynamic>>();

    T getParamValue<T>(String name) {
      final p = params.firstWhere((e) => e['name'] == name);
      return (p['values'] as List).first as T;
    }

    final temp = (getParamValue<num>('t')).toDouble();
    final wsymb2 = (getParamValue<num>('Wsymb2')).toInt();

    return ForecastEntry(
      // convert to local time (optional but nice for UI)
      time: DateTime.parse(json['validTime'] as String).toLocal(),
      temperature: temp,
      weatherSymbol: wsymb2,
    );
  }

}