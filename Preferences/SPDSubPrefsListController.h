#import <Cephei/HBRespringController.h>
#import <CepheiPrefs/HBListController.h>
#import <CepheiPrefs/HBPackageTableCell.h>
#import <Preferences/PSSpecifier.h>
#import <UIKit/UIKit.h>
#import "Classes/Views/HeaderViews/SPDChangelogHeaderCell.h"

#pragma mark - Private methods
@interface NSXMLParser (URLEncoding)
- (instancetype)sepiida_initWithContentsOfURL:(NSURL *)url encoding:(NSStringEncoding)encoding;
@end

@interface PSListController (Private)
- (BOOL)containsSpecifier:(PSSpecifier *)arg1;
@end

@interface PSSpecifier (Private)
+ (id)specifierWithSpecifier:(id)arg1;
@end

#pragma mark - Custom Classes
typedef enum SPDCompletionType: NSUInteger {
    SPDCompletionTypeSuccess,
    SPDCompletionTypeParsingError,
    SPDCompletionTypeFileNotFound,
    SPDCompletionTypeEmptyData
} SPDCompletionType;

@interface SPDXMLParserDelegate: NSObject <NSXMLParserDelegate> {
    NSMutableArray<NSDictionary<NSString *, NSArray<NSString *> *> *> *_tmpGlobalArray;
    NSMutableDictionary<NSString *, NSArray<NSString *> *> *_tmpDictionary;
    NSMutableArray<NSString *> *_tmpValuesArray;
    NSMutableString *_tmpDepiction;
    BOOL _isVersion;
    BOOL _isDescription;
    BOOL _shouldParseDepiction;
    NSMutableString *_tmpChangeLine;
}
@property (nonatomic, strong, readonly) NSDictionary<NSString *, id> *data;
@end

#pragma mark - Sub Prefs Controllers
@interface SPDSubPrefsListController: HBListController
- (void)respring:(UIBarButtonItem *)sender;
@end

@interface SPDDynamicSpecifiersPrefsListController: SPDSubPrefsListController
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSArray<PSSpecifier *> *> *dynamicSpecifiers;
@property (nonatomic, strong) NSMutableDictionary<NSString *, PSSpecifier *> *previous;
- (void)updateDynamicSpecifier:(PSSpecifier *)animated animated:(BOOL)animated;
- (void)updateDynamicSpecifiersAnimated:(BOOL)animated;
@end

@interface SPDMoreSubListController: SPDSubPrefsListController
@property (nonatomic, strong, readonly) NSArray<NSDictionary<NSString *, NSArray<NSString *> *> *> *changelog;
@property (nonatomic, strong, readonly) NSString *depiction;
@property (nonatomic, assign) NSInteger openSection; // -1 if none
@property (nonatomic, assign) SPDCompletionType completionType;
- (void)loadDataWithCompletion:(void (^)(SPDCompletionType completionType, NSDictionary *data))completion;
- (void)refreshPackages:(id)sender;
@end
