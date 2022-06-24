import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'apple_health_clinical_records_method_channel.dart';

abstract class AppleHealthClinicalRecordsPlatform extends PlatformInterface {
  /// Constructs a AppleHealthClinicalRecordsPlatform.
  AppleHealthClinicalRecordsPlatform() : super(token: _token);

  static final Object _token = Object();

  static AppleHealthClinicalRecordsPlatform _instance = MethodChannelAppleHealthClinicalRecords();

  /// The default instance of [AppleHealthClinicalRecordsPlatform] to use.
  ///
  /// Defaults to [MethodChannelAppleHealthClinicalRecords].
  static AppleHealthClinicalRecordsPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [AppleHealthClinicalRecordsPlatform] when
  /// they register themselves.
  static set instance(AppleHealthClinicalRecordsPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<bool?> checkIfHealthDataAvailable() {
    throw UnimplementedError('checkIfHealthDataAvailable() has not been implemented.');
  }

  Future<bool?> requestAuthorization(String sampleType) {
    throw UnimplementedError('requestAuthorization() has not been implemented.');
  }

  Future<dynamic> getData(String sampleType) {
    throw UnimplementedError('getData() has not been implemented.');
  }
}
