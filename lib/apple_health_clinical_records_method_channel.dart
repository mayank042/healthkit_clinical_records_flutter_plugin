import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'apple_health_clinical_records_platform_interface.dart';

/// An implementation of [AppleHealthClinicalRecordsPlatform] that uses method channels.
class MethodChannelAppleHealthClinicalRecords
    extends AppleHealthClinicalRecordsPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('apple_health_clinical_records');

  /// implementation of [checkIfHealthDataAvailable]
  @override
  Future<bool?> checkIfHealthDataAvailable() async {
    final status =
        await methodChannel.invokeMethod<dynamic>('checkIfHealthDataAvailable');
    return status;
  }

  /// implementation of [hasAuthorization]
  @override
  Future<bool?> hasAuthorization(String type) async {
    final status = await methodChannel
        .invokeMethod<dynamic>('hasAuthorization', {'type': type});
    return status;
  }

  /// implementation of [requestAuthorization]
  @override
  Future<bool?> requestAuthorization(List<String> types) async {
    final status = await methodChannel
        .invokeMethod<dynamic>('requestAuthorization', {'types': types});
    return status;
  }

  /// implementation of [getData]
  @override
  Future<dynamic> getData(String sampleType) async {
    final data = await methodChannel
        .invokeMethod<dynamic>('getData', {'sampleType': sampleType});
    return data;
  }
}
