import 'apple_health_clinical_records_platform_interface.dart';

enum ClinicalType {
  allergy,
  condition,
  coverage,
  immunization,
  labResult,
  medication,
  procedure,
  vitalSign
}

extension ClinicalTypeX on ClinicalType {
  String get name {
    switch (this) {

      case ClinicalType.allergy:
        return 'allergy';
      case ClinicalType.condition:
        return 'condition';
      case ClinicalType.coverage:
        return 'coverage';
      case ClinicalType.immunization:
        return 'immunization';
      case ClinicalType.labResult:
        return 'labResult';
      case ClinicalType.medication:
        return 'medication';
      case ClinicalType.procedure:
        return 'procedure';
      case ClinicalType.vitalSign:
        return 'vitalSign';
    }
  }
}

class AppleHealthClinicalRecords {
  Future<bool?> checkIfHealthDataAvailable() {
    return AppleHealthClinicalRecordsPlatform.instance
        .checkIfHealthDataAvailable();
  }

  Future<bool?> requestAuthorization(ClinicalType sampleType) {
    return AppleHealthClinicalRecordsPlatform.instance.requestAuthorization(sampleType.name);
  }

  Future<dynamic> getData(ClinicalType sampleType) {
    return AppleHealthClinicalRecordsPlatform.instance.getData(sampleType.name);
  }
}
