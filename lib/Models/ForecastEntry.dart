class ForecastEntry {
  final DateTime time;
  final double temperature;
  final int weatherSymbol;

  ForecastEntry({
    required this.time,
    required this.temperature,
    required this.weatherSymbol,
  });

  factory ForecastEntry.fromJson(Map<String, dynamic> json) {
    final timeStr = json['time'] as String;
    final temp = (json['temperature_2m'] as num).toDouble();
    final code = (json['weather_code'] as num).toInt();

    return ForecastEntry(
      time: DateTime.parse(timeStr).toLocal(),
      temperature: temp,
      weatherSymbol: code,
    );
  }




  String get weatherDescription {
    switch (weatherSymbol) {
      case 0:
        return 'lib/Icons/sun.png';
      case 1:
      case 2:
        return 'lib/Icons/cloudsun.png';
      case 3:
        return 'lib/Icons/cloud.png';
      case 45:
      case 48:
        return 'lib/Icons/windcloudsun.png';
      case 51:
      case 61:
        return 'lib/Icons/rainsun.png';
      case 53:
      case 55:
      case 56:
      case 57:
      case 63:
      case 65:
      case 66:
      case 67:
      case 80:
      case 81:
      case 82:
        return 'lib/Icons/rain.png';
      case 71:
        return 'lib/Icons/snowsun.png';
      case 73:
      case 75:
      case 77:
      case 85:
      case 86:
        return 'lib/Icons/snow.png';
      case 95:
      case 96:
      case 99:
        return 'lib/Icons/lightning.png';
      default:
        return 'lib/Icons/unknown.png';
    }
  }

  /*factory ForecastEntry.fromJson(Map<String, dynamic> json) {
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
  }*/

}