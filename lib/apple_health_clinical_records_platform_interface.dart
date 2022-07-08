import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'apple_health_clinical_records_method_channel.dart';

/// A representation of plugin methods.
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

  /// Performs the check if apple health is available on device
  Future<bool?> checkIfHealthDataAvailable() {
    throw UnimplementedError('checkIfHealthDataAvailable() has not been implemented.');
  }

  /// Request read only permission to [types]
  Future<bool?> requestAuthorization(List<String> types) {
    throw UnimplementedError('requestAuthorization() has not been implemented.');
  }

  /// Check if [type] already has read permission
  Future<bool?> hasAuthorization(String type) {
    throw UnimplementedError('hasAuthorization() has not been implemented.');
  }

  /// Get clinical records of [sampleType]
  Future<dynamic> getData(String sampleType) {
    throw UnimplementedError('getData() has not been implemented.');
  }
}
