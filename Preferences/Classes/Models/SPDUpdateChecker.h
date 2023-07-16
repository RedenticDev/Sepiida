#import <UIKit/UIKit.h>

@interface NSString (VersionNumbers)
- (NSString *)shortenedVersionNumberString;
@end

@interface SPDUpdateChecker: NSObject
@property (nonatomic, strong) NSString *latestVersion;
+ (void)checkForUpdateForPackage:(NSString *)package withCompletion:(void (^)(BOOL isUpdateAvailable, NSString *newerVersion))completion;
+ (NSString *)currentVersionForPackage:(NSString *)package;
+ (BOOL)isVersion:(NSString *)versionA greaterThan:(NSString *)versionB;
@end

@interface SPDUpdateParser: NSObject <NSXMLParserDelegate>
@property (nonatomic, assign, readonly) BOOL shouldCapture;
@property (nonatomic, strong) NSString *latestVersion;
@end
