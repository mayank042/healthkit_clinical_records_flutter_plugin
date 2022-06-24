import Flutter
import UIKit
import HealthKit

struct PluginError: Error {
    let message: String
}

@available(iOS 12.0, *)
enum Section {
    case healthRecords
    
    var displayName: String {
        switch self {
        case .healthRecords:
            return "Health Records"
        }
    }
    
    var types: [HKSampleType] {
        switch self {
        case .healthRecords:
            return [
                HKObjectType.clinicalType(forIdentifier: .allergyRecord)!,
                HKObjectType.clinicalType(forIdentifier: .vitalSignRecord)!,
                HKObjectType.clinicalType(forIdentifier: .conditionRecord)!,
                HKObjectType.clinicalType(forIdentifier: .immunizationRecord)!,
                HKObjectType.clinicalType(forIdentifier: .labResultRecord)!,
                HKObjectType.clinicalType(forIdentifier: .medicationRecord)!,
                HKObjectType.clinicalType(forIdentifier: .procedureRecord)!
            ]
            
        }
    }
}

@available(iOS 12.0, *)
public class SwiftAppleHealthClinicalRecordsPlugin: NSObject, FlutterPlugin {
    
    let healthStore = HKHealthStore()
    
    var sampleTypes: Set<HKSampleType> {
        return Set(Section.healthRecords.types)
    }
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "apple_health_clinical_records", binaryMessenger: registrar.messenger())
        let instance = SwiftAppleHealthClinicalRecordsPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        
        /// Handle checkIfHealthDataAvailable
        if (call.method.elementsEqual("checkIfHealthDataAvailable")){
            checkIfHealthDataAvailable(call: call, result: result)
        }
        /// Handle requestAuthorization
        else if (call.method.elementsEqual("requestAuthorization")){
            requestAuthorization(call: call, result: result)
        }
        
        /// Handle getData
        else if (call.method.elementsEqual("getData")){
            getData(call: call, result: result)
        }
        
    }
    
    func checkIfHealthDataAvailable(call: FlutterMethodCall, result: @escaping FlutterResult) {
        result(HKHealthStore.isHealthDataAvailable())
    }
    
    
    func requestAuthorization(call: FlutterMethodCall, result: @escaping FlutterResult) {
        
        if #available(iOS 13.0, *) {
            healthStore.requestAuthorization(toShare: Set(), read: sampleTypes) { (success, error) in
                DispatchQueue.main.async {
                    result(success)
                }
            }
        }
        else {
            result(false)// Handle the error here.
        }
    }
    
    
    func getData(call: FlutterMethodCall, result: @escaping FlutterResult) {
        let arguments = call.arguments as? NSDictionary
        let sampleTypeKey = (arguments?["sampleType"] as? String)!
        
        switch sampleTypeKey {
        case "allergy":
            queryForSamples(sampleType: HKObjectType.clinicalType(forIdentifier: .allergyRecord)!, result: result)
        case "condition":
            queryForSamples(sampleType: HKObjectType.clinicalType(forIdentifier: .conditionRecord)!, result: result)
        case "coverage":
            if #available(iOS 14.0, *) {
                queryForSamples(sampleType: HKObjectType.clinicalType(forIdentifier: .coverageRecord)!, result: result)
            } else {
                // Fallback on earlier versions
                result(nil)
            }
        case "immunization":
            queryForSamples(sampleType: HKObjectType.clinicalType(forIdentifier: .immunizationRecord)!, result: result)
            
        case "labResult":
            queryForSamples(sampleType: HKObjectType.clinicalType(forIdentifier: .labResultRecord)!, result: result)
            
        case "medication":
            queryForSamples(sampleType: HKObjectType.clinicalType(forIdentifier: .medicationRecord)!, result: result)
            
        case "procedure":
            queryForSamples(sampleType: HKObjectType.clinicalType(forIdentifier: .procedureRecord)!, result: result)
            
        case "vitalSign":
            queryForSamples(sampleType: HKObjectType.clinicalType(forIdentifier: .vitalSignRecord)!, result: result)
            
        default:
            result(nil)
        }
    }
    
    
    /// Use HKSampleQuery to query the HealthKit store for samples by type.
    func queryForSamples(sampleType: HKSampleType, result: @escaping FlutterResult) {
        let sortDescriptors = [NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)]
        let query = HKSampleQuery(sampleType: sampleType, predicate: nil, limit: 100, sortDescriptors: sortDescriptors) {(_, samplesOrNil, error) in
            DispatchQueue.main.async {
                guard let samples = samplesOrNil else {
                    print("error in querying records")
                    return
                }
                
                let records = samples as? [HKClinicalRecord]
            
                
                let dictionaries = records.map { sample -> NSDictionary in
                    
                    guard let fhirRecord = sample.first?.fhirResource else {
                        print("No FHIR record found!")
                        return NSDictionary.init()
                    }
                    
                    do {
                        let jsonDictionary = try JSONSerialization.jsonObject(with: fhirRecord.data, options: [])
                        
                        return jsonDictionary as! NSDictionary
                    }
                    catch let error {
                        print("*** An error occurred while parsing the FHIR data: \(error.localizedDescription) ***")
                        return NSDictionary.init()
                    }
                }
                
                result(dictionaries)
            }
        }
        
        healthStore.execute(query)
    }
    
    
}
