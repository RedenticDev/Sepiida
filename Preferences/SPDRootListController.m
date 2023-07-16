#import "SPDRootListController.h"

@implementation SPDRootListController

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Respring button
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"rays"] style:UIBarButtonItemStylePlain target:self action:@selector(respring:)];

    // Navigation bar title
    UIWindow *keyWindow;
    for (UIWindow *window in [UIApplication sharedApplication].windows) {
        if ([window isKeyWindow]) {
            keyWindow = window;
            break;
        }
    }
    CGFloat navbarOffset = (keyWindow ? keyWindow.windowScene.statusBarManager.statusBarFrame.size.height : 20) + self.navigationController.navigationBar.frame.size.height;
    self.navigationItem.titleView = [[SPDAnimatedTitleView alloc] initWithTitle:TWEAK_NAME image:[UIImage imageWithContentsOfFile:[TWEAK_PREFS_BUNDLE stringByAppendingString:@"/icon@2x.png"]] minimumScrollOffsetRequired:55 - navbarOffset];

    // Banner
    NSArray<UIColor *> *gradientColors = @[
        [UIColor colorWithRed:1. green:.53 blue:.63 alpha:1.], // pink
        [UIColor colorWithRed:1. green:.74 blue:.63 alpha:1.] // orange
    ];
    self.table.tableHeaderView = [[SPDAnimatedBanner alloc] initWithTitle:TWEAK_NAME subtitle:[@"v" stringByAppendingString:[self packageVersion]] colors:gradientColors defaultOffset:-navbarOffset];
    [self refreshBanner];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshBanner) name:UIApplicationDidBecomeActiveNotification object:nil];

    self.table.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.table.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;

    // iCleaner
    NSString *dylibPath = @"/Library/MobileSubstrate/DynamicLibraries/%@.%@";
    if ([[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:dylibPath, TWEAK_NAME, @"disabled"]]) {
        UIAlertController *iCleanerAlert = [UIAlertController alertControllerWithTitle:TWEAK_NAME message:localize(@"ICLEANER_MAIN_MESSAGE", @"Root") preferredStyle:UIAlertControllerStyleAlert];

        // Reactivate
        [iCleanerAlert addAction:[UIAlertAction actionWithTitle:localize(@"ICLEANER_REACTIVATE", @"Root") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            NSError *reenableError;
            BOOL moveState = [[NSFileManager defaultManager] moveItemAtPath:[NSString stringWithFormat:dylibPath, TWEAK_NAME, @"disabled"] toPath:[NSString stringWithFormat:dylibPath, TWEAK_NAME, @"dylib"] error:&reenableError];
            if (!moveState) {
                UIAlertController *moveErrorAlert = [UIAlertController alertControllerWithTitle:TWEAK_NAME message:[NSString stringWithFormat:localize(@"ICLEANER_REACTIVATE_ERROR", @"Root"), reenableError.localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
                if ([[NSFileManager defaultManager] fileExistsAtPath:@"/Applications/iCleaner.app"]) {
                    [moveErrorAlert addAction:[UIAlertAction actionWithTitle:localize(@"ICLEANER_REACTIVATE_OPEN", @"Root") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                        [[UIApplication sharedApplication] launchApplicationWithIdentifier:@"com.ivanobilenchi.icleaner" suspended:NO];
                    }]];
                }
                [moveErrorAlert addAction:[UIAlertAction actionWithTitle:localize(@"ICLEANER_REACTIVATE_LATER", @"Root") style:UIAlertActionStyleDefault handler:nil]];
                [self presentViewController:moveErrorAlert animated:YES completion:nil];
            }
        }]];

        // Back
        [iCleanerAlert addAction:[UIAlertAction actionWithTitle:localize(@"BACK", @"Root") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self.navigationController popViewControllerAnimated:YES];
        }]];

        // Ignore
        [iCleanerAlert addAction:[UIAlertAction actionWithTitle:localize(@"IGNORE", @"Root") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            PSSpecifier *enabledSpecifier;
            if ((enabledSpecifier = [self specifierForID:@"enabled"])) {
                PSSwitchTableCell *enabledCell = [enabledSpecifier propertyForKey:@"cellObject"];
                enabledCell.textLabel.enabled = NO;
                enabledCell.detailTextLabel.text = localize(@"ICLEANER_DISABLED_MESSAGE", @"Root");
                enabledCell.detailTextLabel.enabled = NO;
                enabledCell.control.enabled = NO;
            }
        }]];

        [self presentViewController:iCleanerAlert animated:YES completion:nil];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    if (!self.movingToParentViewController) [self refreshBanner];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    if (!self.movingToParentViewController) return;

    // Setting up welcome view. Doesn't show up if no changelog or if already shown for the version.
    HBPreferences *versionPrefs = [HBPreferences preferencesForIdentifier:TWEAK_BUNDLE_ID_VERSIONS];
    NSString *version = [self packageVersion];
    if (![versionPrefs boolForKey:version]) {
        NSError *error;
        NSDictionary *keysDict = [NSDictionary dictionaryWithContentsOfURL:[NSURL fileURLWithPath:[TWEAK_PREFS_BUNDLE stringByAppendingString:@"/Base.lproj/Changelog.strings"]] error:&error];
        if (error || [[keysDict allKeys] count] == 0) return;
        NSMutableArray *sortedChanges = [NSMutableArray new];
        for (NSString *key in [[keysDict allKeys] sortedArrayUsingSelector:@selector(compare:)]) {
            [sortedChanges addObject:localize(key, @"Changelog")];
        }

        OBBulletedList *bulletedList = [[OBBulletedList alloc] init];
        for (int i = 0; i < sortedChanges.count - 2; i += 3) {
            NSString *icon = [sortedChanges[i] lowercaseString];
            if ([icon isEqualToString:@"new"]) {
                icon = @"plus.circle.fill";
            } else if ([icon isEqualToString:@"fix"]) {
                icon = @"checkmark.circle.fill";
            } else if ([icon isEqualToString:@"removed"]) {
                icon = @"minus.circle";
            }
            NSString *title = sortedChanges[i + 1];
            NSString *content = sortedChanges[i + 2];
            [bulletedList addItemWithTitle:title description:content image:[UIImage systemImageNamed:icon]];
        }

        SPDWelcomeSheetController *welcomeController = [[SPDWelcomeSheetController alloc] initWelcomeControllerWithTitle:TWEAK_NAME version:version itemsList:bulletedList];
        __weak SPDWelcomeSheetController *weakWelcomeController = welcomeController;
        welcomeController.completionBlock = ^{
            [weakWelcomeController dismissViewControllerAnimated:YES completion:nil];

            [SPDUpdateChecker checkForUpdateForPackage:TWEAK_BUNDLE_ID withCompletion:^(BOOL isUpdateAvailable, NSString *newerVersion) {
                if (isUpdateAvailable) {
                    UIViewController *updateController = [SPDUpdateViewControllersManager updateViewControllerWithCurrentVersion:version latestVersion:newerVersion];
                    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:updateController];
                    /*if (@available(iOS 15.0, *)) {
                        if (navigationController.sheetPresentationController) {
                            UISheetPresentationController *sheetPresentationController = navigationController.sheetPresentationController;
                            sheetPresentationController.detents = @[[UISheetPresentationControllerDetent mediumDetent]];
                            sheetPresentationController.prefersScrollingExpandsWhenScrolledToEdge = NO;
                        }
                    }*/
                    [self presentViewController:navigationController animated:YES completion:nil];
                }
            }];
        };
        [self presentViewController:welcomeController animated:YES completion:nil];

        [versionPrefs setBool:YES forKey:version];
    } else {
        // Present update view
        [SPDUpdateChecker checkForUpdateForPackage:TWEAK_BUNDLE_ID withCompletion:^(BOOL isUpdateAvailable, NSString *newerVersion) {
            if (isUpdateAvailable) {
                UIViewController *updateController = [SPDUpdateViewControllersManager updateViewControllerWithCurrentVersion:version latestVersion:newerVersion];
                UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:updateController];
                /*if (@available(iOS 15.0, *)) {
                    if (navigationController.sheetPresentationController) {
                        UISheetPresentationController *sheetPresentationController = navigationController.sheetPresentationController;
                        sheetPresentationController.detents = @[[UISheetPresentationControllerDetent mediumDetent]];
                        sheetPresentationController.prefersScrollingExpandsWhenScrolledToEdge = NO;
                    }
                }*/
                [self presentViewController:navigationController animated:YES completion:nil];
            }
        }];
    }
}

#pragma mark - PSViewController

- (void)setPreferenceValue:(id)value specifier:(PSSpecifier *)specifier {
    [super setPreferenceValue:value specifier:specifier];

    if ([specifier.properties[@"cell"] isEqualToString:@"PSSegmentCell"]) { // Haptic SegmentCell
        [[[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleLight] impactOccurred];
    } else if ([specifier.properties[@"key"] isEqualToString:@"enabled"] && [self.table.tableHeaderView isKindOfClass:[SPDAnimatedBanner class]]) {
        ((SPDAnimatedBanner *)self.table.tableHeaderView).activateGradient = [value boolValue];
    }
}

#pragma mark - PSListController

- (NSArray *)specifiers {
	if (!_specifiers) {
        PSSpecifier *footerSpecifier = [PSSpecifier preferenceSpecifierNamed:nil target:nil set:nil get:nil detail:nil cell:PSGroupCell edit:nil];
        footerSpecifier.properties[@"footerText"] = [NSString stringWithFormat:localize(@"TWEAK_BY_AUTHOR", @"Root"), TWEAK_NAME, AUTHOR_NAME];
        footerSpecifier.properties[@"footerAlignment"] = @1;
        _specifiers = [[[self loadSpecifiersFromPlistName:@"Root" target:self] arrayByAddingObject:footerSpecifier] copy];
    }
	return _specifiers;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];

    // Haptic button
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    if ([cell isKindOfClass:[PSTableCell class]] && ((PSTableCell *)cell).type == 13) { // button
        [[[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleLight] impactOccurred];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([self.navigationItem.titleView isKindOfClass:[SPDAnimatedTitleView class]]) {
        [(SPDAnimatedTitleView *)self.navigationItem.titleView adjustItemsPositionToScrollOffset:scrollView.contentOffset.y];
    }
    if ([self.table.tableHeaderView isKindOfClass:[SPDAnimatedBanner class]]) {
        [(SPDAnimatedBanner *)self.table.tableHeaderView adjustStackPositionToScrollOffset:scrollView.contentOffset.y];
    }
}

#pragma mark - Custom methods

- (NSString *)packageVersion {
    const char *cmd = [[NSString stringWithFormat:@"/usr/bin/dpkg -s %@ | grep Version | cut -d' ' -f2-", TWEAK_BUNDLE_ID] UTF8String];
    char ver[32];

    FILE *fp = popen(cmd, "r");
    fgets(ver, sizeof(ver), fp);
    pclose(fp);

    return [[NSString stringWithCString:ver encoding:NSUTF8StringEncoding] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (void)refreshBanner {
    if ([self.table.tableHeaderView isKindOfClass:[SPDAnimatedBanner class]]) {
        HBPreferences *prefs = [HBPreferences preferencesForIdentifier:TWEAK_BUNDLE_ID];
        ((SPDAnimatedBanner *)self.table.tableHeaderView).activateGradient = [prefs boolForKey:@"enabled" default:YES];
    }
}

- (void)testSetup:(PSSpecifier *)sender {
    CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("dev.redentic.sepiida/TestSetup"), NULL, NULL, true);
    [[UIApplication sharedApplication] suspend];
}

- (void)resetPreferences:(PSSpecifier *)sender {
    HBPreferences *prefsToReset = [HBPreferences preferencesForIdentifier:TWEAK_BUNDLE_ID];
    [prefsToReset removeAllObjects];
    for (PSSpecifier *spec in [self specifiers]) {
        if (![spec isKindOfClass:NSClassFromString(@"HBTwitterCell")]) { // avoid Twitter cell flickering on reload
            [self reloadSpecifier:spec animated:YES];
        }
    }
}

- (void)respring:(UIBarButtonItem *)sender {
    [[[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleLight] impactOccurred];

	UIAlertController *respring = [UIAlertController alertControllerWithTitle:localize(@"RESPRING", @"Root") message:localize(@"RESPRING_PROMPT", @"Root") preferredStyle:UIAlertControllerStyleAlert];

	[respring addAction:[UIAlertAction actionWithTitle:localize(@"YES_PROMPT", @"Root") style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        // Animation block taken from Sileo respring animation
        UIWindow *window = [UIApplication sharedApplication].windows.firstObject;
        if (window) {
            [self setNeedsStatusBarAppearanceUpdate];
            UIViewPropertyAnimator *animator = [[UIViewPropertyAnimator alloc] initWithDuration:.3 dampingRatio:1 animations:^{
                window.alpha = 0;
                window.transform = CGAffineTransformMakeScale(.9, .9);
            }];
            [animator addCompletion:^(UIViewAnimatingPosition finalPosition) {
                [HBRespringController respring];
            }];
            [animator startAnimation];
        } else {
            [HBRespringController respring];
        }
	}]];
	[respring addAction:[UIAlertAction actionWithTitle:localize(@"NO_PROMPT", @"Root") style:UIAlertActionStyleCancel handler:nil]];

	[self presentViewController:respring animated:YES completion:nil];
}

@end
