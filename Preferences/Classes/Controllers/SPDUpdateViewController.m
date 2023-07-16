#import "SPDUpdateViewController.h"

#pragma mark - Manager

@implementation SPDUpdateViewControllersManager

+ (SPDUpdateViewController *)updateViewControllerWithCurrentVersion:(NSString *)currentVersion latestVersion:(NSString *)latestVersion {
    if (@available(iOS 15.0, *)) {
        return [[SPDUpdateViewController alloc] initWithCurrentVersion:currentVersion latestVersion:latestVersion];
    } else {
        return [[SPDLegacyUpdateViewController alloc] initWithCurrentVersion:currentVersion latestVersion:latestVersion];
    }
}

@end

#pragma mark - Update Controllers

@implementation SPDUpdateViewController

- (instancetype)initWithCurrentVersion:(NSString *)currentVersion latestVersion:(NSString *)latestVersion {
    if (self = [super initWithStyle:UITableViewStyleInsetGrouped]) {
        self.currentVersion = currentVersion;
        self.latestVersion = latestVersion;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.navigationController setNavigationBarHidden:YES animated:NO];

    SPDUpdateViewControllerDelegate *delegate = [[SPDUpdateViewControllerDelegate alloc] init];
    delegate.sourceTableViewController = self;
    self.tableView.delegate = delegate;

    UILabel *updateMessage = [[UILabel alloc] init];
    updateMessage.text = localize(@"UPDATE_MESSAGE", @"Root");
    updateMessage.font = [UIFont boldSystemFontOfSize:22.f];
    updateMessage.textAlignment = NSTextAlignmentCenter;
    updateMessage.numberOfLines = 0;
    updateMessage.lineBreakMode = NSLineBreakByWordWrapping;
    [updateMessage sizeToFit];

    UILabel *updateDetail = [[UILabel alloc] init];
    updateDetail.text = [NSString stringWithFormat:localize(@"UPDATE_DETAIL", @"Root"), self.currentVersion, self.latestVersion];
    updateDetail.textAlignment = NSTextAlignmentCenter;
    updateDetail.numberOfLines = 0;
    updateDetail.lineBreakMode = NSLineBreakByWordWrapping;
    [updateDetail sizeToFit];

    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 150)];

    UIStackView *headerStack = [[UIStackView alloc] initWithArrangedSubviews:@[updateMessage, updateDetail]];
    headerStack.alignment = UIStackViewAlignmentCenter;
    headerStack.axis = UILayoutConstraintAxisVertical;
    headerStack.distribution = UIStackViewDistributionEqualCentering;
    headerStack.spacing = 0;
    headerStack.translatesAutoresizingMaskIntoConstraints = NO;
    [headerView addSubview:headerStack];

    [NSLayoutConstraint activateConstraints:@[
        [headerStack.centerXAnchor constraintEqualToAnchor:headerView.centerXAnchor constant:0],
        [headerStack.centerYAnchor constraintEqualToAnchor:headerView.centerYAnchor constant:0],
        [headerStack.heightAnchor constraintEqualToConstant:updateMessage.frame.size.height + updateDetail.frame.size.height]
    ]];

    self.tableView.tableHeaderView = headerView;
}

@end

@implementation SPDLegacyUpdateViewController

// https://stackoverflow.com/a/65519127/12070367
- (void)updateViewConstraints {
    self.view.frame = CGRectMake(self.view.frame.origin.x,
                                 self.view.frame.origin.y + (self.view.frame.size.height / 2),
                                 self.view.frame.size.width,
                                 self.view.frame.size.height / 2);
    UIBezierPath *cornersBezier = [UIBezierPath bezierPathWithRoundedRect:self.view.bounds
                                                        byRoundingCorners:UIRectCornerAllCorners
                                                              cornerRadii:CGSizeMake(16, 16)];
    CAShapeLayer *cornersLayer = [CAShapeLayer layer];
    cornersLayer.path = cornersBezier.CGPath;
    self.view.layer.mask = cornersLayer;

    [super updateViewConstraints];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    SPDUpdateViewControllerDelegate *delegate = [[SPDUpdateViewControllerDelegate alloc] init];
    delegate.sourceTableViewController = self;
    self.tableView.delegate = delegate;

    self.view.backgroundColor = [UIColor systemBackgroundColor];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    if (!self.movingToParentViewController) [self.view setNeedsUpdateConstraints];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [self.view setNeedsUpdateConstraints];
}

@end

#pragma mark - Package Managers Controllers

@implementation SPDPackageManagersViewController

- (instancetype)init {
    return self = [super initWithStyle:UITableViewStyleInsetGrouped];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    SPDPackageManagersViewControllerDelegate *delegate = [[SPDPackageManagersViewControllerDelegate alloc] init];
    delegate.sourceTableViewController = self;
    self.tableView.delegate = delegate;

    // Get installed apps
    NSMutableArray *allInstalledApps = [[NSMutableArray alloc] init];
    [[NSClassFromString(@"LSApplicationWorkspace") defaultWorkspace] enumerateApplicationsOfType:1 block:^(LSApplicationProxy *appProxy) {
        [allInstalledApps addObject:appProxy.applicationIdentifier];
    }];
    
    // Find installed package managers
    NSArray *packageManagers = @[ @"com.saurik.Cydia", @"xyz.willy.Zebra", @"org.coolstar.SileoStore", @"me.apptapp.installer" ];
    NSMutableArray *availableManagers = [NSMutableArray array];
    for (NSString *manager in packageManagers) {
        if ([allInstalledApps containsObject:manager]) {
            [availableManagers addObject:manager];
        }
    }

    // Export result
    self.availablePackageManagers = [availableManagers copy];
}

@end

@implementation SPDLegacyPackageManagersViewController

- (void)updateViewConstraints {
    self.view.frame = CGRectMake(self.view.frame.origin.x,
                                 self.view.frame.origin.y + (self.view.frame.size.height / 2),
                                 self.view.frame.size.width,
                                 self.view.frame.size.height / 2);
    UIBezierPath *cornersBezier = [UIBezierPath bezierPathWithRoundedRect:self.view.bounds
                                                        byRoundingCorners:UIRectCornerAllCorners
                                                              cornerRadii:CGSizeMake(16, 16)];
    CAShapeLayer *cornersLayer = [CAShapeLayer layer];
    cornersLayer.path = cornersBezier.CGPath;
    self.view.layer.mask = cornersLayer;

    [super updateViewConstraints];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    SPDPackageManagersViewControllerDelegate *delegate = [[SPDPackageManagersViewControllerDelegate alloc] init];
    delegate.sourceTableViewController = self;
    self.tableView.delegate = delegate;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.view setNeedsUpdateConstraints];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [self.view setNeedsUpdateConstraints];
}

@end

#pragma mark - Console View Controllers

/*
@implementation SPDConsoleViewController

- (instancetype)initWithCurrentVersion:(NSString *)currentVersion latestVersion:(NSString *)latestVersion {
    if (self = [super init]) {
        self.currentVersion = currentVersion;
        self.latestVersion = latestVersion;
    }
    return self;
}

- (void)updateViewConstraints {
    self.view.frame = CGRectMake(self.view.frame.origin.x,
                                 self.view.frame.origin.y + (self.view.frame.size.height / 2),
                                 self.view.frame.size.width,
                                 self.view.frame.size.height / 2);
    UIBezierPath *cornersBezier = [UIBezierPath bezierPathWithRoundedRect:self.view.bounds
                                                 byRoundingCorners:UIRectCornerAllCorners
                                                       cornerRadii:CGSizeMake(16, 16)];
    CAShapeLayer *cornersLayer = [CAShapeLayer layer];
    cornersLayer.path = cornersBezier.CGPath;
    self.view.layer.mask = cornersLayer;

    [super updateViewConstraints];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor systemBackgroundColor];
    self.modalInPresentation = YES;

    // Create console output
    self.console = [[UITextView alloc] initWithFrame:CGRectZero textContainer:nil];
    self.console.font = [UIFont monospacedSystemFontOfSize:14.f weight:UIFontWeightRegular];
    self.console.textColor = [UIColor whiteColor];
    self.console.backgroundColor = [UIColor blackColor];
    self.console.editable = NO;
    self.console.selectable = YES;
    self.console.textContainerInset = UIEdgeInsetsZero;
    self.console.textContainer.lineBreakMode = NSLineBreakByWordWrapping;
    self.console.translatesAutoresizingMaskIntoConstraints = NO;

    [self.view addSubview:self.console];

    [NSLayoutConstraint activateConstraints:@[
        [self.console.widthAnchor constraintEqualToAnchor:self.view.widthAnchor multiplier:1.0 constant:-50],
        [self.console.heightAnchor constraintEqualToAnchor:self.view.heightAnchor multiplier:1.0 constant:-100],
        [self.console.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor constant:0],
        [self.console.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:25]
    ]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    if (self.movingToParentViewController) [self.view setNeedsUpdateConstraints];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [self.view setNeedsUpdateConstraints];

    // Start process
    [self startDownload];
}

- (void)addTextToConsole:(NSString *)line withNewLine:(BOOL)newLine {
    self.console.text = [NSString stringWithFormat:@"%@%@%@", self.console.text, newLine ? @"\n" : @"", line];
    [self.console scrollRangeToVisible:NSMakeRange(self.console.text.length - 1, 1)];
}

- (void)startDownload {
    [self addTextToConsole:@"[*] Starting process..." withNewLine:YES];
    // Find file
    NSString *packageName = [NSString stringWithFormat:@"%@_%@_iphoneos-arm.deb", @"com.redenticdev.appmore", @"1.0.0"]; // TWEAK_BUNDLE_ID, self.latestVersion];
    NSString *downloadString = [NSString stringWithFormat:@"%@/debs/%@", REPO_URL, packageName];
    NSURL *downloadURL = [NSURL URLWithString:downloadString];
    // Check for URL reachability
    [self addTextToConsole:[@"[*] Remote file: " stringByAppendingString:downloadString] withNewLine:YES];
    __block BOOL isURLReachable = YES;
    [[[NSURLSession sharedSession] dataTaskWithURL:downloadURL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            isURLReachable = NO;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self addTextToConsole:[NSString stringWithFormat:@"[!] Error with the remote file (Error: %@)", error.localizedDescription] withNewLine:YES];
            });
        }
    }] resume];
    if (!isURLReachable) {
        [self terminateConsole];
        return;
    }
    // Download to /tmp
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:nil];
    [self addTextToConsole:[NSString stringWithFormat:@"[+] Downloading file '%@'...\n", packageName] withNewLine:YES];
    [[session downloadTaskWithURL:downloadURL] resume];
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    float progress = (double)totalBytesWritten / (double)totalBytesExpectedToWrite;

    dispatch_async(dispatch_get_main_queue(), ^{
        [self addTextToConsole:[NSString stringWithFormat:@"%d%%%@", (int)(progress * 100), progress >= 1 ? @"" : @"..."] withNewLine:NO];
    });
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    NSData *file = [NSData dataWithContentsOfURL:location];
    if ([file writeToFile:[NSString stringWithFormat:@"/tmp/%@_%@.deb", [TWEAK_NAME lowercaseString], self.latestVersion] atomically:NO]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self addTextToConsole:@"[*] File downloaded successfully" withNewLine:YES];
            [self installAndComplete];
        });
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self addTextToConsole:@"[!] Failed to write file in /tmp" withNewLine:YES];
            [self terminateConsole];
        });
    }
}

- (void)installAndComplete {
    NSString *filePath = [NSString stringWithFormat:@"/tmp/%@_%@.deb", [TWEAK_NAME lowercaseString], self.latestVersion];
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        [self addTextToConsole:@"[!] File not found" withNewLine:YES];
        [self terminateConsole];
        return;
    }
    // Install file
    [self addTextToConsole:@"[+] Installing update..." withNewLine:YES];
    NSPipe *pipe = [NSPipe pipe];
    NSFileHandle *file = pipe.fileHandleForReading;
    NSTask *installTask = [[NSTask alloc] init];
    installTask.launchPath = @"/usr/bin/dpkg";
    installTask.arguments = @[@"-i", filePath];
    installTask.standardOutput = pipe;
    int ret = [self executeTaskAsRoot:&installTask];
    if (ret != 0) {
        [self addTextToConsole:[NSString stringWithFormat:@"[!] Failed to install file (Error code: %d)", ret] withNewLine:YES];
        [self terminateConsole];
        return;
    }
    NSData *taskData = [file readDataToEndOfFile];
    NSString *taskOutput = [[NSString alloc] initWithData:taskData encoding:NSUTF8StringEncoding];
    [self addTextToConsole:taskOutput withNewLine:YES];
    
    // Delete temp file
    NSError *deleteError;
    if (![[NSFileManager defaultManager] removeItemAtPath:filePath error:&deleteError]) {
        [self addTextToConsole:[NSString stringWithFormat:@"[!] Failed to delete downloaded file (Error: %@)", deleteError.localizedDescription] withNewLine:YES];
        [self terminateConsole];
        return;
    } else {
        [self addTextToConsole:@"[-] Removed downloaded file successfully" withNewLine:YES];
    }

    // Warn, close and respring
    [self addTextToConsole:@"[*] Installing done, respringing in 5 seconds\n" withNewLine:YES];
    __block int duration = 5;
    [NSTimer scheduledTimerWithTimeInterval:1.0 repeats:YES block:^(NSTimer *timer) {
        if (duration == 0) {
            [timer invalidate];
            [HBRespringController respring];
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self addTextToConsole:[NSString stringWithFormat:@"%d...", duration + 1] withNewLine:NO];
            });
            duration--;
        }
    }];
}

- (NSInteger)executeTaskAsRoot:(NSTask **)task {
    if (![[NSProcessInfo processInfo].arguments[0] isEqualToString:@"/Applications/Preferences.app/Preferences"]
        || ![[UIApplication sharedApplication] isKindOfClass:NSClassFromString(@"PreferencesAppController")] ) {
        [self addTextToConsole:@"[-] Trying to use this maliciously?" withNewLine:YES];
        return -1; // little security
    }

    // Rootify
    // setuid(0);
    // setgid(0);

    if (getuid() != 0 || getgid() != 0) {
        [self addTextToConsole:@"[!] Failed to get root" withNewLine:YES];
        dlclose(handle);
        return -1;
    }

    // Execute task
    [*task launch];
    [*task waitUntilExit];

    // Back to mobile
    // setuid(501);
    // setgid(501);

    if (getuid() != 501 || getgid() != 501) {
        [self addTextToConsole:@"[!] Failed to get back to mobile" withNewLine:YES];
        dlclose(handle);
        return -1;
    }

    dlclose(handle);

    return [*task terminationStatus];
}

- (void)terminateConsole {
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *debPath = [NSString stringWithFormat:@"/tmp/%@_%@.deb", [TWEAK_NAME lowercaseString], self.latestVersion];
    if ([manager fileExistsAtPath:debPath]) {
        [manager removeItemAtPath:debPath error:nil];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
}

@end */

#pragma mark - Delegates

@implementation SPDUpdateViewControllerDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"update"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"update"];
        switch (indexPath.section) {
            case 0:
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                /* switch (indexPath.row) {
                    case 0:
                        cell.textLabel.text = localize(@"UPDATE_NOW", @"Root");
                        cell.textLabel.font = [UIFont boldSystemFontOfSize:cell.textLabel.font.pointSize];
                        break;
                    
                    case 1: */
                        cell.textLabel.text = localize(@"UPDATE_FROM", @"Root");
                        cell.imageView.image = [UIImage systemImageNamed:@"square.and.arrow.down"];
                        /* break;
                    
                    default:
                        break;
                } */
                break;
            
            case 1:
                cell.textLabel.textColor = [UIColor systemBlueColor];
                cell.textLabel.text = localize(@"UPDATE_LATER", @"Root");
                break;
            
            default:
                break;
        }
    }
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return /* section == 0 ? 2 : */ 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            /* switch (indexPath.row) {
                case 0:
                    [self.sourceTableViewController.navigationController pushViewController:[[SPDConsoleViewController alloc] initWithCurrentVersion:self.sourceTableViewController.currentVersion latestVersion:self.sourceTableViewController.latestVersion] animated:YES];
                    break;
                
                case 1: */
                    if (@available(iOS 15.0, *)) {
                        [self.sourceTableViewController.navigationController pushViewController:[[SPDPackageManagersViewController alloc] init] animated:YES];
                    } else {
                        [self.sourceTableViewController.navigationController pushViewController:[[SPDLegacyPackageManagersViewController alloc] init] animated:YES];
                    }
                    /* break;
                
                default:
                    break;
            } */
            break;
        
        case 1:
            [self.sourceTableViewController dismissViewControllerAnimated:YES completion:nil];
            break;
        
        default:
            break;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end

@implementation SPDPackageManagersViewControllerDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"managers"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"managers"];
        switch (indexPath.section) {
            case 0: {
                NSString *accessoryIcon;
                if (@available(iOS 14.0, *)) {
                    accessoryIcon = @"arrow.up.forward.app";
                } else {
                    accessoryIcon = @"arrowshape.turn.up.right";
                }
                cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage systemImageNamed:accessoryIcon]];

                NSString *managerIdentifier = self.sourceTableViewController.availablePackageManagers[indexPath.row];
                cell.textLabel.text = [NSClassFromString(@"LSApplicationProxy") applicationProxyForIdentifier:managerIdentifier].localizedName;
                cell.imageView.image = [UIImage _applicationIconImageForBundleIdentifier:managerIdentifier format:0 scale:[UIScreen mainScreen].scale];
                } break;
            
            case 1:
                cell.textLabel.text = localize(@"BACK", @"Root");
                cell.textLabel.textColor = [UIColor systemBlueColor];
                break;
            
            default:
                break;
        }
    }
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? self.sourceTableViewController.availablePackageManagers.count : 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0: {
            NSString *managerIdentifier = self.sourceTableViewController.availablePackageManagers[indexPath.row];
            // [[UIApplication sharedApplication] launchApplicationWithIdentifier:managerIdentifier suspended:NO];
            NSString *managerURL = nil;
            if ([managerIdentifier isEqualToString:@"com.saurik.Cydia"])
                managerURL = [NSString stringWithFormat:@"cydia://url/https://cydia.saurik.com/api/share#?source=%@&package=%@", REPO_URL, TWEAK_BUNDLE_ID];
            else if ([managerIdentifier isEqualToString:@"xyz.willy.Zebra"])
                managerURL = [NSString stringWithFormat:@"zbra://packages/%@?source=%@", TWEAK_BUNDLE_ID, REPO_URL];
            else if ([managerIdentifier isEqualToString:@"org.coolstar.SileoStore"])
                managerURL = [@"sileo://package/" stringByAppendingString:TWEAK_BUNDLE_ID];
            else if ([managerIdentifier isEqualToString:@"me.apptapp.installer"])
                managerURL = [NSString stringWithFormat:@"installer://show/shared=Installer&name=%@&bundleid=%@&repo=%@", TWEAK_NAME, TWEAK_BUNDLE_ID, REPO_URL];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:managerURL] options:@{} completionHandler:nil];
            [self.sourceTableViewController dismissViewControllerAnimated:YES completion:nil];
            } break;
        
        case 1:
            [self.sourceTableViewController.navigationController popViewControllerAnimated:YES];
            break;
        
        default:
            break;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
