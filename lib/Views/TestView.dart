import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather/VM.dart';
import 'package:weather/Views/CoordinatesView.dart';
import 'package:weather/Views/ForecastView.dart';
import 'package:weather/Views/SecondView.dart';

class TestView extends StatefulWidget {
  const TestView({super.key});
  @override
  State<TestView> createState() => _MyTestPageState();
}


class _MyTestPageState extends State<TestView> {
  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<VM>(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            
            if(vm.vmCounter > 3) const Coordinatesview(),
            if(vm.vmCounter > 6) const Forecastview(),
            const Text("Hello from HomeView!", style: TextStyle(fontSize: 24), textDirection: TextDirection.rtl),
            ElevatedButton(
              onPressed: () => vm.increment(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigoAccent,
                padding: EdgeInsets.symmetric(horizontal:50, vertical:20),
                textStyle: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
                elevation: 20,
              ),
              child: const Text("I am button"),
            ),
            Text("The counter is: ${vm.vmCounter}"),
          ],
        ),
      ),
    );
  }
}