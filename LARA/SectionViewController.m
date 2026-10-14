#import "SectionViewController.h"
#import "Theme.h"
#import "DeviceInfo.h"
#import "CapabilityManager.h"

@interface SectionViewController ()

@property(nonatomic, copy) NSString *section;
@property(nonatomic, copy) NSString *sectionSubtitle;
@property(nonatomic, copy) NSString *symbol;

@end

@implementation SectionViewController

- (instancetype)initWithSection:(NSString *)section
                        subtitle:(NSString *)subtitle
                          symbol:(NSString *)symbol {
    self = [super init];

    if (self) {
        _section = [section copy];
        _sectionSubtitle = [subtitle copy];
        _symbol = [symbol copy];
        self.title = section;
    }

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = Theme.background;

    if (@available(iOS 13.0, *)) {
        UINavigationBarAppearance *appearance =
            [UINavigationBarAppearance new];

        [appearance configureWithDefaultBackground];
        appearance.backgroundColor = Theme.background;
        appearance.titleTextAttributes = @{
            NSForegroundColorAttributeName: Theme.text
        };

        self.navigationController.navigationBar.standardAppearance =
            appearance;
        self.navigationController.navigationBar.scrollEdgeAppearance =
            appearance;
    }

    self.navigationController.navigationBar.tintColor = Theme.accent;

    UIScrollView *scroll = [UIScrollView new];
    scroll.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:scroll];

    [NSLayoutConstraint activateConstraints:@[
        [scroll.topAnchor constraintEqualToAnchor:
            self.view.safeAreaLayoutGuide.topAnchor],
        [scroll.bottomAnchor constraintEqualToAnchor:
            self.view.bottomAnchor],
        [scroll.leadingAnchor constraintEqualToAnchor:
            self.view.leadingAnchor],
        [scroll.trailingAnchor constraintEqualToAnchor:
            self.view.trailingAnchor]
    ]];

    UIStackView *stack = [UIStackView new];
    stack.axis = UILayoutConstraintAxisVertical;
    stack.spacing = 16;
    stack.layoutMargins = UIEdgeInsetsMake(24, 20, 30, 20);
    stack.layoutMarginsRelativeArrangement = YES;
    stack.translatesAutoresizingMaskIntoConstraints = NO;

    [scroll addSubview:stack];

    [NSLayoutConstraint activateConstraints:@[
        [stack.topAnchor constraintEqualToAnchor:
            scroll.contentLayoutGuide.topAnchor],
        [stack.bottomAnchor constraintEqualToAnchor:
            scroll.contentLayoutGuide.bottomAnchor],
        [stack.leadingAnchor constraintEqualToAnchor:
            scroll.frameLayoutGuide.leadingAnchor],
        [stack.trailingAnchor constraintEqualToAnchor:
            scroll.frameLayoutGuide.trailingAnchor],
        [stack.widthAnchor constraintEqualToAnchor:
            scroll.frameLayoutGuide.widthAnchor]
    ]];

    UIImageView *icon = [[UIImageView alloc]
        initWithImage:[UIImage systemImageNamed:self.symbol]];

    icon.tintColor = Theme.accent;
    icon.contentMode = UIViewContentModeScaleAspectFit;
    [icon.heightAnchor constraintEqualToConstant:44].active = YES;
    [stack addArrangedSubview:icon];

    [stack addArrangedSubview:
        [Theme label:self.section
                size:29
              weight:UIFontWeightHeavy
               color:Theme.text]];

    [stack addArrangedSubview:
        [Theme label:self.sectionSubtitle
                size:14
              weight:UIFontWeightRegular
               color:Theme.muted]];

    if ([self.section isEqualToString:@"Modules"]) {
        [self buildResearchScreen:stack];
    } else if ([self.section isEqualToString:@"Diagnostics"]) {
        [self buildDiagnosticsScreen:stack];
    } else if ([self.section isEqualToString:@"Settings"]) {
        [self buildSettingsScreen:stack];
    } else if ([self.section isEqualToString:@"Explore"]) {
        [self buildExploreScreen:stack];
    } else {
        [self addCardTo:stack title:@"cha0s" lines:@[
            @"Experimental iOS research toolkit.",
            @"Research modules are not automatically executed.",
            @"No exploit chain has been verified."
        ]];
    }
}

#pragma mark - UI helpers

- (UIStackView *)newCardInStack:(UIStackView *)stack {
    UIView *card = [Theme card];

    UIStackView *content = [UIStackView new];
    content.axis = UILayoutConstraintAxisVertical;
    content.spacing = 12;
    content.layoutMargins = UIEdgeInsetsMake(18, 18, 18, 18);
    content.layoutMarginsRelativeArrangement = YES;
    content.translatesAutoresizingMaskIntoConstraints = NO;

    [card addSubview:content];

    [NSLayoutConstraint activateConstraints:@[
        [content.topAnchor constraintEqualToAnchor:card.topAnchor],
        [content.bottomAnchor constraintEqualToAnchor:card.bottomAnchor],
        [content.leadingAnchor constraintEqualToAnchor:card.leadingAnchor],
        [content.trailingAnchor constraintEqualToAnchor:card.trailingAnchor]
    ]];

    [stack addArrangedSubview:card];
    return content;
}

- (void)addCardTo:(UIStackView *)stack
           title:(NSString *)title
           lines:(NSArray<NSString *> *)lines {
    UIStackView *card = [self newCardInStack:stack];

    [card addArrangedSubview:
        [Theme label:title
                size:17
              weight:UIFontWeightBold
               color:Theme.text]];

    for (NSString *line in lines) {
        [card addArrangedSubview:
            [Theme label:line
                    size:13
                  weight:UIFontWeightRegular
                   color:Theme.muted]];
    }
}

- (void)addRecordTo:(UIStackView *)stack
                cve:(NSString *)cve
               area:(NSString *)area
               role:(NSString *)role
             source:(NSString *)source {

    UIStackView *card = [self newCardInStack:stack];

    [card addArrangedSubview:
        [Theme label:cve
                size:18
              weight:UIFontWeightBold
               color:Theme.accent]];

    [card addArrangedSubview:
        [Theme label:area
                size:13
              weight:UIFontWeightSemibold
               color:Theme.text]];

    [card addArrangedSubview:
        [Theme label:[NSString stringWithFormat:@"Proposed role: %@", role]
                size:13
              weight:UIFontWeightRegular
               color:Theme.text]];

    [card addArrangedSubview:
        [Theme label:@"Compatibility: UNKNOWN"
                size:13
              weight:UIFontWeightBold
               color:Theme.muted]];

    [card addArrangedSubview:
        [Theme label:@"The affected OS range and technical applicability have not been independently verified."
                size:12
              weight:UIFontWeightRegular
               color:Theme.muted]];

    UIButton *sourceButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [sourceButton setTitle:@"Open CVE reference" forState:UIControlStateNormal];
    sourceButton.contentHorizontalAlignment =
        UIControlContentHorizontalAlignmentLeft;
    sourceButton.titleLabel.font = [UIFont systemFontOfSize:13
                                                     weight:UIFontWeightSemibold];
    sourceButton.accessibilityHint =
        @"Opens the public CVE record in a browser.";

    objc_setAssociatedObject(
        sourceButton,
        "cha0sCVEURL",
        source,
        OBJC_ASSOCIATION_COPY_NONATOMIC
    );

    [sourceButton addTarget:self
                     action:@selector(openCVEReference:)
           forControlEvents:UIControlEventTouchUpInside];

    [card addArrangedSubview:sourceButton];
}

- (void)openCVEReference:(UIButton *)sender {
    NSString *urlString = objc_getAssociatedObject(sender, "cha0sCVEURL");

    NSURL *url = [NSURL URLWithString:urlString];

    if (url && [url.scheme isEqualToString:@"https"]) {
        [UIApplication.sharedApplication openURL:url
                                         options:@{}
                               completionHandler:nil];
    }
}

#pragma mark - CVE research

- (void)buildResearchScreen:(UIStackView *)stack {

    [self addCardTo:stack
              title:@"CVE Research"
              lines:@[
        @"Research records for the four proposed vulnerability identifiers.",
        @"These records are leads for investigation, not proof of exploitability."
    ]];

    [self addRecordTo:stack
                  cve:@"CVE-2026-84635"
                 area:@"WebKit"
                 role:@"Proposed entry point"
               source:@"https://nvd.nist.gov/vuln/detail/CVE-2026-84635"];

    [self addRecordTo:stack
                  cve:@"CVE-2026-43664"
                 area:@"Accessibility"
                 role:@"Proposed sandbox escape"
               source:@"https://nvd.nist.gov/vuln/detail/CVE-2026-43664"];

    [self addRecordTo:stack
                  cve:@"CVE-2026-65415"
                 area:@"Kernel"
                 role:@"Proposed kernel primitive"
               source:@"https://nvd.nist.gov/vuln/detail/CVE-2026-65415"];

    [self addRecordTo:stack
                  cve:@"CVE-2026-84566"
                 area:@"Kernel"
                 role:@"Proposed privilege escalation"
               source:@"https://nvd.nist.gov/vuln/detail/CVE-2026-84566"];

    [self addCardTo:stack
              title:@"Chain Assessment"
              lines:@[
        @"STATUS: UNVERIFIED",
        @"No stage is considered working merely because its CVE identifier exists.",
        @"The four vulnerabilities have not been demonstrated to form a compatible chain.",
        @"No vulnerability is triggered by this screen."
    ]];
}

#pragma mark - Device compatibility

- (void)buildDiagnosticsScreen:(UIStackView *)stack {

    NSString *machine = [DeviceInfo machine] ?: @"Unknown";
    NSString *version = [DeviceInfo systemVersion] ?: @"Unknown";
    NSString *build = [DeviceInfo systemBuild] ?: @"Unknown";

    [self addCardTo:stack
              title:@"Detected Device"
              lines:@[
        [NSString stringWithFormat:@"Hardware identifier: %@", machine],
        [NSString stringWithFormat:@"iOS version: %@", version],
        [NSString stringWithFormat:@"OS build: %@", build],
        @"The build number may be unavailable to an ordinary sandboxed app."
    ]];

    [self addCardTo:stack
              title:@"Compatibility Analysis"
              lines:@[
        @"CVE-2026-84635: UNKNOWN",
        @"CVE-2026-43664: UNKNOWN",
        @"CVE-2026-65415: UNKNOWN",
        @"CVE-2026-84566: UNKNOWN",
        @"Affected-version ranges have not yet been verified against authoritative records.",
        @"A matching version alone does not prove that a vulnerability is exploitable."
    ]];

    NSDictionary *capabilities = [CapabilityManager status];

    UIStackView *checks = [self newCardInStack:stack];

    [checks addArrangedSubview:
        [Theme label:@"Local Capability Checks"
                size:17
              weight:UIFontWeightBold
               color:Theme.text]];

    for (NSString *key in @[
        @"App sandbox",
        @"Documents write",
        @"Process UID",
        @"Elevated access",
        @"Exploit status"
    ]) {
        [checks addArrangedSubview:
            [Theme label:[NSString stringWithFormat:@"%@: %@",
                key, capabilities[key] ?: @"Unknown"]
                    size:13
                  weight:UIFontWeightRegular
                   color:Theme.muted]];
    }
}

#pragma mark - Explore

- (void)buildExploreScreen:(UIStackView *)stack {

    NSString *documents =
        NSSearchPathForDirectoriesInDomains(
            NSDocumentDirectory,
            NSUserDomainMask,
            YES
        ).firstObject ?: @"Unavailable";

    NSString *temporary = NSTemporaryDirectory() ?: @"Unavailable";

    [self addCardTo:stack
              title:@"Accessible Locations"
              lines:@[
        [NSString stringWithFormat:@"Documents:\n%@", documents],
        [NSString stringWithFormat:@"Temporary:\n%@", temporary],
        @"This explorer only reports locations available to the app."
    ]];
}

#pragma mark - Settings

- (void)buildSettingsScreen:(UIStackView *)stack {

    UIStackView *card = [self newCardInStack:stack];

    [card addArrangedSubview:
        [Theme label:@"Appearance"
                size:18
              weight:UIFontWeightBold
               color:Theme.text]];

    [card addArrangedSubview:
        [Theme label:@"Choose how cha0s looks."
                size:13
              weight:UIFontWeightRegular
               color:Theme.muted]];

    UISegmentedControl *selector =
        [[UISegmentedControl alloc]
            initWithItems:@[@"System", @"Light", @"Dark"]];

    NSString *mode = [[NSUserDefaults standardUserDefaults]
                      stringForKey:@"cha0sAppearanceMode"];

    selector.selectedSegmentIndex =
        [mode isEqualToString:@"light"] ? 1 :
        [mode isEqualToString:@"dark"] ? 2 : 0;

    [selector addTarget:self
                 action:@selector(appearanceChanged:)
       forControlEvents:UIControlEventValueChanged];

    [card addArrangedSubview:selector];

    [card addArrangedSubview:
        [Theme label:@"System follows your device setting. Your selection is saved."
                size:12
              weight:UIFontWeightRegular
               color:Theme.muted]];

    [self addCardTo:stack
              title:@"About cha0s"
              lines:@[
        @"Version 0.4.0 · Build 4",
        @"Experimental iOS research toolkit.",
        @"CVE compatibility is not proof of exploitability."
    ]];
}

- (void)appearanceChanged:(UISegmentedControl *)sender {

    NSString *mode =
        sender.selectedSegmentIndex == 1 ? @"light" :
        sender.selectedSegmentIndex == 2 ? @"dark" : @"system";

    [[NSUserDefaults standardUserDefaults]
        setObject:mode
           forKey:@"cha0sAppearanceMode"];

    UIUserInterfaceStyle style = UIUserInterfaceStyleUnspecified;

    if ([mode isEqualToString:@"light"]) {
        style = UIUserInterfaceStyleLight;
    } else if ([mode isEqualToString:@"dark"]) {
        style = UIUserInterfaceStyleDark;
    }

    id delegate = UIApplication.sharedApplication.delegate;

    if ([delegate respondsToSelector:@selector(window)]) {
        UIWindow *window = [delegate window];
        window.overrideUserInterfaceStyle = style;
    }
}

@end
