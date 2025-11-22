
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather/VM.dart';
import 'package:weather/Models/Coordinates.dart';


class Coordinatesview extends StatefulWidget {
  const Coordinatesview({super.key});
  @override
  State<Coordinatesview> createState() => _CoordinatesState();
}

class _CoordinatesState extends State<Coordinatesview>{
  late Future<Coordinates> futureCoordinates;

  @override
  void initState(){
    super.initState();
    final vm = Provider.of<VM>(context, listen:false);
    futureCoordinates = vm.fetchCoordinates();
  }

  @override
  Widget build(BuildContext context){
    return Column(
        children: <Widget>[
          FutureBuilder<Coordinates>(
            future: futureCoordinates,
            builder: (context, snapshot) {
              if(snapshot.hasData){
                return Text('Lon: ${snapshot.data!.lon}, Lat: ${snapshot.data!.lat}');
              } else if(snapshot.hasError){
                return Text('${snapshot.error}');
              }
              return const CircularProgressIndicator();
            }
          ),
        ]
    );
  }


}

