#import "SPDLabeledSliderCell.h"

@implementation SPDLabeledSliderCell // Modified version of kritanta's KRLabeledSliderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier specifier:(PSSpecifier *)specifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier specifier:specifier]) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 12, 300, 20)];
        label.text = localize(specifier.properties[@"label"], specifier.properties[@"strings"] ?: @"Root");
        label.numberOfLines = 0;
        label.lineBreakMode = NSLineBreakByWordWrapping;
        [label sizeToFit];

        specifier.properties[@"height"] = @(label.frame.size.height + self.frame.size.height + 20);

        UIStackView *stackView = [[UIStackView alloc] initWithArrangedSubviews:@[label, self.control]];
        stackView.alignment = UIStackViewAlignmentFill;
        stackView.axis = UILayoutConstraintAxisVertical;
        stackView.distribution = UIStackViewDistributionEqualCentering;
        stackView.spacing = 0;
        stackView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:stackView];

        [NSLayoutConstraint activateConstraints:@[
            [stackView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:12],
            [stackView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:15],
            [stackView.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-15],
            [stackView.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-12]
        ]];
    }

    return self;
}

@end