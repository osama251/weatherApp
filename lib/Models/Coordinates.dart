class Coordinates {
  final double lon;
  final double lat;

  const Coordinates({required this.lon, required this.lat});

  factory Coordinates.fromJson(Map<String, dynamic> json) {
    final lonRaw = json['lon'];
    final latRaw = json['lat'];

    if (lonRaw is String && latRaw is String) {
      return Coordinates(
        lon: double.parse(lonRaw),
        lat: double.parse(latRaw),
      );
    }

    throw const FormatException('Failed to load coordinates.');
  }
}