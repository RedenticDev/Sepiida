// #import <Cephei/HBRespringController.h>
// #import "NSTask.h"
// #include <dlfcn.h>
#import <UIKit/UIKit.h>

#pragma mark - Imports

@interface LSApplicationWorkspace: NSObject
+ (instancetype)defaultWorkspace;
- (void)enumerateApplicationsOfType:(NSUInteger)type block:(id)block;
@end

@interface LSApplicationProxy: NSObject
+ (LSApplicationProxy *)applicationProxyForIdentifier:(NSString *)identifier;
@property (nonatomic, readonly, strong) NSString *applicationIdentifier;
@property (nonatomic, copy, readwrite, setter=_setLocalizedName:) NSString *localizedName; // from LSResourceProxy
@end

// @interface UIApplication (UpdateManager)
// - (BOOL)launchApplicationWithIdentifier:(NSString *)identifier suspended:(BOOL)suspended;
// @end

@interface UIImage (UpdateManager)
+ (instancetype)_applicationIconImageForBundleIdentifier:(NSString *)identifier format:(int)format scale:(CGFloat)scale;
@end

#pragma mark - Classes

@interface SPDUpdateViewController: UITableViewController
@property (nonatomic, strong) NSString *currentVersion;
@property (nonatomic, strong) NSString *latestVersion;
- (instancetype)initWithCurrentVersion:(NSString *)currentVersion latestVersion:(NSString *)latestVersion;
@end

@interface SPDLegacyUpdateViewController: SPDUpdateViewController
@end

@interface SPDUpdateViewControllersManager: NSObject
+ (SPDUpdateViewController *)updateViewControllerWithCurrentVersion:(NSString *)currentVersion latestVersion:(NSString *)latestVersion;
@end

@interface SPDPackageManagersViewController: UITableViewController
@property (nonatomic, strong) NSArray<NSString *> *availablePackageManagers;
@end

@interface SPDLegacyPackageManagersViewController: SPDPackageManagersViewController
@end

/*
@interface SPDConsoleViewController: UIViewController <NSURLSessionDownloadDelegate>
@property (nonatomic, strong) NSString *currentVersion;
@property (nonatomic, strong) NSString *latestVersion;
@property (nonatomic, strong) UITextView *console;
- (instancetype)initWithCurrentVersion:(NSString *)currentVersion latestVersion:(NSString *)latestVersion;
- (void)addTextToConsole:(NSString *)line withNewLine:(BOOL)newLine;
- (void)startDownload;
- (void)installAndComplete;
- (NSInteger)executeTaskAsRoot:(NSTask **)task;
- (void)terminateConsole;
@end
*/

#pragma mark - Delegates

@interface SPDUpdateViewControllerDelegate: NSObject <UITableViewDelegate>
@property (nonatomic, strong) SPDUpdateViewController *sourceTableViewController;
@end

@interface SPDPackageManagersViewControllerDelegate: NSObject <UITableViewDelegate>
@property (nonatomic, strong) SPDPackageManagersViewController *sourceTableViewController;
@end
