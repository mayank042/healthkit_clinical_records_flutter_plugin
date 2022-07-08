# Apple Health Clinical Records

Enables reading clinical records from Apple health.

|             | iOS   |
|-------------|-------|
| **Support** | 12.0+ |


This plugin supports:

- Checking if Apple health is available using the `checkIfHealthDataAvailable` method.
- handling permissions to access clinical records using the `hasAuthorization`, `requestAuthorization` methods.
- reding clinical records using the `getData` method.

## Data types

| **Data Type** | **FHIR resource**   | **Comments**       |
|---------------|---------------------|--------------------|
| condition     | Condition           |                    |
| allergy       | AllergyIntolerance  |                    |
| coverage      |                     | Required iOS 14.0+ |
| immunization  | Immunization        |                    |
| labResult     | Observation         |                    |
| medication    | MedicationOrder     |                    |
| procedure     | Procedure           |                    |
| vitalSign     | Observation         |                    |


## Setup

First, add `apple_health_clinical_records` as a [dependency in your pubspec.yaml file](https://flutter.dev/using-packages/).

### iOS

Step 1: Append the Info.plist with the following entry

```
<key>NSHealthClinicalHealthRecordsShareUsageDescription</key>
<string>Your clinical records usage description</string>
```

Step 2: Enable "HealthKit" inside the "Capabilities" tab.

Step 3: Enable "Clinical Health Records" capability for "HealthKit".

![Clinical Health Records in HealthKit](https://drive.google.com/file/d/1hCxf_b2-SLefuwdfQb5MN3Ojs6-AKUZd/view?usp=sharing)

## Usage

See the example app for detailed examples of how to use the Clinical records API.

The Clinical records plugin is used via the `AppleHealthClinicalRecords` class using the different methods for handling permissions and getting 
records from apple health.

```dart

// Create an instance of AppleHealthClinicalRecords
AppleHealthClinicalRecords clinicalRecords = AppleHealthClinicalRecords();

// Check if apple health is available
bool available =
    await clinicalRecords.checkIfHealthDataAvailable() ?? false;

// define the types to get
var types = [
  ClinicalType.allergy
];

// check if permission is given for defined types
final futures = types.map((type) => clinicalRecords.hasAuthorization(type));

final authorizations = await Future.wait(futures);

if (authorizations.every((element) => true)) {
  
  getClinicalData(types);
  
} else {
  
  // request authorizations
  bool authorized = await clinicalRecords.requestAuthorization(types) ?? false;
  
  if (authorized) {
    getClinicalData(types);
  }
  
}

void getClinicalData(List<ClinicalType> types) async {
  final records = types.map((type ) => clinicalRecords.getData(type));

  final data = await Future.wait(records);
}

```

### Clincal record

A clinical record contains list of FHIR resources, of listed data types (see above).

see [FHIR resources list](http://hl7.org/fhir/resourcelist.html)

### References

Inspired by [Health plugin](https://pub.dev/packages/health).

http://hl7.org/fhir/resourcelist.html

https://developer.apple.com/documentation/healthkit/samples/accessing_health_records

https://developer.apple.com/documentation/healthkit/samples/accessing_a_user_s_clinical_records

