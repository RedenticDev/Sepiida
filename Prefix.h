#ifdef __OBJC__

#define AUTHOR_NAME @"Redentic"
#define REPO_URL @"https://redentic.dev"
#define TWEAK_NAME @"Sepiida"
#define TWEAK_BUNDLE_ID @"dev.redentic.sepiida"
#define TWEAK_BUNDLE_ID_VERSIONS @"dev.redentic.sepiida-versions"
#define TWEAK_PREFS_BUNDLE @"/Library/PreferenceBundles/SPDPrefs.bundle"
#define PREFS_PATH @"/var/mobile/Library/Preferences"
#define localize(key, file) NSLocalizedStringFromTableInBundle(key, file, [NSBundle bundleWithPath:TWEAK_PREFS_BUNDLE], nil)
#define FRAMEWORK(bundle) [[NSString stringWithFormat:@"/System/Library/Frameworks/%@.framework/%@", bundle, bundle] UTF8String]
#define PRIVATE_FRAMEWORK(bundle) [[NSString stringWithFormat:@"/System/Library/PrivateFrameworks/%@.framework/%@", bundle, bundle] UTF8String]

// #import <UIKit/UIKit.h>

#endif
