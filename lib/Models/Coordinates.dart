class Coordinates{
  final double lon;
  final double lat;

  const Coordinates({required this.lon, required this.lat});

  factory Coordinates.fromJson(Map<String, dynamic> json){
    return switch(json){
      {'lon':double lon, 'lat':double lat} => Coordinates(
        lon: lon,
        lat: lat
      ),
      _ => throw const FormatException('Failed to load coordinates.'),
    };
  }
}