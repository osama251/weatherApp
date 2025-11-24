import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather/VM.dart';
import 'package:flutter_color_picker_wheel/flutter_color_picker_wheel.dart';
class SettingsView extends StatefulWidget{

  const SettingsView({super.key});
  @override
  State<SettingsView> createState() => _SettingsState();
}

class _SettingsState extends State<SettingsView>{

  @override
  Widget build(BuildContext context){
    final vm = Provider.of<VM>(context);

    return Scaffold(
        appBar: AppBar(title: const Text("Settings")),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children : <Widget>[
                const SizedBox(height:16),
                Slider(
                    value:vm.updateValue,
                    onChanged: (value) {
                      setState(() {
                        vm.updateValue = value;
                      });
                    },
                    min:1,
                    max:6,
                    divisions: 5,
                    label:'Update Interval: ${vm.updateValue}'
                ),
                const SizedBox(height:16),
                Text(
                  "Change background color:",
                  style: TextStyle(fontSize:20),
                ),
                WheelColorPicker(
                  onSelect: (Color newColor) {
                    setState(() {
                      vm.color = newColor;
                    });
                  },
                  defaultColor: Color.fromARGB(255, 0, 0, 0),
                  animationConfig: fanLikeAnimationConfig,
                  colorList: simpleColors,
                  buttonSize: 40,
                  pieceHeight: 25,
                  innerRadius: 80,
                ),
                const SizedBox(height:16),
                Text(
                  "Change Text color:",
                  style: TextStyle(fontSize:20),
                ),
                WheelColorPicker(
                  onSelect: (Color newColor) {
                    setState(() {
                      vm.textColor = newColor;
                    });
                  },
                  defaultColor: Color.fromARGB(255, 0, 0, 0),
                  animationConfig: fanLikeAnimationConfig,
                  colorList: simpleColors,
                  buttonSize: 40,
                  pieceHeight: 25,
                  innerRadius: 80,
                )
              ]
            )
          )
        )
      )
    );
  }
}