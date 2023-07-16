#import <Cephei/HBPreferences.h>
#import "libcolorpicker.h"
#import "SepiidaUtils.h"
#import "SPDVexillarius.h"

#pragma mark - Interfaces
// COMMON
@interface LSApplicationProxy: NSObject
+ (LSApplicationProxy *)applicationProxyForIdentifier:(NSString *)identifier;
@property (nonatomic, copy, readwrite, setter=_setLocalizedName:) NSString *localizedName; // from LSResourceProxy
@end

// iOS 14
@interface _UIContextMenuActionsListView: UIView
@end

@interface _UIContextMenuActionsListSeparatorView: UIView
@end

@interface _UIElasticContextMenuBackgroundView: UIView
@end

// iOS 13
@interface CALayer (Sepiida)
@property (assign) BOOL continousCorners;
@end

@interface UIApplication (Sepiida)
- (BOOL)launchApplicationWithIdentifier:(NSString *)identifier suspended:(BOOL)suspended;
@end

@interface UIContextMenuInteraction (Sepiida)
- (void)_presentMenuAtLocation:(CGPoint)arg1;
@end

@interface UIView (Sepiida)
@property (nonatomic, assign, readwrite) NSInteger overrideUserInterfaceStyle;
- (UIViewController *)_viewControllerForAncestor;
@end

@interface _UIContextMenuActionView: UIView
@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UILabel *subtitleLabel;
@property (nonatomic, strong, readwrite) UIImageView *trailingImageView; // iOS 14
@property (nonatomic, retain) UIImageView *imageView; // iOS 13
@end

@interface _UIContextMenuContainerView: UIView
@end

@interface _UIDimmingKnockoutBackdropView: UIView
@end

@interface _UIInterfaceActionBlankSeparatorView: UIView
@end

@interface _UIInterfaceActionCustomViewRepresentationView: UIView
@end

@interface _UIInterfaceActionSeparatableSequenceView: UIView
@end

@interface _UIInterfaceActionVibrantSeparatorView: UIView
@end

@interface UIStatusBarForegroundView: UIView
@end

@interface _UIStatusBar: UIView
@property (nonatomic, strong) UIStatusBarForegroundView *foregroundView;
@end

@interface _UIVisualEffectBackdropView: UIView
@end

@interface SBIcon: NSObject
@end

@interface SBIconView: UIView
@property (nonatomic, readonly) NSString *applicationBundleIdentifierForShortcuts;
@property (nonatomic, readonly) UIImage *iconImageSnapshot;
@property (nonatomic, readonly) UIContextMenuInteraction *contextMenuInteraction API_AVAILABLE(ios(13.0));
@property (nonatomic, retain) SBIcon *icon;
- (void)dismissContextMenuWithCompletion:(/*^block*/id)arg1;
@end

@interface SBSApplicationShortcutItem: NSObject
@property (nonatomic, copy) NSString *localizedTitle;
@property (nonatomic, copy) NSString *localizedSubtitle;
@property (nonatomic, copy) NSString *type;
@end

@interface UIInterfaceActionGroupView: UIView
@end

// DRM & Test button
@interface SBIconListView: UIView
@end

@interface SBFolderController: UIViewController
@property (nonatomic, readonly) SBIconListView *currentIconListView;
@property (nonatomic, readonly) SBIconListView *dockListView;
@property (nonatomic, readonly) BOOL hasDock;
@end

@interface SBHomeScreenViewController: UIViewController
@end

@interface SBIconController: UIViewController
@property (getter=_currentFolderController, nonatomic, readonly) SBFolderController *currentFolderController;
+ (SBIconController *)sharedInstance;
- (void)dismissAppIconForceTouchControllers:(/*^block*/id)arg1;
- (void)_dismissAppIconForceTouchControllerIfNecessaryAnimated:(BOOL)arg1 withCompletionHandler:(/*^block*/id)arg2;
@end

#pragma mark - Preferences
// DRM
static BOOL alertShown = NO;
static BOOL dpkgInvalid = NO;

// Global prefs
static SepiidaUtils *utils;
static HBPreferences *prefs;
static BOOL enabled = YES;

// Customization
static BOOL removeBeta;
static BOOL removeRearrange;
static BOOL removeShare;
static BOOL removeDelete;
static double cellHeight = 43.5;
static BOOL removeWidgets;
static BOOL reverseOrder;
static BOOL removeThinSeparators;
static BOOL removeBoldSeparators;
static double cornerRadiusForMenu;
static double cornerRadiusForItems;
static BOOL showStatusBar = YES;
static NSString *customBatteryText;
static NSString *customBatterySubText;
static NSString *customCellularText;
static NSString *customCellularSubText;
static NSString *customWifiText;
static NSString *customWifiSubText;
static NSString *customBluetoothText;
static NSString *customBluetoothSubText;

// Coloring
static NSInteger forcedTheme;
static NSInteger itemsColorChoice;
static NSString *itemsColor;
static BOOL enableCustomItemsBlur;
static double customItemsBlurAlpha = 1.0;
static NSInteger menuColorChoice;
static NSString *menuColor;
static BOOL enableCustomMenuBlur;
static double customMenuBlurAlpha = 0.5;
static NSInteger backgroundColorChoice;
static NSString *backgroundColor;
static BOOL enableCustomBackgroundBlur;
static double customBackgroundBlurAlpha = 0.21;
static NSInteger labelsColorChoice;
static NSString *labelsColor;

// Icon cache
static UIImage *cachedIcon;

// Texts
static NSString *batteryBaseText;
static NSString *cellularBaseText;
static NSString *wifiBaseText;
static NSString *bluetoothBaseText;
