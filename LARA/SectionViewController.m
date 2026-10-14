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

    if ((self = [super init])) {
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

    UINavigationBarAppearance *navigationAppearance =
        [UINavigationBarAppearance new];

    [navigationAppearance configureWithDefaultBackground];
    navigationAppearance.backgroundColor = Theme.background;
    navigationAppearance.titleTextAttributes = @{
        NSForegroundColorAttributeName: Theme.text
    };

    self.navigationController.navigationBar.standardAppearance =
        navigationAppearance;

    self.navigationController.navigationBar.scrollEdgeAppearance =
        navigationAppearance;

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
    [icon.heightAnchor constraintEqualToConstant:48].active = YES;

    [stack addArrangedSubview:icon];

    [stack addArrangedSubview:
        [Theme label:self.section
                size:30
              weight:UIFontWeightHeavy
               color:Theme.text]];

    [stack addArrangedSubview:
        [Theme label:self.sectionSubtitle
                size:15
              weight:UIFontWeightRegular
               color:Theme.muted]];

    UIView *card = [Theme card];

    UIStackView *details = [UIStackView new];
    details.axis = UILayoutConstraintAxisVertical;
    details.spacing = 13;
    details.translatesAutoresizingMaskIntoConstraints = NO;

    [card addSubview:details];

    [NSLayoutConstraint activateConstraints:@[
        [details.topAnchor constraintEqualToAnchor:
            card.topAnchor constant:18],
        [details.bottomAnchor constraintEqualToAnchor:
            card.bottomAnchor constant:-18],
        [details.leadingAnchor constraintEqualToAnchor:
            card.leadingAnchor constant:18],
        [details.trailingAnchor constraintEqualToAnchor:
            card.trailingAnchor constant:-18]
    ]];

    if ([self.section isEqualToString:@"Modules"]) {

        [details addArrangedSubview:
            [Theme label:@"CVE Research"
                    size:21
                  weight:UIFontWeightBold
                   color:Theme.text]];

        [details addArrangedSubview:
            [Theme label:@"Research records are informational. No exploits are executed by these modules."
                    size:13
                  weight:UIFontWeightRegular
                   color:Theme.muted]];

        NSArray *records = @[
            @{
                @"id": @"CVE-2026-84635",
                @"area": @"WebKit",
                @"impact": @"Apple describes a logic issue that can cause unexpected process termination when processing malicious web content.",
                @"status": @"iOS 27 applicability not confirmed.",
                @"source": @"https://support.apple.com/en-ca/149039"
            },
            @{
                @"id": @"CVE-2026-43664",
                @"area": @"Accessibility",
                @"impact": @"Apple describes a potential exposure of sensitive user data by an app.",
                @"status": @"Listed in Apple's iOS 27 security advisory as an addressed issue; not a confirmed kernel exploit.",
                @"source": @"https://support.apple.com/en-us/149034"
            },
            @{
                @"id": @"CVE-2026-65415",
                @"area": @"Kernel",
                @"impact": @"Apple describes possible unexpected system termination or kernel-memory disclosure in the advisories reviewed.",
                @"status": @"iOS 27 applicability not confirmed.",
                @"source": @"https://support.apple.com/en-ca/149035"
            },
            @{
                @"id": @"CVE-2026-84566",
                @"area": @"Kernel",
                @"impact": @"Apple describes possible unexpected system termination or kernel-memory corruption.",
                @"status": @"The iOS 26.7 advisory documents this issue; applicability to iOS 27 needs verification.",
                @"source": @"https://support.apple.com/en-us/149041"
            }
        ];

        for (NSDictionary *record in records) {

            UIView *separator = [UIView new];
            separator.backgroundColor = Theme.muted;
            separator.alpha = 0.25;
            [separator.heightAnchor constraintEqualToConstant:1].active = YES;

            [details addArrangedSubview:separator];

            [details addArrangedSubview:
                [Theme label:record[@"id"]
                        size:17
                      weight:UIFontWeightBold
                       color:Theme.accent]];

            [details addArrangedSubview:
                [Theme label:record[@"area"]
                        size:13
                      weight:UIFontWeightSemibold
                       color:Theme.text]];

            [details addArrangedSubview:
                [Theme label:record[@"impact"]
                        size:13
                      weight:UIFontWeightRegular
                       color:Theme.text]];

            [details addArrangedSubview:
                [Theme label:record[@"status"]
                        size:12
                      weight:UIFontWeightMedium
                       color:Theme.muted]];

            [details addArrangedSubview:
                [Theme label:[NSString stringWithFormat:
                    @"Source: %@", record[@"source"]]
                        size:11
                      weight:UIFontWeightRegular
                       color:Theme.mint]];
        }

        [details addArrangedSubview:
            [Theme label:@"Chain status: NOT VERIFIED"
                    size:15
                  weight:UIFontWeightBold
                   color:Theme.muted]];

        [details addArrangedSubview:
            [Theme label:@"A sequence of CVE identifiers does not establish a working exploit chain. Each vulnerability requires independent technical verification."
                    size:12
                  weight:UIFontWeightRegular
                   color:Theme.muted]];

    } else if ([self.section isEqualToString:@"Explore"]) {

        NSString *documents =
            NSSearchPathForDirectoriesInDomains(
                NSDocumentDirectory,
                NSUserDomainMask,
                YES
            ).firstObject ?: @"Unavailable";

        NSString *temporary = NSTemporaryDirectory() ?: @"Unavailable";

        [details addArrangedSubview:
            [Theme label:@"Accessible locations"
                    size:17
                  weight:UIFontWeightBold
                   color:Theme.text]];

        [details addArrangedSubview:
            [Theme label:[NSString stringWithFormat:
                @"Documents\n%@", documents]
                    size:13
                  weight:UIFontWeightRegular
                   color:Theme.muted]];

        [details addArrangedSubview:
            [Theme label:[NSString stringWithFormat:
                @"Temporary\n%@", temporary]
                    size:13
                  weight:UIFontWeightRegular
                   color:Theme.muted]];

        [details addArrangedSubview:
            [Theme label:@"This explorer stays within the app's ordinary sandbox."
                    size:12
                  weight:UIFontWeightMedium
                   color:Theme.mint]];

    } else if ([self.section isEqualToString:@"Diagnostics"]) {

        NSDictionary *capabilities = CapabilityManager.status;

        [details addArrangedSubview:
            [Theme label:@"Current checks"
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
            [details addArrangedSubview:
                [Theme label:[NSString stringWithFormat:
                    @"%@: %@", key, capabilities[key] ?: @"Unknown"]
                        size:13
                      weight:UIFontWeightRegular
                       color:Theme.muted]];
        }

    } else if ([self.section isEqualToString:@"Settings"]) {

        [details addArrangedSubview:
            [Theme label:@"Appearance"
                    size:18
                  weight:UIFontWeightBold
                   color:Theme.text]];

        [details addArrangedSubview:
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

        [details addArrangedSubview:selector];

        [details addArrangedSubview:
            [Theme label:@"System follows your device appearance."
                    size:12
                  weight:UIFontWeightRegular
                   color:Theme.muted]];

        [details addArrangedSubview:
            [Theme label:@"cha0s v0.3.0"
                    size:18
                  weight:UIFontWeightBold
                   color:Theme.text]];

        [details addArrangedSubview:
            [Theme label:@"Experimental iOS research toolkit."
                    size:13
                  weight:UIFontWeightRegular
                   color:Theme.muted]];

        [details addArrangedSubview:
            [Theme label:[NSString stringWithFormat:
                @"Hardware identifier: %@", DeviceInfo.machine]
                    size:12
                  weight:UIFontWeightRegular
                   color:Theme.muted]];

    } else {

        [details addArrangedSubview:
            [Theme label:self.sectionSubtitle
                    size:15
                  weight:UIFontWeightRegular
                   color:Theme.muted]];
    }

    [stack addArrangedSubview:card];
}

- (void)appearanceChanged:(UISegmentedControl *)sender {

    NSString *mode =
        sender.selectedSegmentIndex == 1 ? @"light" :
        sender.selectedSegmentIndex == 2 ? @"dark" : @"system";

    [[NSUserDefaults standardUserDefaults]
        setObject:mode forKey:@"cha0sAppearanceMode"];

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
