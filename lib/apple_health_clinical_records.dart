
import 'apple_health_clinical_records_platform_interface.dart';

class AppleHealthClinicalRecords {
  Future<bool?> checkIfHealthDataAvailable() {
    return AppleHealthClinicalRecordsPlatform.instance.checkIfHealthDataAvailable();
  }

  Future<bool?> requestAuthorization() {
    return AppleHealthClinicalRecordsPlatform.instance.requestAuthorization();
  }

  Future<dynamic> getData(String sampleType) {
    return AppleHealthClinicalRecordsPlatform.instance.getData(sampleType);
  }
}
