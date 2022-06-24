#import "AppleHealthClinicalRecordsPlugin.h"
#if __has_include(<apple_health_clinical_records/apple_health_clinical_records-Swift.h>)
#import <apple_health_clinical_records/apple_health_clinical_records-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "apple_health_clinical_records-Swift.h"
#endif

@implementation AppleHealthClinicalRecordsPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftAppleHealthClinicalRecordsPlugin registerWithRegistrar:registrar];
}
@end
