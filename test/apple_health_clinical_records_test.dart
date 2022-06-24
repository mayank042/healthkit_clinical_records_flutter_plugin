import 'package:flutter_test/flutter_test.dart';
import 'package:apple_health_clinical_records/apple_health_clinical_records.dart';
import 'package:apple_health_clinical_records/apple_health_clinical_records_platform_interface.dart';
import 'package:apple_health_clinical_records/apple_health_clinical_records_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockAppleHealthClinicalRecordsPlatform
    with MockPlatformInterfaceMixin
    implements AppleHealthClinicalRecordsPlatform {

  @override
  Future<bool?> checkIfHealthDataAvailable() => Future.value(true);

  @override
  Future<bool?> requestAuthorization(String sampleType) {
    throw UnimplementedError();
  }

  @override
  Future getData(String sampleType) {
    throw UnimplementedError();
  }
}

void main() {
  final AppleHealthClinicalRecordsPlatform initialPlatform = AppleHealthClinicalRecordsPlatform.instance;

  test('$MethodChannelAppleHealthClinicalRecords is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelAppleHealthClinicalRecords>());
  });

  test('getPlatformVersion', () async {
    AppleHealthClinicalRecords appleHealthClinicalRecordsPlugin = AppleHealthClinicalRecords();
    MockAppleHealthClinicalRecordsPlatform fakePlatform = MockAppleHealthClinicalRecordsPlatform();
    AppleHealthClinicalRecordsPlatform.instance = fakePlatform;

    expect(await appleHealthClinicalRecordsPlugin.checkIfHealthDataAvailable(), '42');
  });
}
