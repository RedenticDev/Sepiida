#import "SPDUpdateChecker.h"

@implementation NSString (VersionNumbers)

- (NSString *)shortenedVersionNumberString {
    static NSString *const unnecessaryVersionSuffix = @".0";
    NSString *shortenedVersionNumber = self;

    while ([shortenedVersionNumber hasSuffix:unnecessaryVersionSuffix]) {
        shortenedVersionNumber = [shortenedVersionNumber substringToIndex:shortenedVersionNumber.length - unnecessaryVersionSuffix.length];
    }

    return shortenedVersionNumber;
}

@end

@implementation SPDUpdateChecker
static NSString *_latestVersion;

+ (void)setLatestVersion:(NSString *)version {
    _latestVersion = version;
}

+ (NSString *)latestVersion {
    return _latestVersion;
}

+ (void)checkForUpdateForPackage:(NSString *)package withCompletion:(void (^)(BOOL isUpdateAvailable, NSString *newerVersion))completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"Checking for update...");
        // Check current version
        NSString *currentVersion = [SPDUpdateChecker currentVersionForPackage:package];
        // Check latest version
        NSURL *xmlURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/depictions/%@/info.xml", REPO_URL, package]];
        NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:xmlURL];
        parser.shouldProcessNamespaces = NO;
        parser.shouldReportNamespacePrefixes = NO;
        parser.shouldResolveExternalEntities = NO;
        SPDUpdateParser *updateParser = [[SPDUpdateParser alloc] init];
        parser.delegate = updateParser;
        if ([parser parse]) { // Shouldn't complete as should be aborted, thus return if completes
            NSLog(@"An error occurred while checking for update");
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) completion(NO, nil);
            });
            return;
        }
        // Compare and return
        self.latestVersion = updateParser.latestVersion;
        if (!self.latestVersion) {
            NSLog(@"An error occurred while checking for update");
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) completion(NO, nil);
            });
            return;
        }
        if ([SPDUpdateChecker isVersion:self.latestVersion greaterThan:currentVersion]) {
            NSLog(@"An update is available! %@ -> %@", currentVersion, self.latestVersion);
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) completion(YES, self.latestVersion);
            });
        } else {
            NSLog(@"No update available.");
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) completion(NO, nil);
            });
        }
    });
}

+ (NSString *)currentVersionForPackage:(NSString *)package {
    const char *cmd = [[NSString stringWithFormat:@"/usr/bin/dpkg -s %@ | grep Version | cut -d' ' -f2-", package] UTF8String];
    char ver[32];

    FILE *fp = popen(cmd, "r");
    fgets(ver, sizeof(ver), fp);
    pclose(fp);

    return [[NSString stringWithCString:ver encoding:NSUTF8StringEncoding] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

// https://stackoverflow.com/a/24811200/12070367
+ (BOOL)isVersion:(NSString *)versionA greaterThan:(NSString *)versionB {
    versionA = [versionA shortenedVersionNumberString];
    versionB = [versionB shortenedVersionNumberString];

    return [versionA compare:versionB options:NSNumericSearch] == NSOrderedDescending;
}

@end

@implementation SPDUpdateParser // Find the first packageInfo/changelog/change/changeVersion and return it

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *, NSString *> *)attributeDict {
    if ([elementName isEqualToString:@"changeVersion"]) {
        _shouldCapture = YES;
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if (_shouldCapture) {
        _latestVersion = [string stringByReplacingOccurrencesOfString:@"v" withString:@""];
        [parser abortParsing];
    }
}

@end
