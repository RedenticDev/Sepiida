#import "Sepiida.h"

#pragma mark - Common

static SBSApplicationShortcutItem *formattedApplicationShortcutItem(SBSApplicationShortcutItem *item) {
	if ([item.type isEqualToString:@"com.apple.Preferences.power"]) {
		dispatch_async(dispatch_get_main_queue(), ^{
			if (customBatteryText && ![customBatteryText isEqualToString:@""]) {
				if (!batteryBaseText)
					batteryBaseText = item.localizedTitle;
				item.localizedTitle = [[[[[[[[[[[[[customBatteryText
					stringByReplacingOccurrencesOfString:@"$original$" withString:batteryBaseText]
					stringByReplacingOccurrencesOfString:@"$percent$" withString:[utils batteryPercent]]
					stringByReplacingOccurrencesOfString:@"$health$" withString:[utils batteryHealth]]
					stringByReplacingOccurrencesOfString:@"$is-charging$" withString:[utils isBatteryCharging]]
					stringByReplacingOccurrencesOfString:@"$is-lpm-enabled$" withString:[utils isLPMEnabled]]
					stringByReplacingOccurrencesOfString:@"$temperatureF$" withString:[utils batteryFahrenheitTemperature]]
					stringByReplacingOccurrencesOfString:@"$temperatureC$" withString:[utils batteryCelsiusTemperature]]
					stringByReplacingOccurrencesOfString:@"$cycles$" withString:[utils batteryCycles]]
					stringByReplacingOccurrencesOfString:@"$capacity$" withString:[utils currentBatteryCapacity]]
					stringByReplacingOccurrencesOfString:@"$max-capacity$" withString:[utils maximalBatteryCapacity]]
					stringByReplacingOccurrencesOfString:@"$design-capacity$" withString:[utils designBatteryCapacity]]
					stringByReplacingOccurrencesOfString:@"$amperage$" withString:[utils batteryAmperage]]
					stringByReplacingOccurrencesOfString:@"$voltage$" withString:[utils batteryVoltage]];
			}
			if (customBatterySubText && ![customBatterySubText isEqualToString:@""]) {
				item.localizedSubtitle = [[[[[[[[[[[[customBatterySubText
					stringByReplacingOccurrencesOfString:@"$percent$" withString:[utils batteryPercent]]
					stringByReplacingOccurrencesOfString:@"$health$" withString:[utils batteryHealth]]
					stringByReplacingOccurrencesOfString:@"$is-charging$" withString:[utils isBatteryCharging]]
					stringByReplacingOccurrencesOfString:@"$is-lpm-enabled$" withString:[utils isLPMEnabled]]
					stringByReplacingOccurrencesOfString:@"$temperatureF$" withString:[utils batteryFahrenheitTemperature]]
					stringByReplacingOccurrencesOfString:@"$temperatureC$" withString:[utils batteryCelsiusTemperature]]
					stringByReplacingOccurrencesOfString:@"$cycles$" withString:[utils batteryCycles]]
					stringByReplacingOccurrencesOfString:@"$capacity$" withString:[utils currentBatteryCapacity]]
					stringByReplacingOccurrencesOfString:@"$max-capacity$" withString:[utils maximalBatteryCapacity]]
					stringByReplacingOccurrencesOfString:@"$design-capacity$" withString:[utils designBatteryCapacity]]
					stringByReplacingOccurrencesOfString:@"$amperage$" withString:[utils batteryAmperage]]
					stringByReplacingOccurrencesOfString:@"$voltage$" withString:[utils batteryVoltage]];
			}
		});
	} else if ([item.type isEqualToString:@"com.apple.Preferences.cellularData"]) {
		dispatch_async(dispatch_get_main_queue(), ^{
			if (customCellularText && ![customCellularText isEqualToString:@""]) {
				if (!cellularBaseText)
					cellularBaseText = item.localizedTitle;
				item.localizedTitle = [[[[[[customCellularText
					stringByReplacingOccurrencesOfString:@"$original$" withString:cellularBaseText]
					stringByReplacingOccurrencesOfString:@"$is-enabled$" withString:[utils isCellularEnabled]]
					stringByReplacingOccurrencesOfString:@"$carrier$" withString:[utils networkProvider]]
					stringByReplacingOccurrencesOfString:@"$coverage$" withString:[utils networkCoverage]]
					stringByReplacingOccurrencesOfString:@"$coverage-bars$" withString:[utils networkBars]]
					stringByReplacingOccurrencesOfString:@"$public-ip$" withString:[utils publicIP]];
			}
			if (customCellularSubText && ![customCellularSubText isEqualToString:@""]) {
				item.localizedSubtitle = [[[[[customCellularSubText
					stringByReplacingOccurrencesOfString:@"$is-enabled$" withString:[utils isCellularEnabled]]
					stringByReplacingOccurrencesOfString:@"$carrier$" withString:[utils networkProvider]]
					stringByReplacingOccurrencesOfString:@"$coverage$" withString:[utils networkCoverage]]
					stringByReplacingOccurrencesOfString:@"$coverage-bars$" withString:[utils networkBars]]
					stringByReplacingOccurrencesOfString:@"$public-ip$" withString:[utils publicIP]];
			}
		});
	} else if ([item.type isEqualToString:@"com.apple.Preferences.wifi"]) {
		dispatch_async(dispatch_get_main_queue(), ^{
			if (customWifiText && ![customWifiText isEqualToString:@""]) {
				if (!wifiBaseText)
					wifiBaseText = item.localizedTitle;
				item.localizedTitle = [[[[[[[customWifiText
					stringByReplacingOccurrencesOfString:@"$original$" withString:wifiBaseText]
					stringByReplacingOccurrencesOfString:@"$is-enabled$" withString:[utils isWifiEnabled]]
					stringByReplacingOccurrencesOfString:@"$is-connected$" withString:[utils isWifiConnected]]
					stringByReplacingOccurrencesOfString:@"$network$" withString:[utils wifiNetwork]]
					stringByReplacingOccurrencesOfString:@"$quality$" withString:[utils wifiQuality]]
					stringByReplacingOccurrencesOfString:@"$private-ip$" withString:[utils privateIP]]
					stringByReplacingOccurrencesOfString:@"$public-ip$" withString:[utils publicIP]];
			}
			if (customWifiSubText && ![customWifiSubText isEqualToString:@""]) {
				item.localizedSubtitle = [[[[[[customWifiSubText
					stringByReplacingOccurrencesOfString:@"$is-enabled$" withString:[utils isWifiEnabled]]
					stringByReplacingOccurrencesOfString:@"$is-connected$" withString:[utils isWifiConnected]]
					stringByReplacingOccurrencesOfString:@"$network$" withString:[utils wifiNetwork]]
					stringByReplacingOccurrencesOfString:@"$quality$" withString:[utils wifiQuality]]
					stringByReplacingOccurrencesOfString:@"$private-ip$" withString:[utils privateIP]]
					stringByReplacingOccurrencesOfString:@"$public-ip$" withString:[utils publicIP]];
			}
		});
	} else if ([item.type isEqualToString:@"com.apple.Preferences.bluetooth"]) {
		dispatch_async(dispatch_get_main_queue(), ^{
			if (customBluetoothText && ![customBluetoothText isEqualToString:@""]) {
				if (!bluetoothBaseText)
					bluetoothBaseText = item.localizedTitle;
				item.localizedTitle = [[[[customBluetoothText
					stringByReplacingOccurrencesOfString:@"$original$" withString:bluetoothBaseText]
					stringByReplacingOccurrencesOfString:@"$is-enabled$" withString:[utils isBluetoothEnabled]]
					stringByReplacingOccurrencesOfString:@"$is-connected$" withString:[utils isBluetoothConnected]]
					stringByReplacingOccurrencesOfString:@"$connected-devices$" withString:[utils bluetoothConnectedDevices]];
			}
			if (customBluetoothSubText && ![customBluetoothSubText isEqualToString:@""]) {
				item.localizedSubtitle = [[[customBluetoothSubText
					stringByReplacingOccurrencesOfString:@"$is-enabled$" withString:[utils isBluetoothEnabled]]
					stringByReplacingOccurrencesOfString:@"$is-connected$" withString:[utils isBluetoothConnected]]
					stringByReplacingOccurrencesOfString:@"$connected-devices$" withString:[utils bluetoothConnectedDevices]];
			}
		});
	}
	return item;
}

%group COMMON

%hook _UIStatusBar // OK

- (instancetype)initWithStyle:(NSInteger)arg1 {
	if ((self = %orig)) {
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sepiida_toggleStatusBarState:) name:[TWEAK_BUNDLE_ID stringByAppendingString:@"/toggleStatusBar"] object:nil];
	}
	return self;
}

%new
- (void)sepiida_toggleStatusBarState:(NSNotification *)sender {
	if (showStatusBar)
		return;
	[UIView transitionWithView:self duration:.25 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
		if (sender.userInfo && sender.userInfo[@"open"]) {
			self.foregroundView.hidden = [sender.userInfo[@"open"] boolValue];
		} else {
			self.foregroundView.hidden = !self.foregroundView.hidden;
		}
	} completion:nil];
}

%end

%hook SBIconView // OK

- (void)contextMenuInteraction:(id)arg1 willDisplayMenuForConfiguration:(id)arg2 animator:(id)arg3 {
	[[NSNotificationCenter defaultCenter] postNotificationName:[TWEAK_BUNDLE_ID stringByAppendingString:@"/toggleStatusBar"] object:nil userInfo:@{
		@"open": @YES
	}];
	[[NSNotificationCenter defaultCenter] postNotificationName:[TWEAK_BUNDLE_ID stringByAppendingString:@"/clearBackgroundColor"] object:nil];
	cachedIcon = self.iconImageSnapshot;
	%orig;
}

- (void)contextMenuInteraction:(id)arg1 willEndForConfiguration:(id)arg2 animator:(id)arg3 {
	[[NSNotificationCenter defaultCenter] postNotificationName:[TWEAK_BUNDLE_ID stringByAppendingString:@"/toggleStatusBar"] object:nil userInfo:@{
		@"open": @NO
	}];
	[[NSNotificationCenter defaultCenter] postNotificationName:[TWEAK_BUNDLE_ID stringByAppendingString:@"/clearBackgroundColor"] object:nil];
	cachedIcon = nil;
	%orig;
}

%end

%hook _UIContextMenuContainerView // OK

- (instancetype)initWithFrame:(CGRect)arg1 {
	if ((self = %orig)) {
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sepiida_clearBackgroundColor:) name:[TWEAK_BUNDLE_ID stringByAppendingString:@"/clearBackgroundColor"] object:nil];
	}
	return self;
}

- (void)willMoveToWindow:(id)arg1 {
	%orig;
	if (!arg1)
		return;
	switch (backgroundColorChoice) {
		case 1: { // dynamic
			UIColor *dynamicColor = [[SepiidaUtils backgroundColorFromImage:cachedIcon] colorWithAlphaComponent:enableCustomBackgroundBlur ? customBackgroundBlurAlpha : 0.21];
			[UIView animateWithDuration:.25 animations:^{
				self.backgroundColor = dynamicColor;
			} completion:nil];
		} break;

		case 2: { // custom
			UIColor *customColor = [LCPParseColorString(backgroundColor, @"#ffffff") colorWithAlphaComponent:enableCustomBackgroundBlur ? customBackgroundBlurAlpha : 0.21];
			[UIView animateWithDuration:.25 animations:^{
				self.backgroundColor = customColor;
			} completion:nil];
		} break;

		case 0:	 // default
		default:
			break;
	}
}

%new
- (void)sepiida_clearBackgroundColor:(NSNotification *)sender {
	[UIView animateWithDuration:.25 animations:^{
		self.backgroundColor = nil;
	} completion:nil];
}

%end

%hook _UIContextMenuActionView // OK

- (void)didMoveToWindow { // TODO: change to backgroundColor?
	%orig;
	switch (itemsColorChoice) {
		case 1:	 // dynamic
			self.backgroundColor = [[SepiidaUtils backgroundColorFromImage:cachedIcon] colorWithAlphaComponent:enableCustomItemsBlur ? customItemsBlurAlpha : 1.0];
			break;

		case 2:	 // custom
			self.backgroundColor = [LCPParseColorString(itemsColor, @"#ffffff") colorWithAlphaComponent:enableCustomItemsBlur ? customItemsBlurAlpha : 1.0];
			break;

		case 0:	 // default
		default:
			break;
	}
	switch (labelsColorChoice) {
		case 1: { // dynamic
			UIColor *dynamicLabelsColor = [SepiidaUtils textColorFromImage:cachedIcon];
			self.titleLabel.textColor = dynamicLabelsColor;
			if (self.subtitleLabel)
				self.subtitleLabel.textColor = dynamicLabelsColor;
			if (@available(iOS 14.0, *)) {
				self.trailingImageView.tintColor = dynamicLabelsColor;
			} else {
				self.imageView.tintColor = dynamicLabelsColor;
			}
		} break;

		case 2: { // custom
			UIColor *customLabelsColor = LCPParseColorString(labelsColor, @"#ffffff");
			self.titleLabel.textColor = customLabelsColor;
			if (self.subtitleLabel)
				self.subtitleLabel.textColor = customLabelsColor;
			if (@available(iOS 14.0, *)) {
				self.trailingImageView.tintColor = customLabelsColor;
			} else {
				self.imageView.tintColor = customLabelsColor;
			}
		} break;

		case 0:	 // default
		default:
			break;
	}
}

%end

%end

#pragma mark - iOS 14
// Cell height, corner radii
// FIXME: menu, items & labels on close, default alpha for menu & bg

%group iOS_14

%hook SBIconView // OK

- (NSArray *)applicationShortcutItems {
	NSArray *previous = %orig;

	if (reverseOrder)
		previous = [[previous reverseObjectEnumerator] allObjects];
	NSMutableArray *newItems = [NSMutableArray array];
	[previous enumerateObjectsUsingBlock:^(SBSApplicationShortcutItem *item, NSUInteger index, BOOL *stop) {
		if ((!removeBeta || ![item.type isEqualToString:@"com.apple.SpringBoardServices.application-shortcut-item-type.send-beta-feedback"]) &&
			(!removeRearrange || ![item.type isEqualToString:@"com.apple.springboardhome.application-shortcut-item.rearrange-icons"]) &&
			(!removeShare || ![item.type isEqualToString:@"com.apple.springboardhome.application-shortcut-item.share"]) &&
			(!removeDelete || ![item.type isEqualToString:@"com.apple.springboardhome.application-shortcut-item.remove-app"])) {
			if ([self.applicationBundleIdentifierForShortcuts isEqualToString:@"com.apple.Preferences"])
				item = formattedApplicationShortcutItem(item);
			[newItems addObject:item];
		}
	}];
	return newItems;
}

%end

%hook _UIContextMenuActionsListSeparatorView // OK

- (void)setHidden:(BOOL)arg1 {
	if (removeThinSeparators && [self._viewControllerForAncestor isKindOfClass:%c(SBIconController)])
		%orig(YES);
	else
		%orig;
}

%end

%hook UICollectionReusableView // OK

- (void)didMoveToSuperview {
	%orig;
	if (removeBoldSeparators && !self.hidden && [self.reuseIdentifier isEqualToString:@"kContextMenuItemSeparator"])
		self.hidden = YES;
}

%end

%hook _UIContextMenuActionsListView // OK

- (void)didMoveToWindow {
	%orig;
	if (forcedTheme != 0)
		self.overrideUserInterfaceStyle = forcedTheme;
}

%end

%hook _UIContextMenuActionsListCell

// - (void)didMoveToWindow {
// 	%orig;
// 	[self invalidateContentSize];
// }

- (CGSize)intrinsicContentSize { // FIXME
	CGSize cellSize = %orig;
	if (cellSize.height > cellHeight)
		return cellSize;
	return CGSizeMake(cellSize.width, cellHeight);
}

- (UIColor *)backgroundColor {
	switch (itemsColorChoice) {
		case 1:	// dynamic
			return [[SepiidaUtils backgroundColorFromImage:cachedIcon] colorWithAlphaComponent:enableCustomItemsBlur ? customItemsBlurAlpha : .0];

		case 2: // custom
			return [LCPParseColorString(itemsColor, @"#ffffff") colorWithAlphaComponent:enableCustomItemsBlur ? customItemsBlurAlpha : .0];

		case 0: // default
		default:
			return %orig;
	}
}

%end

%hook _UIElasticContextMenuBackgroundView

- (void)didMoveToWindow {
	%orig;
	switch (menuColorChoice) {
		case 1:	// dynamic
			self.backgroundColor = [[SepiidaUtils backgroundColorFromImage:cachedIcon] colorWithAlphaComponent:enableCustomMenuBlur ? customMenuBlurAlpha : 1];

		case 2:	// custom
			self.backgroundColor = [LCPParseColorString(menuColor, @"#ffffff") colorWithAlphaComponent:enableCustomMenuBlur ? customMenuBlurAlpha : 1];

		case 0:	// default
		default:
			break;
	}
}

%end

%end

#pragma mark - iOS 13

%group iOS_13

%hook _UIDimmingKnockoutBackdropView

- (void)willMoveToWindow:(id)arg1 {
	%orig;
	if ([self.superview.superview isKindOfClass:%c(_UIContextMenuActionListView)]) {
		switch (menuColorChoice) {
			case 1:	 // dynamic
				self.backgroundColor = [[SepiidaUtils backgroundColorFromImage:cachedIcon]
						colorWithAlphaComponent:enableCustomMenuBlur ? customMenuBlurAlpha : 0.5];
				break;

			case 2:	 // custom
				self.backgroundColor =
					[LCPParseColorString(menuColor, @"#ffffff")
						colorWithAlphaComponent:enableCustomMenuBlur ? customMenuBlurAlpha : 0.5];
				break;

			case 0:	 // default
			default:
				break;
		}
		self.layer.cornerRadius = cornerRadiusForMenu;
		self.layer.maskedCorners = cornerRadiusForMenu;
		self.layer.continousCorners = YES;
	}
}

%end

%hook _UIVisualEffectBackdropView

- (void)willMoveToWindow:(id)arg1 {
	%orig;
	if ([self.superview.superview.superview.superview isKindOfClass:%c(_UIContextMenuActionListView)]) {
		switch (menuColorChoice) {
			case 1:	 // dynamic
				self.backgroundColor = [[SepiidaUtils backgroundColorFromImage:cachedIcon] colorWithAlphaComponent:enableCustomMenuBlur ? customMenuBlurAlpha : 0.5];
				break;

			case 2:	 // custom
				self.backgroundColor = [LCPParseColorString(menuColor, @"#ffffff") colorWithAlphaComponent:enableCustomMenuBlur ? customMenuBlurAlpha : 0.5];
				break;

			case 0:	 // default
				if (enableCustomMenuBlur)
					self.alpha = customMenuBlurAlpha;
				break;

			default:
				break;
		}
		self.layer.cornerRadius = cornerRadiusForMenu;
		self.layer.maskedCorners = cornerRadiusForMenu;
		self.layer.continousCorners = YES;
	} else if (enableCustomBackgroundBlur && backgroundColorChoice == 0 && [self.superview.superview isKindOfClass:%c(_UIContextMenuContainerView)] && self.superview.superview.subviews[1] == self) {	// I know not perfect :/
		self.alpha = customBackgroundBlurAlpha;
	}
}

%end

// %hook SBAppIconForceTouchDefaults

// - (float)animationDurationMultiplier {
// 	return .5;
// }

// %end

// %hook _UIContextMenuAnimator // FIXME: 1.1.0 -> not working, remove prefs group;

// - (void)addAnimations:(id/*block*/)arg1 {
// 	NSLog(@"[Sepiida] %@ addAnimations:%@", self, arg1);
// 	%orig;

// 	id value = ((id(^)())(arg1))();
// 	NSLog(@"value = %@", [value class]);
// 	%orig;

// 	id customHandler = ^() {
// 		if (arg1) NSLog(@"%@", ((id(^)())(arg1))());
// 	};
// 	%orig(customHandler);

// 	CABasicAnimation *theAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
// 	theAnimation.duration = 3.0;
// 	theAnimation.repeatCount = 2;
// 	theAnimation.autoreverses = NO; // (YES) - Reverses into the initial value either smoothly or not
// 	theAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(screenWidth / 2, _animationButton.frame.origin.y)];
// 	theAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(100, 100)];
// 	[theLayer addAnimation:theAnimation forKey:@"animatePosition"];
// }

// - (id)animations {
// 	NSLog(@"[Sepiida] %@ animations -> %@", self, %orig);
// 	return nil;
// }

// %end

%hook SBHHomeScreenSettings	// OK

- (BOOL)showWidgets {
	return !removeWidgets;
}

%end

%hook SBIconView // OK

- (NSArray *)applicationShortcutItems {
	NSArray *previous = %orig;

	if (reverseOrder)
		previous = [[previous reverseObjectEnumerator] allObjects];
	NSMutableArray *newItems = [NSMutableArray array];
	[previous enumerateObjectsUsingBlock:^(SBSApplicationShortcutItem *item, NSUInteger index, BOOL *stop) {
		if ((!removeBeta || ![item.type isEqualToString:@"com.apple.SpringBoardServices.application-shortcut-item-type.send-beta-feedback"]) &&
			(!removeRearrange || ![item.type isEqualToString:@"com.apple.springboardhome.application-shotcut-item.rearrange-icons"]) &&
			(!removeShare || ![item.type isEqualToString:@"com.apple.springboardhome.application-shortcut-item.share"]) &&
			(!removeDelete || ![item.type isEqualToString:@"com.apple.springboardhome.application-shotcut-item.delete-app"])) {
			if ([self.applicationBundleIdentifierForShortcuts isEqualToString:@"com.apple.Preferences"])
				item = formattedApplicationShortcutItem(item);
			[newItems addObject:item];
		}
	}];
	return newItems;
}

%end

%hook _UIInterfaceActionCustomViewRepresentationView // FIXME: cornerRadius;

- (void)didMoveToSuperview {
	%orig;
	/*self.layer.cornerRadius = cornerRadiusForItems;
	self.layer.maskedCorners = cornerRadiusForItems;
	self.layer.continousCorners = YES; // FIXME: crash move apps*/
}

- (CGSize)intrinsicContentSize {
	CGSize cellSize = %orig;
	if (cellSize.height > cellHeight)
		return cellSize;
	if ([self.superview.superview.superview.superview.superview isMemberOfClass:%c(UIInterfaceActionGroupView)])
		return CGSizeMake(cellSize.width, cellHeight);
	return cellSize;
}

%end

%hook _UIInterfaceActionBlankSeparatorView // OK

- (void)setHidden:(BOOL)arg1 {
	if (removeBoldSeparators && [self._viewControllerForAncestor isKindOfClass:%c(SBIconController)])
		%orig(YES);
	else
		%orig;
}

%end

%hook _UIInterfaceActionVibrantSeparatorView // OK

- (void)setHidden:(BOOL)arg1 {
	if (removeThinSeparators && [self._viewControllerForAncestor isKindOfClass:%c(SBIconController)])
		%orig(YES);
	else
		%orig;
}

%end

%hook UIInterfaceActionGroupView // OK

- (void)didMoveToWindow {
	%orig;
	if (forcedTheme != 0)
		self.overrideUserInterfaceStyle = forcedTheme;
}

%end

%end

#pragma mark - DRM & Tweak functions

%group DRM // OK

%hook SBHomeScreenViewController

- (void)viewDidAppear:(BOOL)arg1 {
	%orig;
	// Taken and modified from NepetaDev/Notifica
	if (!dpkgInvalid || alertShown)
		return;
	NSDictionary *links = @{
		@"com.saurik.Cydia": [@"cydia://url/https://cydia.saurik.com/api/share#?source=" stringByAppendingString:REPO_URL],
		@"xyz.willy.Zebra": [@"zbra://sources/add/" stringByAppendingString:REPO_URL],
		@"org.coolstar.SileoStore": [@"sileo://source/" stringByAppendingString:REPO_URL],
		@"me.apptapp.installer": [@"installer://add/" stringByAppendingString:REPO_URL]
	};
	UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"⚠️ Warning ⚠️" message:[NSString stringWithFormat:@"\nIt seems you're using a modified version of Sepiida taken from an untrusted repo.\n\nA modified build can distribute malwares and may impair the user experience.\n\nThis tweak is free, please install it from the right repo using the buttons below (%@).\n\nNO SUPPORT WILL BE PROVIDED FOR MODIFIED BUILDS.", REPO_URL] preferredStyle:UIAlertControllerStyleAlert];
	for (NSString *key in [links allKeys]) {
		if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:links[key]]]) {
			[alert addAction:[UIAlertAction actionWithTitle:[%c(LSApplicationProxy) applicationProxyForIdentifier:key].localizedName style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
				[[UIApplication sharedApplication] openURL:[NSURL URLWithString:links[key]] options:@{} completionHandler:nil];
				alertShown = YES;
				[prefs setBool:YES forKey:@"alertShown"];
			}]];
		}
	}
	[alert addAction:[UIAlertAction actionWithTitle:@"I accept the risks" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
		alertShown = YES;
		[prefs setBool:YES forKey:@"alertShown"];
	}]];

	[self presentViewController:alert animated:YES completion:nil];
}

%end

%end

static void sepiida_testSetup() {
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, .25 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
		if (VEXILLARIUS_INSTALLED)
			showBanner([localize(@"TEST_BEGAN", @"Root") UTF8String]); // Very sensitive calls, they might not work sometimes for whatever reason
	});
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
		// Force touch a random icon in visible icons
		SBFolderController *folderController = ((SBIconController *)[%c(SBIconController) sharedInstance])._currentFolderController;
		NSMutableArray *views = [folderController.currentIconListView.subviews mutableCopy];
		if (folderController.hasDock) {
			[views addObjectsFromArray:folderController.dockListView.subviews];
		}
		[views enumerateObjectsUsingBlock:^(UIView *view, NSUInteger index, BOOL *stop) {
			if (![view isKindOfClass:%c(SBIconView)] || [((SBIconView *)view).icon isKindOfClass:%c(SBFolderIcon)]) {
				[views removeObjectAtIndex:index];
			}
		}];
		SBIconView *iconView = views[arc4random_uniform(views.count)];
		[iconView.contextMenuInteraction _presentMenuAtLocation:CGPointZero];
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
			// Close force touch menu and open back Settings.app
			[[%c(SBIconController) sharedInstance] dismissAppIconForceTouchControllers:nil];
			dispatch_after(dispatch_time(DISPATCH_TIME_NOW, .75 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
				[[UIApplication sharedApplication] launchApplicationWithIdentifier:@"com.apple.Preferences" suspended:NO];
			});
		});
	});
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 6 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
		if (VEXILLARIUS_INSTALLED)
			showBanner([localize(@"TEST_ENDED", @"Root") UTF8String]);
	});
}

%ctor {
	dpkgInvalid = ![[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"/var/lib/dpkg/info/%@.list", TWEAK_BUNDLE_ID]];

	prefs = [HBPreferences preferencesForIdentifier:TWEAK_BUNDLE_ID];
	[prefs registerBool:&enabled default:YES forKey:@"enabled"];
	[prefs registerBool:&alertShown default:NO forKey:@"alertShown"];

	// Customization
	[prefs registerBool:&removeBeta default:NO forKey:@"removeBeta"]; // OK
	[prefs registerBool:&removeRearrange default:NO forKey:@"removeRearrange"]; // OK
	[prefs registerBool:&removeShare default:NO forKey:@"removeShare"]; // OK
	[prefs registerBool:&removeDelete default:NO forKey:@"removeDelete"]; // OK
	[prefs registerDouble:&cellHeight default:43.5 forKey:@"cellHeight"]; // FIXME: FIX IOS 14
	[prefs registerBool:&removeWidgets default:NO forKey:@"removeWidgets"];	// OK -> iOS 13 only!
	[prefs registerBool:&reverseOrder default:NO forKey:@"reverseOrder"]; // OK
	[prefs registerBool:&removeThinSeparators default:NO forKey:@"removeThinSeparators"]; // TODO: CHECK IOS 14
	[prefs registerBool:&removeBoldSeparators default:NO forKey:@"removeBoldSeparators"]; // TODO: CHECK IOS 14
	[prefs registerDouble:&cornerRadiusForMenu default:13 forKey:@"cornerRadiusForMenu"]; // TODO: do this for iOS≠13
	[prefs registerDouble:&cornerRadiusForItems default:0 forKey:@"cornerRadiusForItems"]; // TODO: do this for iOS≠13
	[prefs registerBool:&showStatusBar default:YES forKey:@"showStatusBar"]; // OK
	[prefs registerObject:&customBatteryText default:nil forKey:@"customBatteryText"]; // OK
	[prefs registerObject:&customBatterySubText default:nil forKey:@"customBatterySubText"]; // OK
	[prefs registerObject:&customCellularText default:nil forKey:@"customCellularText"]; // OK
	[prefs registerObject:&customCellularSubText default:nil forKey:@"customCellularSubText"]; // OK
	[prefs registerObject:&customWifiText default:nil forKey:@"customWifiText"]; // OK
	[prefs registerObject:&customWifiSubText default:nil forKey:@"customWifiSubText"]; // OK
	[prefs registerObject:&customBluetoothText default:nil forKey:@"customBluetoothText"];// OK
	[prefs registerObject:&customBluetoothSubText default:nil forKey:@"customBluetoothSubText"]; // OK

	// Coloring
	[prefs registerInteger:&forcedTheme default:0 forKey:@"forcedTheme"]; // OK -> iOS 13+ only!
	[prefs registerInteger:&itemsColorChoice default:0 forKey:@"itemsColorChoice"]; // OK
	[prefs registerObject:&itemsColor default:@"#ffffff" forKey:@"itemsColor"]; // OK
	[prefs registerBool:&enableCustomItemsBlur default:NO forKey:@"enableCustomItemsBlur"];	// OK
	[prefs registerDouble:&customItemsBlurAlpha default:1.0 forKey:@"customItemsBlurAlpha"]; // OK
	[prefs registerInteger:&menuColorChoice default:0 forKey:@"menuColorChoice"]; // OK
	[prefs registerObject:&menuColor default:@"#ffffff" forKey:@"menuColor"]; // OK
	[prefs registerBool:&enableCustomMenuBlur default:NO forKey:@"enableCustomMenuBlur"]; // OK
	[prefs registerDouble:&customMenuBlurAlpha default:0.5 forKey:@"customMenuBlurAlpha"];	// OK
	[prefs registerInteger:&backgroundColorChoice default:0 forKey:@"backgroundColorChoice"]; // OK
	[prefs registerObject:&backgroundColor default:@"#ffffff" forKey:@"backgroundColor"];	// OK
	[prefs registerBool:&enableCustomBackgroundBlur default:NO forKey:@"enableCustomBackgroundBlur"]; // OK
	[prefs registerDouble:&customBackgroundBlurAlpha default:0.21 forKey:@"customBackgroundBlurAlpha"]; // OK
	[prefs registerInteger:&labelsColorChoice default:0 forKey:@"labelsColorChoice"]; // OK
	[prefs registerObject:&labelsColor default:@"#ffffff" forKey:@"labelsColor"]; // OK

	CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("dev.redentic.sepiida/ReloadPrefs"), NULL, NULL, true);

	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)sepiida_testSetup, CFSTR("dev.redentic.sepiida/TestSetup"), NULL, CFNotificationSuspensionBehaviorCoalesce);

	utils = [SepiidaUtils sharedInstance];

	%init(DRM);
	if (enabled) {
		%init(COMMON);
		if (kCFCoreFoundationVersionNumber >= 1740.00) {
			%init(iOS_14);
		} else {
			%init(iOS_13);
		}
	}
}
