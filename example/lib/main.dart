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


  Future<void> initPlatformState() async {

    try {


      // First we check if Apple Health is available or not
      final available =
          await _appleHealthClinicalRecordsPlugin.checkIfHealthDataAvailable() ?? false;

      debugPrint(available ? 'available' : 'not available');

      if (available) {

        // Then check the authorization status of required clinical types

        final futures = ClinicalType.values.map((type) => _appleHealthClinicalRecordsPlugin.hasAuthorization(type));

        final statuses = await Future.wait(futures);

        var authStatus = false;

        if (statuses.any((element) => element != true)) {
          // Some or more clinical types are not authorized

          var types = [
            ClinicalType.allergy
          ];

          authStatus = await _appleHealthClinicalRecordsPlugin.requestAuthorization(ClinicalType.values) ?? false;

        }

        debugPrint(authStatus.toString());

        if (authStatus) {

          final records = ClinicalType.values.map((type ) => _appleHealthClinicalRecordsPlugin.getData(type));

          final data = await Future.wait(records);

          debugPrint(data.toString());
        }
      }

    } on PlatformException catch(err) {
      debugPrint(err.toString());
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
