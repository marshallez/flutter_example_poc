import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_example_poc/utils/validator.dart';

class BluetoothPage extends StatefulWidget {
  const BluetoothPage({super.key});

  @override
  _BluetoothPageState createState() => _BluetoothPageState();
}

class _BluetoothPageState extends State<BluetoothPage> {
  final FlutterBluePlus flutterBlue = FlutterBluePlus.instance;
  final List<BluetoothDevice> devicesList = <BluetoothDevice>[];
  final Map<Guid, List<int>> readValues = <Guid, List<int>>{};
  final textController = TextEditingController();
  BluetoothDevice? connectedDevice;
  List<BluetoothService>? bluetoothServices;

  final _formKey = GlobalKey<FormState>();

  final _bluetoothMessageTextController = TextEditingController();
  final _focusBluetoothMessage = FocusNode();

  _showDeviceTolist(final BluetoothDevice device) {
    if (!devicesList.contains(device)) {
      if (mounted) {
        setState(() {
          devicesList.add(device);
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    flutterBlue.connectedDevices.asStream().listen((List<BluetoothDevice> devices) {
      for (BluetoothDevice device in devices) {
        _showDeviceTolist(device);
      }
    });
    flutterBlue.scanResults.listen((List<ScanResult> results) {
      for (ScanResult result in results) {
        _showDeviceTolist(result.device);
      }
    });
    flutterBlue.stopScan();
    flutterBlue.startScan();
  }

  @override
  void deactivate() {
    super.deactivate();
    flutterBlue.stopScan();
  }

  @override
  void dispose() {
    super.dispose();
    flutterBlue.stopScan();
  }

  ListView _buildListViewOfDevices() {
    List<Container> containers = <Container>[];
    for (BluetoothDevice device in devicesList) {
      if (device.name != '') {
        containers.add(
          Container(
            height: 50,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Text(device.name),
                      Text(device.id.toString()),
                    ],
                  ),
                ),
                ElevatedButton(
                  child: const Text(
                    'Connect',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    flutterBlue.stopScan();
                    try {
                      await device.connect();
                    } catch (e) {
                    } finally {
                      bluetoothServices = await device.discoverServices();
                    }
                    setState(() {
                      connectedDevice = device;
                    });
                  },
                ),
              ],
            ),
          ),
        );
      }
    }

    return ListView(
      padding: const EdgeInsets.all(8),
      children: <Widget>[
        ...containers,
      ],
    );
  }

  List<ButtonTheme> _buildReadWriteNotifyButton(BluetoothCharacteristic characteristic) {
    List<ButtonTheme> buttons = <ButtonTheme>[];
    if (characteristic.properties.write) {
      buttons.add(
        ButtonTheme(
          minWidth: 10,
          height: 20,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ElevatedButton(
              child: const Text('WRITE', style: TextStyle(color: Colors.white)),
              onPressed: () async {
                await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Write"),
                        content: Row(
                          children: <Widget>[
                            Expanded(
                              child: TextField(
                                controller: textController,
                              ),
                            ),
                          ],
                        ),
                        actions: <Widget>[
                          ElevatedButton(
                            child: const Text("Send"),
                            onPressed: () {
                              characteristic.write(utf8.encode(textController.value.text));
                              Navigator.pop(context);
                            },
                          ),
                          ElevatedButton(
                            child: const Text("Cancel"),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      );
                    });
              },
            ),
          ),
        ),
      );
    }
    return buttons;
  }

  Center _buildConnectDeviceView() {
    BluetoothCharacteristic? myCharacteristic;
    for (BluetoothService service in bluetoothServices!) {
      for (BluetoothCharacteristic characteristic in service.characteristics) {
        if (characteristic.properties.write) {
          myCharacteristic = characteristic;
        }
      }
    }

    return Center(
        child: Form(
            key: _formKey,
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                  margin: const EdgeInsets.only(left: 60, right: 60),
                  child: TextFormField(
                    controller: _bluetoothMessageTextController,
                    focusNode: _focusBluetoothMessage,
                    validator: (value) => Validator.validateBluetoothMessage(
                      msg: value,
                    ),
                    decoration: InputDecoration(
                      hintText: "Bluetooth Message",
                      errorBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(6.0),
                        borderSide: const BorderSide(
                          color: Colors.red,
                        ),
                      ),
                    ),
                  )),
              const SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    if (myCharacteristic != null) {
                      await myCharacteristic.write(utf8.encode(_bluetoothMessageTextController.text.trim()));
                    }
                  }
                },
                style: ElevatedButton.styleFrom(),
                child: const Text('Send message!'),
              ),
            ])));
  }

  Widget _buildView() {
    if (connectedDevice != null) {
      return _buildConnectDeviceView();
    }
    return _buildListViewOfDevices();
  }

  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Example Bluetooth!')), body: _buildView());
}
