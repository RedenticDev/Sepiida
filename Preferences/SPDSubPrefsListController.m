#import "SPDSubPrefsListController.h"

@implementation NSXMLParser (URLEncoding)

- (instancetype)sepiida_initWithContentsOfURL:(NSURL *)url encoding:(NSStringEncoding)encoding { // we can't expect apple to do all the work
    NSString *dataString = [NSString stringWithContentsOfURL:url encoding:encoding error:nil];
    return [self initWithData:[dataString dataUsingEncoding:encoding]];
}

@end

@implementation SPDXMLParserDelegate

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *, NSString *> *)attributeDict {
    // Depiction
    if ([elementName isEqualToString:@"descriptions"]) {
        _tmpDepiction = [NSMutableString string];
    } else if ([elementName isEqualToString:@"description"]) {
        _shouldParseDepiction = YES;
    // Changelog
    } else if ([elementName isEqualToString:@"changelog"]) {
        _tmpGlobalArray = [NSMutableArray array];
    } else if ([elementName isEqualToString:@"change"]) {
        _tmpDictionary = [NSMutableDictionary dictionary];
        _tmpValuesArray = [NSMutableArray array];
    } else if ([elementName isEqualToString:@"changeVersion"]) {
        _isVersion = YES;
    } else if ([elementName isEqualToString:@"changeDescription"]) {
        _isDescription = YES;
        _tmpChangeLine = [NSMutableString string];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    // Depiction
    if (_shouldParseDepiction) {
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^[ \\t]+|[ \\t]+$" options:NSRegularExpressionAnchorsMatchLines error:nil];
        [_tmpDepiction appendString:[regex stringByReplacingMatchesInString:string options:0 range:NSMakeRange(0, string.length) withTemplate:@""]];
    // Changelog
    } else if (_isVersion) {
        _tmpDictionary[string] = @[];
    } else if (_isDescription) {
        [_tmpChangeLine appendString:string];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    // Depiction
    if ([elementName isEqualToString:@"description"]) {
        _shouldParseDepiction = NO;
    // Changelog
    } else if ([elementName isEqualToString:@"changeVersion"]) {
        _isVersion = NO;
    } else if ([elementName isEqualToString:@"changeDescription"]) {
        [_tmpValuesArray addObject:[_tmpChangeLine copy]];
        _isDescription = NO;
    } else if ([elementName isEqualToString:@"change"]) {
        _tmpDictionary[[_tmpDictionary allKeys][0]] = [_tmpValuesArray copy];
        [_tmpGlobalArray addObject:[_tmpDictionary copy]];
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    CFStringTrimWhitespace((__bridge CFMutableStringRef) _tmpDepiction);
    _data = @{
        @"depiction": [_tmpDepiction copy],
        @"changelog": [_tmpGlobalArray copy]
    };
    _tmpDepiction = nil;
    _tmpGlobalArray = nil;
    _tmpDictionary = nil;
    _tmpValuesArray = nil;
}

@end

@implementation SPDSubPrefsListController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.table.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.table.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
}

- (void)setSpecifier:(PSSpecifier *)specifier {
    if (!_specifiers) {
        PSSpecifier *footerSpecifier = [PSSpecifier preferenceSpecifierNamed:nil target:nil set:nil get:nil detail:nil cell:PSGroupCell edit:nil];
        footerSpecifier.properties[@"footerText"] = [NSString stringWithFormat:localize(@"TWEAK_BY_AUTHOR", @"Root"), TWEAK_NAME, AUTHOR_NAME];
        footerSpecifier.properties[@"footerAlignment"] = @1;
        _specifiers = [[[self loadSpecifiersFromPlistName:[specifier propertyForKey:@"SPDSub"] target:self] arrayByAddingObject:footerSpecifier] copy];
    }

    static NSString *kNoButtonKey = @"respringButton";
    if ([specifier propertyForKey:kNoButtonKey] && ![[specifier propertyForKey:kNoButtonKey] boolValue]) {
        if (self.navigationItem.rightBarButtonItem) self.navigationItem.rightBarButtonItem = nil;
    } else {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"rays"] style:UIBarButtonItemStylePlain target:self action:@selector(respring:)];
    }

    [super setSpecifier:specifier];

    self.navigationItem.title = specifier.name;
}

- (void)setPreferenceValue:(id)value specifier:(PSSpecifier *)specifier {
    [super setPreferenceValue:value specifier:specifier];

    // Haptic SegmentCell
    if ([specifier.properties[@"cell"] isEqualToString:@"PSSegmentCell"]) {
        [[[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleLight] impactOccurred];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];

    // Haptic button
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    if ([cell isKindOfClass:[PSTableCell class]] && ((PSTableCell *)cell).type == 13) { // button
        [[[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleLight] impactOccurred];
    }
}

- (BOOL)shouldReloadSpecifiersOnResume {
    return NO;
}

- (void)respring:(UIBarButtonItem *)sender {
    [[[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleLight] impactOccurred];

	UIAlertController *respring = [UIAlertController alertControllerWithTitle:TWEAK_NAME message:localize(@"RESPRING_PROMPT", @"Root") preferredStyle:UIAlertControllerStyleAlert];

	[respring addAction:[UIAlertAction actionWithTitle:localize(@"YES_PROMPT", @"Root") style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
		// Animation block taken from Sileo respring animation
        UIWindow *window = [UIApplication sharedApplication].windows.firstObject;
        if (window) {
            [self setNeedsStatusBarAppearanceUpdate];
            UIViewPropertyAnimator *animator = [[UIViewPropertyAnimator alloc] initWithDuration:.3 dampingRatio:1 animations:^{
                window.alpha = 0;
                window.transform = CGAffineTransformMakeScale(.9, .9);
            }];
            [animator addCompletion:^(UIViewAnimatingPosition finalPosition) {
                [HBRespringController respring];
            }];
            [animator startAnimation];
        } else {
            [HBRespringController respring];
        }
	}]];
	[respring addAction:[UIAlertAction actionWithTitle:localize(@"NO_PROMPT", @"Root") style:UIAlertActionStyleCancel handler:nil]];

	[self presentViewController:respring animated:YES completion:nil];
}

@end

@implementation SPDDynamicSpecifiersPrefsListController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self updateDynamicSpecifiersAnimated:NO];
}

- (void)setSpecifier:(PSSpecifier *)specifier {
    [super setSpecifier:specifier];

    self.dynamicSpecifiers = self.dynamicSpecifiers ?: [[NSMutableDictionary alloc] init];
    self.previous = self.previous ?: [[NSMutableDictionary alloc] init];
    for (PSSpecifier *specifier in _specifiers) {
        NSString *ids = [specifier propertyForKey:@"id"];
        if (!ids || ![ids hasPrefix:@"ds"] || ![ids containsString:@"_"]) continue;
        NSString *parent = [ids componentsSeparatedByString:@"_"][0];
        if (self.dynamicSpecifiers[parent]) {
            self.dynamicSpecifiers[parent] = [self.dynamicSpecifiers[parent] arrayByAddingObject:specifier];
        } else {
            self.dynamicSpecifiers[parent] = @[specifier];
        }
        NSInteger index = [_specifiers indexOfObject:specifier];
        if (index > 0) {
            self.previous[[NSString stringWithFormat:@"%p", specifier]] = _specifiers[index - 1];
        }
    }
}

- (void)setPreferenceValue:(id)value specifier:(PSSpecifier *)specifier {
    [super setPreferenceValue:value specifier:specifier];

    [self updateDynamicSpecifier:specifier animated:YES];
}

- (void)reloadSpecifiers {
    [super reloadSpecifiers];

    [self updateDynamicSpecifiersAnimated:NO];
}

- (void)updateDynamicSpecifier:(PSSpecifier *)specifier animated:(BOOL)animated {
    if ([[self.dynamicSpecifiers allKeys] indexOfObject:[specifier propertyForKey:@"id"]] == NSNotFound) return;

    for (PSSpecifier *child in self.dynamicSpecifiers[[specifier propertyForKey:@"id"]]) {
        if (![child propertyForKey:@"visibleState"]) continue;
        if ([[child propertyForKey:@"visibleState"] integerValue] != [[self readPreferenceValue:specifier] integerValue]) {
            [self removeSpecifier:child animated:animated];
        } else if (![self containsSpecifier:child]) {
            [self insertSpecifier:child afterSpecifier:self.previous[[NSString stringWithFormat:@"%p", child]] animated:animated];
        }
    }
}

- (void)updateDynamicSpecifiersAnimated:(BOOL)animated {
    for (PSSpecifier *specifier in self.specifiers) {
        [self updateDynamicSpecifier:specifier animated:animated];
    }
}

@end

@implementation SPDMoreSubListController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.openSection = -1;
    self.completionType = -1;
    [self.table registerClass:[SPDChangelogHeaderCell class] forCellReuseIdentifier:@"headerCell"];

    [self loadDataWithCompletion:^(SPDCompletionType completionType, NSDictionary *data) {
        if (completionType == SPDCompletionTypeSuccess) {
            _depiction = data[@"depiction"];
            _changelog = data[@"changelog"];
        } else {
            _depiction = @"";
            _changelog = @[]; // differentiate 'loading error' from 'not yet loaded'
            self.completionType = completionType;
        }
        [self.table reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 2)] withRowAnimation:UITableViewRowAnimationAutomatic];
    }];
}

- (void)loadDataWithCompletion:(void (^)(SPDCompletionType completionType, NSDictionary *data))completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *xmlURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/depictions/%@/info.xml", REPO_URL, TWEAK_BUNDLE_ID]];
        [[[NSURLSession sharedSession] dataTaskWithURL:xmlURL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (!error) {
                NSXMLParser *parser = [[NSXMLParser alloc] sepiida_initWithContentsOfURL:xmlURL encoding:NSUTF8StringEncoding];
                parser.shouldProcessNamespaces = NO;
                parser.shouldReportNamespacePrefixes = NO;
                parser.shouldResolveExternalEntities = NO;

                SPDXMLParserDelegate *parserDelegate = [[SPDXMLParserDelegate alloc] init];
                parser.delegate = parserDelegate;
                if (![parser parse]) {
                    NSLog(@"An error occurred with input file '%@'", xmlURL.absoluteString);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (completion) completion(SPDCompletionTypeParsingError, nil);
                    });
                    return;
                }
                if (!parserDelegate.data || !parserDelegate.data[@"depiction"] || !parserDelegate.data[@"changelog"]) {
                    NSLog(@"An error occurred while parsing data (data = %@)", parserDelegate.data);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (completion) completion(SPDCompletionTypeEmptyData, nil);
                    });
                    return;
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (completion) completion(SPDCompletionTypeSuccess, parserDelegate.data);
                });
            } else {
                NSLog(@"Input file '%@' does not seem to be a valid URL. Does this changelog exist?", xmlURL.absoluteString);
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (completion) completion(SPDCompletionTypeFileNotFound, nil);
                });
            }
        }] resume];
    });
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
        if ([selectedCell isKindOfClass:[SPDChangelogHeaderCell class]]) {
            SPDChangelogHeaderCell *cell = (SPDChangelogHeaderCell *)selectedCell;
            NSUInteger section = cell.tag;

            self.openSection = self.openSection != section ? section : -1;

            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            [tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
        } else {
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
        }
    } else {
        [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    }
}

// Overrides to prevent crashes
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 || indexPath.section == 1) {
        return UITableViewAutomaticDimension;
    }
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 || indexPath.section == 1) {
        return 44;
    }
    return [super tableView:tableView estimatedHeightForRowAtIndexPath:indexPath];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 || indexPath.section == 1) {
        return NO;
    }
    return [super tableView:tableView canEditRowAtIndexPath:indexPath];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        if (!_changelog || _changelog.count == 0) {
            return 1;
        }

        // number of headers + number of cells in expanded section
        return _changelog.count + (self.openSection > -1 ? [_changelog[self.openSection] allValues][0].count : 0);
    }
    if (section == 1) {
        return 1;
    }
    return [super tableView:tableView numberOfRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (!_changelog) {
            return [super tableView:tableView cellForRowAtIndexPath:indexPath]; // prevents spinner to be replaced by error cell
        }
        if (_changelog.count == 0) {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            switch (self.completionType) {
                case SPDCompletionTypeParsingError:
                    cell.textLabel.text = localize(@"PARSING_ERROR", @"MoreSub");
                    break;
                case SPDCompletionTypeFileNotFound:
                    cell.textLabel.text = localize(@"NOT_FOUND_ERROR", @"MoreSub");
                    break;
                case SPDCompletionTypeEmptyData:
                    cell.textLabel.text = localize(@"EMPTY_DATA_ERROR", @"MoreSub");
                    break;
                default:
                    cell.textLabel.text = @"N/A";
                    break;
            }
            return cell;
        }

        // if no section open -> cell cannot be other than a header
        // if the row is BEFORE the open section index, it is a header
        // if the row is after the open section + the count of all its cells, it's a header
        if (self.openSection == -1 || indexPath.row <= self.openSection || indexPath.row > self.openSection + [_changelog[self.openSection] allValues][0].count) {
            // HEADER
            SPDChangelogHeaderCell *cell = (SPDChangelogHeaderCell *)[tableView dequeueReusableCellWithIdentifier:@"headerCell"];
            if (!cell) {
                cell = [[SPDChangelogHeaderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"headerCell"];
            }
            cell.tag = self.openSection > -1 && indexPath.row > self.openSection ? indexPath.row - [_changelog[self.openSection] allValues][0].count : indexPath.row; // section (skip indexes of open rows basically)
            cell.headerTitle.text = [_changelog[cell.tag] allKeys][0]; // version
            if (indexPath.row == self.openSection) {
                cell.headerTitle.font = [UIFont boldSystemFontOfSize:cell.headerTitle.font.pointSize];
                cell.collapseIcon.image = [UIImage systemImageNamed:@"chevron.up.circle"];
            } else {
                cell.headerTitle.font = [UIFont systemFontOfSize:cell.headerTitle.font.pointSize];
                cell.collapseIcon.image = [UIImage systemImageNamed:@"chevron.down.circle"];
            }
            return cell;
        } else {
            // CELL
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.textLabel.numberOfLines = 0;
            }
            cell.textLabel.text = [@"• " stringByAppendingString:[_changelog[self.openSection] allValues][0][indexPath.row - self.openSection - 1]];
            return cell;
        }
    }
    if (indexPath.section == 1) {
        if (!_depiction) {
            return [super tableView:tableView cellForRowAtIndexPath:indexPath]; // same thing
        }
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (_depiction.length == 0) {
            switch (self.completionType) {
                case SPDCompletionTypeParsingError:
                    cell.textLabel.text = localize(@"PARSING_ERROR", @"MoreSub");
                    break;
                case SPDCompletionTypeFileNotFound:
                    cell.textLabel.text = localize(@"NOT_FOUND_ERROR", @"MoreSub");
                    break;
                case SPDCompletionTypeEmptyData:
                    cell.textLabel.text = localize(@"EMPTY_DATA_ERROR", @"MoreSub");
                    break;
                default:
                    cell.textLabel.text = @"N/A";
                    break;
            }
        } else {
            cell.textLabel.text = _depiction;
            cell.textLabel.numberOfLines = 0;
        }
        return cell;
    }
    return [super tableView:tableView cellForRowAtIndexPath:indexPath];
}

#pragma mark - Bottom packages section
- (void)refreshPackages:(id)sender { // sender = UIButton
    static NSUInteger CELLS_COUNT = 3;
    UIButton *button;
    if (sender && [sender isKindOfClass:[UIButton class]]) {
        button = (UIButton *)sender;
    }

    // Haptic
    [[[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleLight] impactOccurred];
    // Disable button
    if (button) button.enabled = NO;
    // Get random different packages with Parcility
    NSURL *apiURL = [NSURL URLWithString:@"https://api.parcility.co/db/repo/redentic/packages"];
    [[[NSURLSession sharedSession] dataTaskWithURL:apiURL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error) {
            id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingFragmentsAllowed error:&error];

            NSMutableArray<NSString *> *packagesIdentifiers = [NSMutableArray array];
            NSMutableArray<NSDictionary *> *valuesDicts = [NSMutableArray array];
            @try { // Let's assume that everything's gonna work well
                NSDictionary *jsonData = (NSDictionary *)((NSDictionary *)json)[@"data"];
                // data.package_count
                NSInteger packagesCount = [jsonData[@"package_count"] integerValue];
                // data.packages[x].{Package,Description,Name}
                for (int index = 0; index < packagesCount; index++) {
                    // Package (identifier)
                    NSArray<NSDictionary *> *packages = (NSArray<NSDictionary *> *)jsonData[@"packages"];
                    [packagesIdentifiers addObject:(NSString *)packages[index][@"Package"]];
                    // Description & Name
                    [valuesDicts addObject:@{
                        @"Description": (NSString *)packages[index][@"Description"],
                        @"Name": (NSString *)packages[index][@"Name"]
                    }];
                }
            }
            @catch (NSException *exception) {
                NSLog(@"Error parsing data: %@", exception.reason);
            }
            // Randomize array order
            for (int i = packagesIdentifiers.count - 1; i > 0; i--) {
                NSInteger randomIndex = arc4random_uniform(i + 1);
                [packagesIdentifiers exchangeObjectAtIndex:i withObjectAtIndex:randomIndex];
                [valuesDicts exchangeObjectAtIndex:i withObjectAtIndex:randomIndex];
            }
            // Affect them to package_x cells and reload them
            // (Made for HBPackageTableCell)
            for (int i = 0; i < CELLS_COUNT; i++) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSString *specifierID = [NSString stringWithFormat:@"package_%d", i + 1];
                    PSSpecifier *baseSpecifier = [self specifierForID:specifierID];
                    PSSpecifier *newSpecifier = [PSSpecifier specifierWithSpecifier:baseSpecifier];
                    newSpecifier.name = valuesDicts[i][@"Name"];
                    newSpecifier.properties[@"id"] = specifierID;
                    newSpecifier.properties[@"label"] = valuesDicts[i][@"Name"];
                    newSpecifier.properties[@"subtitle"] = valuesDicts[i][@"Description"];
                    newSpecifier.properties[@"packageIdentifier"] = packagesIdentifiers[i];
                    [newSpecifier.properties removeObjectForKey:@"iconImage"];
                    [newSpecifier.properties removeObjectForKey:@"iconURL"];
                    newSpecifier.buttonAction = baseSpecifier.buttonAction;

                    int baseIndex = [self indexOfSpecifierID:specifierID];
                    [self removeSpecifierID:specifierID animated:YES];
                    [self insertSpecifier:newSpecifier atIndex:baseIndex animated:YES];
                    // FIXME: header disappearing because of these 2 lines (see Cephei bug #53)
                });
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [[[UINotificationFeedbackGenerator alloc] init] notificationOccurred:UINotificationFeedbackTypeSuccess];
            });
        } else {
            NSLog(@"Error fetching API to refresh packages (%@)", [response description]);
            dispatch_async(dispatch_get_main_queue(), ^{
                [[[UINotificationFeedbackGenerator alloc] init] notificationOccurred:UINotificationFeedbackTypeError];
            });
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            // Reenable button
            if (button) button.enabled = YES;
        });
    }] resume];
}

@end
