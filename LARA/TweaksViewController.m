#import "TweaksViewController.h"
#import "Theme.h"
#import <UIKit/UIKit.h>

@interface TweaksViewController () <UITextFieldDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIStackView *contentStack;
@property (nonatomic, strong) UITextField *searchField;
@property (nonatomic, strong) NSArray<NSDictionary *> *allFeatures;
@property (nonatomic, strong) NSArray<NSDictionary *> *visibleFeatures;

@end

@implementation TweaksViewController

#pragma mark - Feature Catalogue

- (NSArray<NSDictionary *> *)buildFeatureCatalogue {
    NSMutableArray *items = [NSMutableArray array];

#define ADD_FEATURE(CATEGORY, NAME, SUMMARY, STATUS, DETAILS) \
    [items addObject:@{ \
        @"category": CATEGORY, \
        @"name": NAME, \
        @"summary": SUMMARY, \
        @"status": STATUS, \
        @"details": DETAILS \
    }]

    // SYSTEM UTILITIES

    ADD_FEATURE(@"System Utilities",
                @"3-App Sideloading Limit",
                @"Install more apps with a free Apple Account.",
                @"Requires system-level capability",
                @"The normal free-account signing limit is enforced by Apple's signing and provisioning system. cha0s does not currently bypass this restriction.");

    ADD_FEATURE(@"System Utilities",
                @"Full Disk File Manager",
                @"Browse and manage files outside the app sandbox.",
                @"Requires system-level capability",
                @"A regular stock iOS app is sandboxed. Full filesystem access requires an appropriate vulnerability or privileged mechanism. This feature is not implemented.");

    ADD_FEATURE(@"System Utilities",
                @"MobileGestalt Editor",
                @"Inspect and customize supported device identity properties.",
                @"Requires system-level capability",
                @"MobileGestalt changes can affect feature availability and device behavior. A real implementation must identify the supported mechanism and provide a recovery path.");

    ADD_FEATURE(@"System Utilities",
                @"JIT Support",
                @"Enable Just-In-Time compilation for compatible apps.",
                @"Requires supported execution mechanism",
                @"JIT availability depends on the operating system, execution method, and target app. cha0s does not currently enable JIT.");

    ADD_FEATURE(@"System Utilities",
                @"Disable OTA Updates",
                @"Control system update notifications and update behavior.",
                @"Requires system configuration access",
                @"A normal app cannot freely change all system update settings. The exact supported method and its limitations must be established before implementation.");

    // HOME SCREEN

    ADD_FEATURE(@"Home Screen",
                @"Five-App Dock",
                @"Display five app icons in the Home Screen dock.",
                @"Requires SpringBoard modification",
                @"This changes the system Home Screen layout. A catalogue switch alone cannot change SpringBoard.");

    ADD_FEATURE(@"Home Screen",
                @"Floating iPad-Style Dock",
                @"Customize the dock's appearance and layout.",
                @"Requires SpringBoard modification",
                @"A system-level implementation is needed to change the actual dock.");

    ADD_FEATURE(@"Home Screen",
                @"Icon Grid & Spacing",
                @"Customize Home Screen rows, columns, spacing, and scale.",
                @"Requires SpringBoard modification",
                @"The available layout controls and supported values depend on the device and OS version.");

    ADD_FEATURE(@"Home Screen",
                @"Hide Icon Labels",
                @"Remove app names displayed beneath Home Screen icons.",
                @"Requires SpringBoard modification",
                @"The actual system icon labels must be changed; hiding labels inside cha0s would not achieve this.");

    ADD_FEATURE(@"Home Screen",
                @"Grid App Switcher",
                @"Explore an iPad-style grid for the app switcher.",
                @"Requires system UI modification",
                @"Changing the real app switcher requires a compatible system-level implementation.");

    ADD_FEATURE(@"Home Screen",
                @"Custom System Font",
                @"Use a custom font throughout supported system interfaces.",
                @"Requires system-level capability",
                @"Changing fonts inside cha0s is different from replacing the system font. System-wide support is not implemented.");

    // INTERACTION

    ADD_FEATURE(@"Interaction",
                @"Double-Tap to Lock",
                @"Lock the device by double-tapping an empty Home Screen area.",
                @"Requires system integration",
                @"An ordinary app cannot register a system-wide Home Screen gesture while it is in the background.");

    ADD_FEATURE(@"Interaction",
                @"Disable App Library",
                @"Remove the App Library page from the Home Screen.",
                @"Requires SpringBoard modification",
                @"This changes system Home Screen behavior and is not implemented.");

    ADD_FEATURE(@"Interaction",
                @"Disable Icon Fly-In",
                @"Change the icon animation displayed when unlocking.",
                @"Requires system UI modification",
                @"The real unlock animation is controlled by system components.");

    ADD_FEATURE(@"Interaction",
                @"Scrolling Physics",
                @"Customize scrolling momentum and animation behavior.",
                @"Requires system UI modification",
                @"System-wide scrolling physics cannot be changed merely by adjusting a setting in this app.");

    // DEVICE FEATURES

    ADD_FEATURE(@"Device Features",
                @"Dynamic Island",
                @"Explore Dynamic Island support on compatible devices.",
                @"Device- and OS-dependent",
                @"Enabling a Dynamic Island-like interface on unsupported hardware requires more than changing a device property. Actual functionality must be verified.");

    ADD_FEATURE(@"Device Features",
                @"Boot-Time Chime",
                @"Enable the startup sound on supported devices.",
                @"Device- and OS-dependent",
                @"This feature depends on hardware support and the system configuration mechanism available for the target version.");

    ADD_FEATURE(@"Device Features",
                @"Charge Limit",
                @"Explore supported battery charge-limit options.",
                @"Device- and OS-dependent",
                @"Battery charge-limit controls depend on hardware and OS support. cha0s does not currently change the device's charging behavior.");

    ADD_FEATURE(@"Device Features",
                @"Always-On Display",
                @"Explore Always-On Display support.",
                @"Hardware-dependent",
                @"Changing a feature flag does not create missing display hardware capabilities. Real support must be verified for each device.");

    ADD_FEATURE(@"Device Features",
                @"Camera Control",
                @"Explore Camera Control customization.",
                @"Hardware- and OS-dependent",
                @"This feature targets devices with compatible camera-control hardware and system support.");

    ADD_FEATURE(@"Device Features",
                @"Regional Restrictions",
                @"Explore supported regional feature settings.",
                @"Device- and OS-dependent",
                @"Regional behavior can depend on hardware, location, regulatory requirements, and system configuration. Not every restriction can be removed.");

    ADD_FEATURE(@"Device Features",
                @"iPad Multitasking",
                @"Explore additional multitasking layouts on compatible devices.",
                @"Device- and OS-dependent",
                @"Forcing iPad multitasking features onto an unsupported iPhone may require system modifications and can cause instability.");

    // STATUS BAR

    ADD_FEATURE(@"Status Bar",
                @"Custom Carrier Text",
                @"Customize the carrier label displayed in the status bar.",
                @"Requires system UI modification",
                @"Changing the real status-bar carrier text requires a compatible system-level mechanism.");

    ADD_FEATURE(@"Status Bar",
                @"Numeric Wi-Fi Strength",
                @"Display Wi-Fi signal strength as a numeric value.",
                @"Requires system UI modification",
                @"Reading signal information and presenting it in the actual system status bar are separate capabilities.");

    ADD_FEATURE(@"Status Bar",
                @"Hide Status Icons",
                @"Customize VPN, Focus, battery, alarm, location, and Bluetooth indicators.",
                @"Requires system UI modification",
                @"Each indicator may use different system components. Individual options will need separate compatibility checks.");

    ADD_FEATURE(@"Status Bar",
                @"Custom Battery Percentage",
                @"Customize the percentage text shown in the status bar.",
                @"Requires system UI modification",
                @"This is a display customization. It must not be confused with changing the device's actual battery capacity.");

    ADD_FEATURE(@"Status Bar",
                @"Firmware Build Display",
                @"Display the exact firmware build in the status bar.",
                @"Requires system UI modification",
                @"cha0s can inspect available version information within its own interface. Persistent status-bar integration is not implemented.");

    // LOCK SCREEN & BEHAVIOR

    ADD_FEATURE(@"Lock Screen",
                @"Custom Lock Screen Footnote",
                @"Display custom text on supported lock-screen layouts.",
                @"Requires system UI modification",
                @"Changing the actual system lock screen requires an appropriate mechanism.");

    ADD_FEATURE(@"Lock Screen",
                @"Supervision Text",
                @"Explore supported supervision and organization-label customization.",
                @"Requires system configuration access",
                @"This must not falsely represent a device as supervised or managed. Only legitimate, supported customization should be implemented.");

    ADD_FEATURE(@"System Behavior",
                @"Disable Low-Battery Alerts",
                @"Customize low-battery warning behavior.",
                @"Requires system UI modification",
                @"Suppressing system battery warnings is not available to a normal app through a simple preference.");

    ADD_FEATURE(@"System Behavior",
                @"Disable Charging Screen Dimming",
                @"Explore display behavior while the device is charging.",
                @"Requires system configuration access",
                @"An app can keep its own screen awake while active, but that does not disable system-wide dimming. A broader implementation needs a supported mechanism.");

    ADD_FEATURE(@"System Behavior",
                @"Remove Wallpaper Parallax",
                @"Disable wallpaper depth movement.",
                @"Requires system UI modification",
                @"Changing the system wallpaper effect requires a compatible system configuration mechanism.");

    // DEVELOPER FEATURES

    ADD_FEATURE(@"Developer",
                @"Metal HUD",
                @"Explore Apple's Metal performance overlay.",
                @"Requires supported system configuration",
                @"The overlay's availability depends on the OS and supported developer configuration. cha0s does not currently force it on globally.");

#undef ADD_FEATURE

    return items;
}

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Tweaks";
    self.view.backgroundColor = Theme.background;

    self.allFeatures = [self buildFeatureCatalogue];
    self.visibleFeatures = self.allFeatures;

    [self buildInterface];
    [self renderCatalogue];
}

#pragma mark - Interface

- (UILabel *)makeLabel:(NSString *)text
                  size:(CGFloat)size
                weight:(UIFontWeight)weight
                 color:(UIColor *)color {
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    label.font = [UIFont systemFontOfSize:size weight:weight];
    label.textColor = color;
    label.numberOfLines = 0;
    return label;
}

- (void)buildInterface {
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    self.scrollView.alwaysBounceVertical = YES;

    [self.view addSubview:self.scrollView];

    [NSLayoutConstraint activateConstraints:@[
        [self.scrollView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
        [self.scrollView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
        [self.scrollView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.scrollView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor]
    ]];

    self.contentStack = [[UIStackView alloc] init];
    self.contentStack.axis = UILayoutConstraintAxisVertical;
    self.contentStack.spacing = 18.0;
    self.contentStack.translatesAutoresizingMaskIntoConstraints = NO;

    [self.scrollView addSubview:self.contentStack];

    [NSLayoutConstraint activateConstraints:@[
        [self.contentStack.topAnchor constraintEqualToAnchor:self.scrollView.contentLayoutGuide.topAnchor constant:20.0],
        [self.contentStack.bottomAnchor constraintEqualToAnchor:self.scrollView.contentLayoutGuide.bottomAnchor constant:-30.0],
        [self.contentStack.leadingAnchor constraintEqualToAnchor:self.scrollView.frameLayoutGuide.leadingAnchor constant:18.0],
        [self.contentStack.trailingAnchor constraintEqualToAnchor:self.scrollView.frameLayoutGuide.trailingAnchor constant:-18.0]
    ]];

    UILabel *heading = [self makeLabel:@"Customize your device"
                                  size:28.0
                                weight:UIFontWeightBold
                                 color:Theme.text];

    UILabel *subtitle = [self makeLabel:
        @"Browse system, Home Screen, status-bar, and device features. Select any item to see its implementation status."
                                  size:14.0
                                weight:UIFontWeightRegular
                                 color:Theme.muted];

    [self.contentStack addArrangedSubview:heading];
    [self.contentStack addArrangedSubview:subtitle];

    self.searchField = [[UITextField alloc] init];
    self.searchField.translatesAutoresizingMaskIntoConstraints = NO;
    self.searchField.placeholder = @"Search tweaks";
    self.searchField.font = [UIFont systemFontOfSize:16.0];
    self.searchField.textColor = Theme.text;
    self.searchField.tintColor = Theme.accent;
    self.searchField.backgroundColor = Theme.panel;
    self.searchField.layer.cornerRadius = 12.0;
    self.searchField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.searchField.returnKeyType = UIReturnKeySearch;
    self.searchField.delegate = self;
    self.searchField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 12, 1)];
    self.searchField.leftViewMode = UITextFieldViewModeAlways;
    self.searchField.rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 1)];
    self.searchField.rightViewMode = UITextFieldViewModeAlways;
    self.searchField.accessibilityLabel = @"Search tweak catalogue";

    [self.contentStack addArrangedSubview:self.searchField];

    [self.searchField.heightAnchor constraintEqualToConstant:48.0].active = YES;

    [self.searchField addTarget:self
                         action:@selector(searchTextChanged:)
               forControlEvents:UIControlEventEditingChanged];

    UIView *notice = [Theme card];

    UIStackView *noticeStack = [[UIStackView alloc] init];
    noticeStack.axis = UILayoutConstraintAxisVertical;
    noticeStack.spacing = 6.0;
    noticeStack.translatesAutoresizingMaskIntoConstraints = NO;

    UILabel *noticeTitle = [self makeLabel:
        @"Compatibility matters"
                                  size:16.0
                                weight:UIFontWeightSemibold
                                 color:Theme.text];

    UILabel *noticeBody = [self makeLabel:
        @"These entries are a feature catalogue, not claims that every tweak already works. Each system modification needs a verified implementation for the device and OS. bad_query is limited to its supported iOS 26.0–26.6.1 range; iOS 27.0 final needs a separate mechanism."
                                  size:13.0
                                weight:UIFontWeightRegular
                                 color:Theme.muted];

    [noticeStack addArrangedSubview:noticeTitle];
    [noticeStack addArrangedSubview:noticeBody];

    [notice addSubview:noticeStack];

    [NSLayoutConstraint activateConstraints:@[
        [noticeStack.topAnchor constraintEqualToAnchor:notice.topAnchor constant:14.0],
        [noticeStack.bottomAnchor constraintEqualToAnchor:notice.bottomAnchor constant:-14.0],
        [noticeStack.leadingAnchor constraintEqualToAnchor:notice.leadingAnchor constant:14.0],
        [noticeStack.trailingAnchor constraintEqualToAnchor:notice.trailingAnchor constant:-14.0]
    ]];

    [self.contentStack addArrangedSubview:notice];
}

#pragma mark - Catalogue Rendering

- (void)renderCatalogue {
    for (UIView *view in [self.contentStack.arrangedSubviews copy]) {
        if (view.accessibilityIdentifier &&
            [view.accessibilityIdentifier isEqualToString:@"catalogue-section"]) {
            [self.contentStack removeArrangedSubview:view];
            [view removeFromSuperview];
        }
    }

    NSMutableArray<NSString *> *categories = [NSMutableArray array];

    for (NSDictionary *feature in self.visibleFeatures) {
        NSString *category = feature[@"category"];

        if (![categories containsObject:category]) {
            [categories addObject:category];
        }
    }

    if (self.visibleFeatures.count == 0) {
        UILabel *empty = [self makeLabel:
            @"No tweaks match your search."
                                      size:15.0
                                    weight:UIFontWeightMedium
                                     color:Theme.muted];

        empty.textAlignment = NSTextAlignmentCenter;
        empty.accessibilityIdentifier = @"catalogue-section";
        [self.contentStack addArrangedSubview:empty];
        return;
    }

    for (NSString *category in categories) {
        NSArray<NSDictionary *> *features =
            [self.visibleFeatures filteredArrayUsingPredicate:
             [NSPredicate predicateWithBlock:^BOOL(NSDictionary *feature, NSDictionary *bindings) {
            return [feature[@"category"] isEqualToString:category];
        }]];

        UIView *card = [Theme card];
        card.accessibilityIdentifier = @"catalogue-section";

        UIStackView *sectionStack = [[UIStackView alloc] init];
        sectionStack.axis = UILayoutConstraintAxisVertical;
        sectionStack.spacing = 0.0;
        sectionStack.translatesAutoresizingMaskIntoConstraints = NO;

        UILabel *categoryLabel = [self makeLabel:category
                                            size:19.0
                                          weight:UIFontWeightBold
                                           color:Theme.text];

        UIView *header = [[UIView alloc] init];
        [header addSubview:categoryLabel];
        categoryLabel.translatesAutoresizingMaskIntoConstraints = NO;

        [NSLayoutConstraint activateConstraints:@[
            [categoryLabel.topAnchor constraintEqualToAnchor:header.topAnchor constant:15.0],
            [categoryLabel.bottomAnchor constraintEqualToAnchor:header.bottomAnchor constant:-13.0],
            [categoryLabel.leadingAnchor constraintEqualToAnchor:header.leadingAnchor constant:15.0],
            [categoryLabel.trailingAnchor constraintEqualToAnchor:header.trailingAnchor constant:-15.0]
        ]];

        [sectionStack addArrangedSubview:header];

        for (NSDictionary *feature in features) {
            NSUInteger index = [self.visibleFeatures indexOfObject:feature];

            UIView *row = [self makeFeatureRow:feature index:index];
            [sectionStack addArrangedSubview:row];
        }

        [card addSubview:sectionStack];

        [NSLayoutConstraint activateConstraints:@[
            [sectionStack.topAnchor constraintEqualToAnchor:card.topAnchor],
            [sectionStack.bottomAnchor constraintEqualToAnchor:card.bottomAnchor],
            [sectionStack.leadingAnchor constraintEqualToAnchor:card.leadingAnchor],
            [sectionStack.trailingAnchor constraintEqualToAnchor:card.trailingAnchor]
        ]];

        [self.contentStack addArrangedSubview:card];
    }
}

- (UIView *)makeFeatureRow:(NSDictionary *)feature index:(NSUInteger)index {
    UIView *row = [[UIView alloc] init];
    row.tag = (NSInteger)index;
    row.backgroundColor = UIColor.clearColor;
    row.isAccessibilityElement = YES;
    row.accessibilityLabel = [NSString stringWithFormat:@"%@. %@",
                              feature[@"name"], feature[@"status"]];
    row.accessibilityHint = @"Double-tap to view feature details";
    row.accessibilityTraits = UIAccessibilityTraitButton;

    UITapGestureRecognizer *tap =
        [[UITapGestureRecognizer alloc] initWithTarget:self
                                                action:@selector(featureRowTapped:)];
    [row addGestureRecognizer:tap];

    UIStackView *textStack = [[UIStackView alloc] init];
    textStack.axis = UILayoutConstraintAxisVertical;
    textStack.spacing = 5.0;
    textStack.translatesAutoresizingMaskIntoConstraints = NO;
    textStack.userInteractionEnabled = NO;

    UILabel *nameLabel = [self makeLabel:feature[@"name"]
                                    size:15.0
                                  weight:UIFontWeightSemibold
                                   color:Theme.text];

    UILabel *summaryLabel = [self makeLabel:feature[@"summary"]
                                       size:12.5
                                     weight:UIFontWeightRegular
                                      color:Theme.muted];

    UILabel *statusLabel = [self makeLabel:feature[@"status"]
                                      size:11.5
                                    weight:UIFontWeightMedium
                                     color:Theme.accent];

    [textStack addArrangedSubview:nameLabel];
    [textStack addArrangedSubview:summaryLabel];
    [textStack addArrangedSubview:statusLabel];

    [row addSubview:textStack];

    [NSLayoutConstraint activateConstraints:@[
        [textStack.topAnchor constraintEqualToAnchor:row.topAnchor constant:12.0],
        [textStack.bottomAnchor constraintEqualToAnchor:row.bottomAnchor constant:-12.0],
        [textStack.leadingAnchor constraintEqualToAnchor:row.leadingAnchor constant:15.0],
        [textStack.trailingAnchor constraintEqualToAnchor:row.trailingAnchor constant:-15.0]
    ]];

    UIView *separator = [[UIView alloc] init];
    separator.backgroundColor = Theme.mutedColor ?: UIColor.separatorColor;
    separator.alpha = 0.2;
    separator.translatesAutoresizingMaskIntoConstraints = NO;

    [row addSubview:separator];

    [NSLayoutConstraint activateConstraints:@[
        [separator.heightAnchor constraintEqualToConstant:0.5],
        [separator.leadingAnchor constraintEqualToAnchor:row.leadingAnchor constant:15.0],
        [separator.trailingAnchor constraintEqualToAnchor:row.trailingAnchor constant:-15.0],
        [separator.bottomAnchor constraintEqualToAnchor:row.bottomAnchor]
    ]];

    return row;
}

#pragma mark - Search

- (void)searchTextChanged:(UITextField *)sender {
    NSString *query = [sender.text stringByTrimmingCharactersInSet:
                       NSCharacterSet.whitespaceAndNewlineCharacterSet];

    if (query.length == 0) {
        self.visibleFeatures = self.allFeatures;
    } else {
        NSPredicate *predicate =
            [NSPredicate predicateWithBlock:^BOOL(NSDictionary *feature, NSDictionary *bindings) {
            NSString *name = feature[@"name"];
            NSString *summary = feature[@"summary"];
            NSString *category = feature[@"category"];
            NSString *status = feature[@"status"];

            return [name localizedCaseInsensitiveContainsString:query] ||
                   [summary localizedCaseInsensitiveContainsString:query] ||
                   [category localizedCaseInsensitiveContainsString:query] ||
                   [status localizedCaseInsensitiveContainsString:query];
        }];

        self.visibleFeatures = [self.allFeatures filteredArrayUsingPredicate:predicate];
    }

    [self renderCatalogue];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Feature Details

- (void)featureRowTapped:(UITapGestureRecognizer *)gesture {
    NSInteger index = gesture.view.tag;

    if (index < 0 || index >= (NSInteger)self.visibleFeatures.count) {
        return;
    }

    NSDictionary *feature = self.visibleFeatures[(NSUInteger)index];

    NSString *message = [NSString stringWithFormat:
        @"%@\n\nStatus: %@\n\n%@\n\nTarget: stock iOS/iPadOS 26.0–26.6.1 and 27.0. Availability must be verified on each supported build.",
        feature[@"summary"],
        feature[@"status"],
        feature[@"details"]];

    UIAlertController *alert =
        [UIAlertController alertControllerWithTitle:feature[@"name"]
                                            message:message
                                     preferredStyle:UIAlertControllerStyleAlert];

    [alert addAction:
     [UIAlertAction actionWithTitle:@"OK"
                              style:UIAlertActionStyleDefault
                            handler:nil]];

    [self presentViewController:alert animated:YES completion:nil];
}

@end
