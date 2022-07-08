import 'dart:io';

import 'apple_health_clinical_records_platform_interface.dart';

/// Types of supported clinical records
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

/// Extension on [ClinicalType] to get string representation
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

/// Class to be instantiated to use the plugin methods
class AppleHealthClinicalRecords {

  /// Call to instance method [checkIfHealthDataAvailable]
  Future<bool?> checkIfHealthDataAvailable() {

    /// Android platform is not supported
    if (Platform.isAndroid) {
      return Future.value(false);
    }

    return AppleHealthClinicalRecordsPlatform.instance
        .checkIfHealthDataAvailable();
  }

  /// Call to instance method [requestAuthorization]
  Future<bool?> requestAuthorization(List<ClinicalType> types) {

    List<String> typesToRead = [];

    /// Converting [types] to their string representation
    for (var type in types) {
      typesToRead.add(type.name);
    }

    return AppleHealthClinicalRecordsPlatform.instance.requestAuthorization(typesToRead);
  }

  /// Call to instance method [hasAuthorization]
  Future<bool?> hasAuthorization(ClinicalType type) {
    return AppleHealthClinicalRecordsPlatform.instance.hasAuthorization(type.name);
  }

  /// Call to instatnce method [getData]
  Future<dynamic> getData(ClinicalType sampleType) {
    return AppleHealthClinicalRecordsPlatform.instance.getData(sampleType.name);
  }
}
