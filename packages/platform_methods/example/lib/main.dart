import 'package:flutter/material.dart';
import 'package:platform_methods/platform_methods.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? id;
  String? smsSignature;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Platform Methods')),
        body: SafeArea(
          minimum: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 16,
            children: [
              if (id != null) SelectableText('ID: $id'),
              if (smsSignature != null)
                SelectableText('SMS Signature: $smsSignature'),
              ElevatedButton(
                onPressed: () {
                  PlatformMethods.instance.vibrate(duration: 1000);
                },
                child: Text('Vibrate'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final String? getID = await PlatformMethods.instance
                      .getDeviceId();
                  setState(() {
                    id = getID;
                  });
                },
                child: Text('Get ID'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final String? signature =
                      await PlatformMethods.instance.getAppSignature;
                  setState(() {
                    smsSignature = signature;
                  });
                },
                child: Text('SMS Signature'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
