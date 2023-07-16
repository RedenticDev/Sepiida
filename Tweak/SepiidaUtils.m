#import "SepiidaUtils.h"

@implementation SepiidaUtils

static CTTelephonyNetworkInfo *cellularInfo;
static void *wifi;

+ (instancetype)sharedInstance {
	static SepiidaUtils *sharedInstance = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		sharedInstance = [[SepiidaUtils alloc] init];
		wifi = dlopen(PRIVATE_FRAMEWORK(@"WiFiKit"), RTLD_LAZY);
		cellularInfo = [CTTelephonyNetworkInfo new];
	});
	return sharedInstance;
}

#pragma mark - Colors

+ (UIColor *)backgroundColorFromImage:(UIImage *)image {
	if (!image)
		return [UIColor whiteColor];
	// https://stackoverflow.com/a/13695592/12070367
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	unsigned char rgba[4];
	CGContextRef context = CGBitmapContextCreate(rgba, 1, 1, 8, 4, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);

	CGContextDrawImage(context, CGRectMake(0, 0, 1, 1), image.CGImage);
	CGColorSpaceRelease(colorSpace);
	CGContextRelease(context);

	if (rgba[3] == 0) {
		CGFloat alpha = ((CGFloat)rgba[3]) / 255.0;
		CGFloat multiplier = alpha / 255.0;
		return [UIColor colorWithRed:((CGFloat)rgba[0]) * multiplier
							   green:((CGFloat)rgba[1]) * multiplier
								blue:((CGFloat)rgba[2]) * multiplier
							   alpha:alpha];
	} else {
		return [UIColor colorWithRed:((CGFloat)rgba[0]) / 255.0
							   green:((CGFloat)rgba[1]) / 255.0
								blue:((CGFloat)rgba[2]) / 255.0
							   alpha:((CGFloat)rgba[3]) / 255.0];
	}
}

+ (UIColor *)textColorFromImage:(UIImage *)image {
	UIColor *bgColor = [[self class] backgroundColorFromImage:image];
	if (!bgColor)
		return [UIColor whiteColor];
	return [[self class] textColorForBackgroundColor:bgColor];
}

+ (UIColor *)textColorForBackgroundColor:(UIColor *)backgroundColor {
	// https://github.com/lwlsw/PerfectNotifications/blob/master/PerfectNotifications.xm#L38
	if (!backgroundColor)
		return [UIColor whiteColor];
	int d = 0;
	const CGFloat *rgb = CGColorGetComponents(backgroundColor.CGColor);
	double luminance = (rgb[0] + rgb[1] + rgb[2]) / 255;
	if (luminance <= .0075)
		d = 1;
	NSLog(@"textColor: bg = %@, luminance = %.4f, d = %d", backgroundColor, luminance, d);

	return [UIColor colorWithRed:d green:d blue:d alpha:1];
}

#pragma mark - Battery

- (NSString *)batteryPercent {
	UIDevice *device = [UIDevice currentDevice];
	device.batteryMonitoringEnabled = YES;
	return [NSString stringWithFormat:@"%.f%%", device.batteryLevel * 100];
}

- (NSString *)batteryHealth {
	// https://gist.github.com/shepgoba/b44007536c184dd445a0596ccfa22ebb
	// (doesn't work in SpringBoard)

	io_service_t powerSource = IOServiceGetMatchingService(kIOMasterPortDefault, IOServiceMatching("IOPMPowerSource"));
	if (powerSource) {
		CFMutableDictionaryRef batteryDictionaryRef = NULL;
		if (IORegistryEntryCreateCFProperties(powerSource, &batteryDictionaryRef, 0, 0) == KERN_SUCCESS) {
			int maxCapacity = -1;
			int designCapacity = -1;
			CFNumberRef maxCapRef = (CFNumberRef)IORegistryEntryCreateCFProperty(powerSource, CFSTR("AppleRawMaxCapacity"), kCFAllocatorDefault, 0);
			CFNumberGetValue(maxCapRef, kCFNumberIntType, &maxCapacity);
			CFRelease(maxCapRef);
			CFNumberRef designCapRef = (CFNumberRef)IORegistryEntryCreateCFProperty(powerSource, CFSTR("DesignCapacity"), kCFAllocatorDefault, 0);
			CFNumberGetValue(designCapRef, kCFNumberIntType, &designCapacity);
			CFRelease(designCapRef);
			return [NSString stringWithFormat:@"%d%%", 100 * maxCapacity / designCapacity];
		}
	}
	return @"-%%";
}

- (NSString *)isBatteryCharging {
	UIDevice *device = [UIDevice currentDevice];
	device.batteryMonitoringEnabled = YES;
	switch ([device batteryState]) {
		case UIDeviceBatteryStateCharging:
			return @"Yes";
		case UIDeviceBatteryStateFull:
		case UIDeviceBatteryStateUnplugged:
		case UIDeviceBatteryStateUnknown:
		default:
			return @"No";
	}
}

- (NSString *)isLPMEnabled {
	return [[NSProcessInfo processInfo] isLowPowerModeEnabled] ? @"Yes" : @"No";
}

// Thanks to @quiprr for this part
- (NSString *)batteryCelsiusTemperature {
	io_service_t powerSource = IOServiceGetMatchingService(kIOMasterPortDefault, IOServiceMatching("IOPMPowerSource"));
	if (powerSource) {
		CFMutableDictionaryRef batteryDictionaryRef = NULL;
		if (IORegistryEntryCreateCFProperties(powerSource, &batteryDictionaryRef, 0, 0) == KERN_SUCCESS) {
			float temperature = -1;
			CFNumberRef temperatureRef = (CFNumberRef)IORegistryEntryCreateCFProperty(powerSource, CFSTR("Temperature"), kCFAllocatorDefault, 0);
			CFNumberGetValue(temperatureRef, kCFNumberFloatType, &temperature);
			CFRelease(temperatureRef);
			return [NSString stringWithFormat:@"%.1f°C", temperature / 100];
		}
	}
	return @"--°C";
}

- (NSString *)batteryFahrenheitTemperature {
	NSString *celsiusMethod = [self batteryCelsiusTemperature];
	NSString *celsius = [celsiusMethod substringToIndex:celsiusMethod.length - 2];
	if ([celsius isEqualToString:@"--"])
		return [celsius stringByAppendingString:@"°F"];
	return [NSString stringWithFormat:@"%.1f°F", [celsius floatValue] * 1.8 + 32.0];
}

- (NSString *)batteryCycles {
	io_service_t powerSource = IOServiceGetMatchingService(kIOMasterPortDefault, IOServiceMatching("IOPMPowerSource"));
	if (powerSource) {
		CFMutableDictionaryRef batteryDictionaryRef = NULL;
		if (IORegistryEntryCreateCFProperties(powerSource, &batteryDictionaryRef, 0, 0) == KERN_SUCCESS) {
			int cycles = -1;
			CFNumberRef cyclesRef = (CFNumberRef)IORegistryEntryCreateCFProperty(powerSource, CFSTR("CycleCount"), kCFAllocatorDefault, 0);
			CFNumberGetValue(cyclesRef, kCFNumberIntType, &cycles);
			CFRelease(cyclesRef);
			return [NSString stringWithFormat:@"%d", cycles];
		}
	}
	return @"-";
}

- (NSString *)currentBatteryCapacity {
	io_service_t powerSource = IOServiceGetMatchingService(kIOMasterPortDefault, IOServiceMatching("IOPMPowerSource"));
	if (powerSource) {
		CFMutableDictionaryRef batteryDictionaryRef = NULL;
		if (IORegistryEntryCreateCFProperties(powerSource, &batteryDictionaryRef, 0, 0) == KERN_SUCCESS) {
			int currCapacity = -1;
			CFNumberRef currCapRef = (CFNumberRef)IORegistryEntryCreateCFProperty(powerSource, CFSTR("AppleRawCurrentCapacity"), kCFAllocatorDefault, 0);
			CFNumberGetValue(currCapRef, kCFNumberIntType, &currCapacity);
			CFRelease(currCapRef);
			return [NSString stringWithFormat:@"%d mAh", currCapacity];
		}
	}
	return @"- mAh";
}

- (NSString *)maximalBatteryCapacity {
	io_service_t powerSource = IOServiceGetMatchingService(kIOMasterPortDefault, IOServiceMatching("IOPMPowerSource"));
	if (powerSource) {
		CFMutableDictionaryRef batteryDictionaryRef = NULL;
		if (IORegistryEntryCreateCFProperties(powerSource, &batteryDictionaryRef, 0, 0) == KERN_SUCCESS) {
			int maxCapacity = -1;
			CFNumberRef maxCapRef = (CFNumberRef)IORegistryEntryCreateCFProperty(powerSource, CFSTR("AppleRawMaxCapacity"), kCFAllocatorDefault, 0);
			CFNumberGetValue(maxCapRef, kCFNumberIntType, &maxCapacity);
			CFRelease(maxCapRef);
			return [NSString stringWithFormat:@"%d mAh", maxCapacity];
		}
	}
	return @"- mAh";
}

- (NSString *)designBatteryCapacity {
	io_service_t powerSource = IOServiceGetMatchingService(kIOMasterPortDefault, IOServiceMatching("IOPMPowerSource"));
	if (powerSource) {
		CFMutableDictionaryRef batteryDictionaryRef = NULL;
		if (IORegistryEntryCreateCFProperties(powerSource, &batteryDictionaryRef, 0, 0) == KERN_SUCCESS) {
			int designCapacity = -1;
			CFNumberRef designCapRef = (CFNumberRef)IORegistryEntryCreateCFProperty(powerSource, CFSTR("DesignCapacity"), kCFAllocatorDefault, 0);
			CFNumberGetValue(designCapRef, kCFNumberIntType, &designCapacity);
			CFRelease(designCapRef);
			return [NSString stringWithFormat:@"%d mAh", designCapacity];
		}
	}
	return @"- mAh";
}

- (NSString *)batteryAmperage {
	io_service_t powerSource = IOServiceGetMatchingService(kIOMasterPortDefault, IOServiceMatching("IOPMPowerSource"));
	if (powerSource) {
		CFMutableDictionaryRef batteryDictionaryRef = NULL;
		if (IORegistryEntryCreateCFProperties(powerSource, &batteryDictionaryRef, 0, 0) == KERN_SUCCESS) {
			int amperage = -1;
			CFNumberRef amperageRef = (CFNumberRef)IORegistryEntryCreateCFProperty(powerSource, CFSTR("InstantAmperage"), kCFAllocatorDefault, 0);
			CFNumberGetValue(amperageRef, kCFNumberIntType, &amperage);
			CFRelease(amperageRef);
			return [NSString stringWithFormat:@"%d mA", amperage];
		}
	}
	return @"- mA";
}

- (NSString *)batteryVoltage {
	io_service_t powerSource = IOServiceGetMatchingService(kIOMasterPortDefault, IOServiceMatching("IOPMPowerSource"));
	if (powerSource) {
		CFMutableDictionaryRef batteryDictionaryRef = NULL;
		if (IORegistryEntryCreateCFProperties(powerSource, &batteryDictionaryRef, 0, 0) == KERN_SUCCESS) {
			float voltage = -1;
			CFNumberRef voltageRef = (CFNumberRef)IORegistryEntryCreateCFProperty(powerSource, CFSTR("Voltage"), kCFAllocatorDefault, 0);
			CFNumberGetValue(voltageRef, kCFNumberFloatType, &voltage);
			CFRelease(voltageRef);
			return [NSString stringWithFormat:@"%.1f V", voltage / 1000];
		}
	}
	return @"- V";
}

#pragma mark - Cellular

- (NSString *)isCellularEnabled {
	return [[self networkProvider] isEqualToString:@"No SIM"] ? @"No" : @"Yes";
}

- (NSString *)networkProvider {
	NSString *carrierName = cellularInfo.serviceSubscriberCellularProviders[cellularInfo.dataServiceIdentifier].carrierName;
	return carrierName ?: @"No SIM";
}

- (NSString *)networkCoverage {
	NSString *coverage = [cellularInfo.serviceCurrentRadioAccessTechnology[cellularInfo.dataServiceIdentifier]
		stringByReplacingOccurrencesOfString:@"CTRadioAccessTechnology"
								  withString:@""];
	return coverage.length > 0 ? coverage : @"No SIM";
}

- (NSString *)networkBars {
	NSString *bars = [NSString stringWithFormat:@"%@", [[cellularInfo signalStrength] valueForKey:@"CTSignalStrengthBarsKey"]];
	return bars ?: @"No SIM";
}

- (NSString *)publicIP {
	// https://github.com/Shmoopi/iOS-System-Services/blob/dfe2a22b13f2a5c89f4dabbf28a4a40f8d6fd3c6/System%20Services/Utilities/SSNetworkInfo.m#L277
	NSError *error;
	NSString *externalIP = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"https://api.ipify.org/"] encoding:NSUTF8StringEncoding error:&error];

	if (error)
		return @"Not connected";
	externalIP = [externalIP stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
	return (!externalIP || externalIP.length <= 0) ? @"127.0.0.1" : externalIP;
}

#pragma mark - Wi-Fi

- (NSString *)isWifiEnabled {
	NSString *value = @"N/A";
	Class wfClient = NSClassFromString(@"WFClient");
	if (wfClient)
		value = [(WFClient *)[NSClassFromString(@"WFClient") sharedInstance] powered] ? @"Yes" : @"No";
	return value;
}

- (NSString *)isWifiConnected {
	NSString *value = @"N/A";
	Class wfClient = NSClassFromString(@"WFClient");
	if (wfClient)
		value = [[self wifiNetwork] isEqualToString:@"Not connected"] ? @"No" : @"Yes";
	return value;
}

- (NSString *)wifiNetwork {
	NSString *network = @"N/A";
	Class wfClient = NSClassFromString(@"WFClient");
	if (wfClient)
		network = ((WFNetworkScanRecord *)((WFInterface *)((WFClient *)[NSClassFromString(@"WFClient") sharedInstance]).interface).currentNetwork).ssid;
	return network ?: @"Not connected";
}

- (NSString *)wifiQuality {
	NSString *value = @"N/A";
	Class wfClient = NSClassFromString(@"WFClient");
	if (wfClient)
		value = [NSString stringWithFormat:@"%lu", [((WFInterface *)((WFClient *)[NSClassFromString(@"WFClient") sharedInstance]).interface).currentNetwork signalBars] - 1];
	return value;
}

- (NSString *)privateIP {
	// https://github.com/hbang/RuntimeBrowser/blob/master/iOS/RTBMyIP.m#L27
	struct ifaddrs *list;
	if (getifaddrs(&list) < 0) {
		perror("getifaddrs");
		return nil;
	}

	NSMutableDictionary *d = [NSMutableDictionary dictionary];
	struct ifaddrs *cur;
	for (cur = list; cur != NULL; cur = cur->ifa_next) {
		if (cur->ifa_addr->sa_family != AF_INET)
			continue;

		struct sockaddr_in *addrStruct = (struct sockaddr_in *)cur->ifa_addr;
		NSString *name = [NSString stringWithUTF8String:cur->ifa_name];
		NSString *addr = [NSString stringWithUTF8String:inet_ntoa(addrStruct->sin_addr)];
		[d setValue:addr forKey:name];
	}

	freeifaddrs(list);
	return d[@"en0"] ?: @"127.0.0.1";
}

#pragma mark - Bluetooth

- (NSString *)isBluetoothEnabled {
	return [[BluetoothManager sharedInstance] enabled] ? @"Yes" : @"No";
}

- (NSString *)isBluetoothConnected {
	return [[BluetoothManager sharedInstance] connected] ? @"Yes" : @"No";
}

- (NSString *)bluetoothConnectedDevices {
	NSArray *connectedDevices =
		[[BluetoothManager sharedInstance] connectedDevices];
	if ([connectedDevices count] <= 0)
		return @"No device connected";

	NSString *devicesToString;
	for (int i = 0; i < [connectedDevices count]; i++) {
		devicesToString = [devicesToString
			stringByAppendingFormat:@"%@", ((BluetoothDevice *)connectedDevices[i]).name];
		if (i < [connectedDevices count] - 1)
			devicesToString = [devicesToString stringByAppendingFormat:@", "];
	}
	return devicesToString.length > 0 ? devicesToString : @"N/A";
}

@end
