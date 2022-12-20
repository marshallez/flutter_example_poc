import 'package:flutter/material.dart';

class LoadScreenPage extends StatefulWidget {
  const LoadScreenPage({super.key});

  @override
  _LoadScreenPageState createState() => _LoadScreenPageState();
}

class _LoadScreenPageState extends State<LoadScreenPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Loading page example!'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [CircularProgressIndicator()],
        ),
      ),
    );
  }
}
