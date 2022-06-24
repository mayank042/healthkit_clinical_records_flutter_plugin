import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:apple_health_clinical_records/apple_health_clinical_records.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _appleHealthClinicalRecordsPlugin = AppleHealthClinicalRecords();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    bool status;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      status =
          await _appleHealthClinicalRecordsPlugin.checkIfHealthDataAvailable() ?? false;

      debugPrint(status ? 'available' : 'not available');


      if (status) {
        final authStatus = await _appleHealthClinicalRecordsPlugin.requestAuthorization(ClinicalType.allergy) ?? false;

        debugPrint(authStatus.toString());

        if (authStatus) {
          final data = await _appleHealthClinicalRecordsPlugin.getData(ClinicalType.allergy);

          debugPrint(data.toString());
        }
      }

    } on PlatformException {
      status = false;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text('Running on:'),
        ),
      ),
    );
  }
}
