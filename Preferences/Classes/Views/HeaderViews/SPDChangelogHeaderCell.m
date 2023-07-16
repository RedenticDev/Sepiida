#import "SPDChangelogHeaderCell.h"

@implementation SPDChangelogHeaderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor systemGray3Color];

        // Label
        self.headerTitle = [[UILabel alloc] init];
        self.headerTitle.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:self.headerTitle];

        // Collapse icon
        self.collapseIcon = [[UIImageView alloc] init];
        self.collapseIcon.tintColor = [UIColor labelColor];
        self.collapseIcon.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:self.collapseIcon];

        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[title]-[icon]-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:@{ @"title": self.headerTitle, @"icon": self.collapseIcon }]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[title]-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:@{ @"title": self.headerTitle }]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[icon]-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:@{ @"icon": self.collapseIcon }]];
    }
    return self;
}

@end
