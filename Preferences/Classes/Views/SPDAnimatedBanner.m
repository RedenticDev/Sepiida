#import "SPDAnimatedBanner.h"

@implementation SPDAnimatedBanner

- (instancetype)initWithTitle:(NSString *)title subtitle:(NSString *)subtitle colors:(NSArray<__kindof UIColor *> *)colors defaultOffset:(CGFloat)defaultOffset {
    if (self = [super initWithFrame:CGRectMake(0, 0, self.superview.frame.size.width, 200)]) {
        // Labels
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.text = title;
        self.titleLabel.font = [UIFont boldSystemFontOfSize:42.f];
        self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [self.titleLabel sizeToFit];

        self.subtitleLabel = [[UILabel alloc] init];
        self.subtitleLabel.text = subtitle;
        self.subtitleLabel.font = [UIFont systemFontOfSize:24.f weight:UIFontWeightMedium];
        self.subtitleLabel.textColor = [UIColor secondaryLabelColor];
        self.subtitleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [self.subtitleLabel sizeToFit];

        // Create gradient
        self.gradient = [CAGradientLayer layer];
        self.gradient.frame = self.titleLabel.frame;
        self.cgcolors = [NSMutableArray new];
        for (int i = 0; i < colors.count; i++) {
            self.cgcolors[i] = (id)colors[i].CGColor;
        }
        self.gradient.colors = self.cgcolors;
        self.gradient.locations = @[@0, @1];

        self.gradientView = [[UIView alloc] init];
        [self.gradientView.layer addSublayer:self.gradient];
        self.gradientView.maskView = self.titleLabel;

        // Animations
        self.animations = [NSMutableArray new];

        CABasicAnimation *locations = [CABasicAnimation animationWithKeyPath:@"locations"];
        locations.fromValue = @[@0, @0];
        locations.toValue = @[@0, @1];
        locations.autoreverses = YES;
        locations.repeatCount = FLT_MAX;
        locations.duration = 5.0;
        [self.animations addObject:locations];

        CABasicAnimation *opacity = [CABasicAnimation animationWithKeyPath:@"opacity"];
        opacity.fromValue = @.75;
        opacity.toValue = @1;
        opacity.autoreverses = YES;
        opacity.repeatCount = FLT_MAX;
        opacity.duration = 3.0;
        [self.animations addObject:opacity];

        // Stack
        UIStackView *stackView = [[UIStackView alloc] initWithArrangedSubviews:@[self.gradientView, self.subtitleLabel]];
        stackView.alignment = UIStackViewAlignmentLeading;
        stackView.axis = UILayoutConstraintAxisVertical;
        stackView.distribution = UIStackViewDistributionEqualCentering;
        stackView.spacing = 0;
        stackView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:stackView];

        [NSLayoutConstraint activateConstraints:@[
            [stackView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:25],
            self.stackCenter = [stackView.centerYAnchor constraintEqualToAnchor:self.centerYAnchor constant:0],
            [stackView.heightAnchor constraintEqualToConstant:self.titleLabel.frame.size.height + self.subtitleLabel.frame.size.height],

            [self.gradientView.widthAnchor constraintEqualToConstant:self.titleLabel.frame.size.width],
            [self.gradientView.heightAnchor constraintEqualToConstant:self.titleLabel.frame.size.height]
        ]];

        self.defaultOffset = defaultOffset;
    }

    return self;
}

- (void)setActivateGradient:(BOOL)activated {
    _activateGradient = activated;

    // I would like to animate transition between activated and not but nvm
    if (activated) {
        self.gradient.colors = self.cgcolors;
        for (CAAnimation *animation in self.animations) {
            [self.gradient addAnimation:animation forKey:nil];
        }
    } else {
        self.gradient.colors = @[(id)[UIColor labelColor].CGColor, (id)[UIColor labelColor].CGColor];
        [self.gradient removeAllAnimations];
    }
}

- (void)adjustStackPositionToScrollOffset:(CGFloat)offset {
    // Smooth scroll effect
    if (offset < self.defaultOffset) {
        CGFloat space = self.defaultOffset - offset;
        self.stackCenter.constant = -space / 2;
    }
}

@end
