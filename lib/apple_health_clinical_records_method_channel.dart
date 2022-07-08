import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'apple_health_clinical_records_platform_interface.dart';

/// An implementation of [AppleHealthClinicalRecordsPlatform] that uses method channels.
class MethodChannelAppleHealthClinicalRecords extends AppleHealthClinicalRecordsPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('apple_health_clinical_records');

  @override
  Future<bool?> checkIfHealthDataAvailable() async {
    final status = await methodChannel.invokeMethod<dynamic>('checkIfHealthDataAvailable');
    return status;
  }

  @override
  Future<bool?> hasAuthorization(String type) async {
    final status = await methodChannel.invokeMethod<dynamic>('hasAuthorization', { 'type': type });
    return status;
  }

  @override
  Future<bool?> requestAuthorization(List<String> types) async {
    final status = await methodChannel.invokeMethod<dynamic>('requestAuthorization', { 'types': types });
    return status;
  }

  @override
  Future<dynamic> getData(String sampleType) async {
    final data = await methodChannel.invokeMethod<dynamic>('getData', { 'sampleType': sampleType });
    return data;
  }
}
