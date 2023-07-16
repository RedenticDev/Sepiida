#include <arpa/inet.h>
#include <dlfcn.h>
#include <ifaddrs.h>
#import <BluetoothManager/BluetoothManager.h>
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <IOKit/IOKitLib.h>
#import <UIKit/UIKit.h>

#pragma mark - Interfaces
@interface BatteryHealthUIController
- (void)updateData;
- (int)maximumCapacityPercent;
@end

// Cellular
@interface CTTelephonyNetworkInfo (Sepiida)
- (id)signalStrength;
@end

// WiFi
@interface WFClient: NSObject
@property (nonatomic, retain) id interface; // WFInterface
- (BOOL)powered;
@end

@interface WFInterface: NSObject
@property (nonatomic, retain) id currentNetwork; // WFNetworkScanRecord
@property (nonatomic, retain) id ipMonitor; // WFIPMonitor
@end

@interface WFIPMonitor: NSObject
- (NSArray *)ipv4Addresses;
@end

@interface WFNetworkScanRecord: NSObject
@property (nonatomic, copy) NSString *ssid;
- (NSUInteger)signalBars;
@end

#pragma mark - Class

@interface SepiidaUtils: NSObject
+ (instancetype)sharedInstance;
+ (UIColor *)backgroundColorFromImage:(UIImage *)image;
+ (UIColor *)textColorFromImage:(UIImage *)image;
+ (UIColor *)textColorForBackgroundColor:(UIColor *)backgroundColor;

- (NSString *)batteryPercent;
- (NSString *)batteryHealth;
- (NSString *)isBatteryCharging;
- (NSString *)isLPMEnabled;
- (NSString *)batteryCelsiusTemperature;
- (NSString *)batteryFahrenheitTemperature;
- (NSString *)batteryCycles;
- (NSString *)currentBatteryCapacity;
- (NSString *)maximalBatteryCapacity;
- (NSString *)designBatteryCapacity;
- (NSString *)batteryAmperage;
- (NSString *)batteryVoltage;

- (NSString *)isCellularEnabled;
- (NSString *)networkProvider;
- (NSString *)networkCoverage;
- (NSString *)networkBars;
- (NSString *)publicIP;

- (NSString *)isWifiEnabled;
- (NSString *)isWifiConnected;
- (NSString *)wifiNetwork;
- (NSString *)wifiQuality;
- (NSString *)privateIP;

- (NSString *)isBluetoothEnabled;
- (NSString *)isBluetoothConnected;
- (NSString *)bluetoothConnectedDevices;
@end
