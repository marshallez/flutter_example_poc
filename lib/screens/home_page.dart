import 'package:flutter/material.dart';
import 'package:flutter_example_poc/screens/bluetooth_page.dart';
import 'package:flutter_example_poc/screens/load_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Widget> _widgetOptions = [];
  int _selectedIndex = 0;

  @override
  void initState() {
    _widgetOptions = [const BluetoothPage(), const LoadScreenPage()];

    super.initState();
  }

  List<BottomNavigationBarItem> navItems = [
    const BottomNavigationBarItem(
      icon: Icon(Icons.bluetooth),
      label: 'Example Bluetooth',
    ),
    // Threw an error with only one nav bar item
    // so I added an example load screen page just so there was at least 2 - should replace this with a real page
    const BottomNavigationBarItem(
      icon: Icon(Icons.settings),
      label: 'Example spinner',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(child: _widgetOptions.elementAt(_selectedIndex)),
        bottomNavigationBar: BottomNavigationBar(
          items: navItems,
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.blue,
          onTap: _onItemTapped,
        ));
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
