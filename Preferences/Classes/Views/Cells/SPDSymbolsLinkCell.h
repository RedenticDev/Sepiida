#import <Preferences/PSSpecifier.h>
#import <UIKit/UIKit.h>

@interface UIColor (Private)
+ (UIColor *)_systemColorWithName:(NSString *)arg1;
@end

@interface UIColor (SymbolsLinkCell)
+ (UIColor *)systemColorFromString:(NSString *)colorString;
+ (UIColor *)colorFromHexString:(NSString *)hex;
@end

@interface SPDSymbolsLinkCell: PSTableCell
@property (nonatomic, strong) UIImage *symbolsImage;
@end
