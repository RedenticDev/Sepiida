#import <UIKit/UIKit.h>

@interface UIViewController (Sepiida)
@property (nonatomic, assign, readwrite, setter=_setModalSourceViewController:) UIViewController *_modalSourceViewController;
@end

@interface OBButtonTray: UIView
- (void)addButton:(id)arg1;
- (void)addCaptionText:(id)arg1;
@end

@interface OBBoldTrayButton: UIButton
+ (id)buttonWithType:(NSInteger)arg1;
@end

@interface OBBulletedList: UIView
@property (nonatomic, retain) NSMutableArray *items;
- (void)addItemWithTitle:(id)arg1 description:(id)arg2 image:(id)arg3;
@end

@interface OBBulletedListItem: UIView
@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UILabel *descriptionLabel;
@property (nonatomic, retain) UIImageView *imageView;
@end

@interface OBWelcomeController: UIViewController
- (OBButtonTray *)buttonTray;
- (id)initWithTitle:(id)arg1 detailText:(id)arg2 icon:(id)arg3;
- (void)addBulletedListItemWithTitle:(id)arg1 description:(id)arg2 image:(id)arg3;
@end

@interface SPDWelcomeSheetController: OBWelcomeController
@property (nonatomic, copy) void (^completionBlock)();
- (instancetype)initWelcomeControllerWithTitle:(NSString *)title version:(NSString *)version itemsList:(OBBulletedList *)list;
- (void)dismissSheet;
@end
