#import "SPDWelcomeSheetController.h"

@implementation SPDWelcomeSheetController

- (instancetype)initWelcomeControllerWithTitle:(NSString *)title version:(NSString *)version itemsList:(OBBulletedList *)list {
    NSString *detailText = [NSString stringWithFormat:localize(@"WHATS_NEW", @"Root"), version];
    UIImage *icon = [[UIImage imageWithContentsOfFile:[TWEAK_PREFS_BUNDLE stringByAppendingString:@"/icon-welcome.png"]] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    if ((self = [super initWithTitle:title detailText:detailText icon:icon])) {
        for (OBBulletedListItem *item in list.items) {
            [self addBulletedListItemWithTitle:item.titleLabel.text description:item.descriptionLabel.text image:item.imageView.image];
        }

        OBBoldTrayButton *continueButton = [OBBoldTrayButton buttonWithType:UIButtonTypeSystem];
        [continueButton setTitle:localize(@"CONTINUE", @"Root") forState:UIControlStateNormal];
        [continueButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        continueButton.clipsToBounds = YES;
        continueButton.layer.cornerRadius = 15;
        [continueButton addTarget:self action:@selector(dismissSheet) forControlEvents:UIControlEventPrimaryActionTriggered];

        [self.buttonTray addButton:continueButton];
        [self.buttonTray addCaptionText:[NSString stringWithFormat:localize(@"THX_FOR_USING", @"Root"), title]];

        self.modalInPresentation = YES;
    }
    return self;
}

- (void)dismissSheet {
    self.completionBlock();
}

@end
