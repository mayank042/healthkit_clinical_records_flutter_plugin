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
    
    var sampleTypesDict: [String: HKSampleType] = [:]
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "apple_health_clinical_records", binaryMessenger: registrar.messenger())
        let instance = SwiftAppleHealthClinicalRecordsPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        
        initializeTypes()
        
        /// Handle checkIfHealthDataAvailable
        if (call.method.elementsEqual("checkIfHealthDataAvailable")){
            checkIfHealthDataAvailable(call: call, result: result)
        }
        /// Handle requestAuthorization
        else if (call.method.elementsEqual("requestAuthorization")){
            try! requestAuthorization(call: call, result: result)
        }
        
        /// Handle getData
        else if (call.method.elementsEqual("getData")){
           try! getData(call: call, result: result)
        }
        
    }
    
    func checkIfHealthDataAvailable(call: FlutterMethodCall, result: @escaping FlutterResult) {
        result(HKHealthStore.isHealthDataAvailable())
    }
    
    
    func requestAuthorization(call: FlutterMethodCall, result: @escaping FlutterResult) throws {
        
        let arguments = call.arguments as? NSDictionary
        
        
        guard let sampleTypeKey = arguments?["sampleType"] as? String
                
        else {
            throw PluginError(message: "Invalid Arguments!")
        }
        
        
        let status = healthStore.authorizationStatus(for: sampleTypesDict[sampleTypeKey]!)
        
        if status == HKAuthorizationStatus.sharingAuthorized {
            result(true)
        }
        
        healthStore.requestAuthorization(toShare: Set(), read: [sampleTypesDict[sampleTypeKey]!]) { (success, error) in
            DispatchQueue.main.async {
                result(success)
            }
        }
        
        
    }
    
    
    func getData(call: FlutterMethodCall, result: @escaping FlutterResult) throws {
        let arguments = call.arguments as? NSDictionary
         
        guard let sampleTypeKey = arguments?["sampleType"] as? String
                
        else {
            throw PluginError(message: "Invalid Arguments!")
        }
        
        
        queryForSamples(sampleType: sampleTypesDict[sampleTypeKey]!, result: result)
        
    }
    
    
    /// Use HKSampleQuery to query the HealthKit store for samples by type.
    func queryForSamples(sampleType: HKSampleType, result: @escaping FlutterResult) {
        let sortDescriptors = [NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)]
        let query = HKSampleQuery(sampleType: sampleType, predicate: nil, limit: 100, sortDescriptors: sortDescriptors) {(_, samplesOrNil, error) in
            DispatchQueue.main.async {
                guard let samples = samplesOrNil else {
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
    
    func initializeTypes() {
    
        
        sampleTypesDict["allergy"] = HKObjectType.clinicalType(forIdentifier: .allergyRecord)!
        
        sampleTypesDict["condition"] = HKObjectType.clinicalType(forIdentifier: .conditionRecord)!
        
        if #available(iOS 14.0, *) {
            sampleTypesDict["coverage"] = HKObjectType.clinicalType(forIdentifier: .coverageRecord)!
        } else {
            // Fallback on earlier versions
        }
        
        sampleTypesDict["immunization"] = HKObjectType.clinicalType(forIdentifier: .immunizationRecord)!
        
        sampleTypesDict["labResult"] = HKObjectType.clinicalType(forIdentifier: .labResultRecord)!
        
        sampleTypesDict["medication"] = HKObjectType.clinicalType(forIdentifier: .medicationRecord)!
        
        sampleTypesDict["procedure"] = HKObjectType.clinicalType(forIdentifier: .procedureRecord)!
        
        sampleTypesDict["vitalSign"] = HKObjectType.clinicalType(forIdentifier: .vitalSignRecord)!
    
    }
    
    
}
