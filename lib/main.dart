import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_midi_command/flutter_midi_command.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark,
      ),
      home: Scaffold(
        appBar: AppBar(title: Text("Katana FX")),
        body: Home()
      )
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var _value = 50;
  StreamSubscription<String> _setupSubscription;
  MidiCommand _midiCommand = MidiCommand();
  List<MidiDevice> devices = List<MidiDevice>();
  Random random = Random();
  @override
  void initState() {
    super.initState();

    _midiCommand.startScanningForBluetoothDevices().catchError((err) {
      print("Error $err");
    });
    _setupSubscription = _midiCommand.onMidiSetupChanged.listen((data) async {
      print("setup changed $data");
      switch (data) {
        case "deviceFound":
          var devs = await _midiCommand.devices;
          setState(()  {
            devices = devs;
          });
          break;
        case "deviceOpened":
          break;
        default:
          print("Unhandled setup change: $data");
          break;
      }
    });
    _midiCommand.onMidiDataReceived.listen((data) {
      print(data);
    });
  }
  @override
  void dispose() {
    _setupSubscription.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: 200,
          child: ListView.builder(
            itemCount: devices.length,
            itemBuilder: (context, idx) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(child: Text(devices[idx].name), onTap: () {
                  _midiCommand.connectToDevice(devices[idx]);
                },),
              );
            },
          ),
        ),
        RaisedButton(
          child: Text("PC1"),
          onPressed: () {
            var program = random.nextInt(7);
            _midiCommand.sendData(Uint8List.fromList([0x80, 0x80, 0xC0, program]));
          },
        )
      ],
    );
  }
}
