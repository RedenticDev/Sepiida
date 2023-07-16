#include <stdio.h>
#import <Cephei/HBPreferences.h>
#import <Cephei/HBRespringController.h>
#import <CepheiPrefs/HBRootListController.h>
#import <Preferences/PSSpecifier.h>
#import <Preferences/PSSwitchTableCell.h>
#import <UIKit/UIKit.h>
#import "Classes/Controllers/SPDUpdateViewController.h"
#import "Classes/Controllers/SPDWelcomeSheetController.h"
#import "Classes/Models/SPDUpdateChecker.h"
#import "Classes/Views/SPDAnimatedBanner.h"
#import "Classes/Views/SPDAnimatedTitleView.h"

@interface UIApplication (Sepiida)
- (BOOL)launchApplicationWithIdentifier:(NSString *)identifier suspended:(BOOL)suspended;
- (void)suspend;
@end

@interface SPDRootListController: HBRootListController
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *iconView;
- (NSString *)packageVersion;
- (void)refreshBanner;
- (void)testSetup:(PSSpecifier *)sender;
- (void)resetPreferences:(PSSpecifier *)sender;
- (void)respring:(UIBarButtonItem *)sender;
@end
