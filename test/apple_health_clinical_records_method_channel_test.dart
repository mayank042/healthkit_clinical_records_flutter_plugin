import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:apple_health_clinical_records/apple_health_clinical_records_method_channel.dart';

void main() {
  MethodChannelAppleHealthClinicalRecords platform = MethodChannelAppleHealthClinicalRecords();
  const MethodChannel channel = MethodChannel('apple_health_clinical_records');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.checkIfHealthDataAvailable(), '42');
  });
}
