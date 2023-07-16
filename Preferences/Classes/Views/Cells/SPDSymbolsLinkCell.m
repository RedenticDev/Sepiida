#import "SPDSymbolsLinkCell.h"

@implementation UIColor (SymbolsLinkCell)

+ (UIColor *)systemColorFromString:(NSString *)colorString {
    NSString *finalColorString = [NSString stringWithFormat:@"system%@Color", [colorString capitalizedString]];

    SEL colorSelector = NSSelectorFromString(finalColorString);
    if ([UIColor respondsToSelector:colorSelector]) {
        return [UIColor performSelector:colorSelector];
    }

    return nil;
}

// https://stackoverflow.com/a/12397366/12070367
+ (UIColor *)colorFromHexString:(NSString *)hex {
    hex = [hex stringByReplacingOccurrencesOfString:@"#" withString:@""];
    NSCharacterSet *hexChars = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789ABCDEF"] invertedSet];
    if ([[hex uppercaseString] rangeOfCharacterFromSet:hexChars].location != NSNotFound) {
        NSLog(@"[%@] Argument is not a valid hexadecimal color, returning", NSStringFromSelector(_cmd));
        return nil;
    }

    unsigned intValue = 0;
    [[NSScanner scannerWithString:hex] scanHexInt:&intValue];
    return [UIColor colorWithRed:((intValue & 0xFF0000) >> 16) / 255.0
                           green:((intValue & 0xFF00) >> 8) / 255.0
                            blue:(intValue & 0xFF) / 255.0
                           alpha:1.0];
}

@end

@implementation SPDSymbolsLinkCell // TODO: remove (some) verbose

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier specifier:(PSSpecifier *)specifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier specifier:specifier]) {
        // Checking availability and presence of icon property
        if (!specifier.properties[@"icon"]) {
            NSLog(@"[%@ %p] No icon found, falling back to default behavior", NSStringFromClass(self.class), self);
            return self;
        }
        
        // Applying SF Symbol
        if (!(self.symbolsImage = [UIImage systemImageNamed:specifier.properties[@"icon"]])) {
            NSLog(@"[%@ %p] SF Symbol \"%@\" not found, falling back to default behavior", NSStringFromClass(self.class), self, specifier.properties[@"icon"]);
            return self;
        }

        CGFloat pointSize = specifier.properties[@"size"] ? [specifier.properties[@"size"] floatValue] : 29.f;

        // Setting custom weight if requested
        if (specifier.properties[@"weight"]) {
            NSString *weightString = [specifier.properties[@"weight"] lowercaseString];
            UIImageSymbolWeight weight;
            if ([weightString isEqualToString:@"ultralight"]) {
                weight = UIImageSymbolWeightUltraLight;
            } else if ([weightString isEqualToString:@"thin"]) {
                weight = UIImageSymbolWeightThin;
            } else if ([weightString isEqualToString:@"light"]) {
                weight = UIImageSymbolWeightLight;
            } else if ([weightString isEqualToString:@"regular"]) {
                weight = UIImageSymbolWeightRegular;
            } else if ([weightString isEqualToString:@"medium"]) {
                weight = UIImageSymbolWeightMedium;
            } else if ([weightString isEqualToString:@"semibold"]) {
                weight = UIImageSymbolWeightSemibold;
            } else if ([weightString isEqualToString:@"bold"]) {
                weight = UIImageSymbolWeightBold;
            } else if ([weightString isEqualToString:@"heavy"]) {
                weight = UIImageSymbolWeightHeavy;
            } else if ([weightString isEqualToString:@"black"]) {
                weight = UIImageSymbolWeightBlack;
            } else {
                weight = UIImageSymbolWeightUnspecified;
            }

            UIImageSymbolConfiguration *config = [UIImageSymbolConfiguration configurationWithPointSize:pointSize weight:weight scale:UIImageSymbolScaleSmall];
            self.symbolsImage = [self.symbolsImage imageWithConfiguration:config];
        } else {
            UIImageSymbolConfiguration *config = [UIImageSymbolConfiguration configurationWithPointSize:pointSize weight:UIImageSymbolWeightUnspecified scale:UIImageSymbolScaleSmall];
            self.symbolsImage = [self.symbolsImage imageWithConfiguration:config];
        }
        
        // Setting custom color if requested
        if (specifier.properties[@"color"]) {
            UIColor *finalColor = nil;

            NSString *stringColor = [specifier.properties[@"color"] lowercaseString];
            UIColor *lightColor = [UIColor systemColorFromString:stringColor] ?: [UIColor colorFromHexString:stringColor];
            if (lightColor) {
                if (specifier.properties[@"darkColor"]) {
                    NSString *stringDarkColor = [specifier.properties[@"darkColor"] lowercaseString];
                    UIColor *darkColor = [UIColor systemColorFromString:stringDarkColor] ?: [UIColor colorFromHexString:stringDarkColor];
                    finalColor = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
                        return traitCollection.userInterfaceStyle == UIUserInterfaceStyleLight ? lightColor : darkColor;
                    }];
                } else {
                    finalColor = lightColor;
                }
            }

            if (finalColor) {
                self.symbolsImage = [self.symbolsImage imageWithTintColor:finalColor renderingMode:UIImageRenderingModeAlwaysOriginal];
            } else {
                NSLog(@"[%@ %p] Error when changing color (color: %@, darkColor: %@)", NSStringFromClass(self.class), self, lightColor, [specifier.properties[@"darkColor"] lowercaseString]);
            }
        }
    }
    
    return self;
}

- (void)refreshCellContentsWithSpecifier:(PSSpecifier *)specifier {
    [super refreshCellContentsWithSpecifier:specifier];

    if (self.imageView && self.symbolsImage && self.imageView.image != self.symbolsImage) {
        self.imageView.image = self.symbolsImage;
    }
}

@end
