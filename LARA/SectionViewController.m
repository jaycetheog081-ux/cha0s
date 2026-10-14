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
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.barTintColor = Theme.background;
    self.navigationController.navigationBar.tintColor = Theme.accent;
    self.navigationController.navigationBar.titleTextAttributes =
        @{NSForegroundColorAttributeName: Theme.text};

    UIScrollView *scrollView = [UIScrollView new];
    scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:scrollView];

    [NSLayoutConstraint activateConstraints:@[
        [scrollView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
        [scrollView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
        [scrollView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [scrollView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor]
    ]];

    UIStackView *stack = [UIStackView new];
    stack.axis = UILayoutConstraintAxisVertical;
    stack.spacing = 16;
    stack.layoutMargins = UIEdgeInsetsMake(24, 20, 30, 20);
    stack.layoutMarginsRelativeArrangement = YES;
    stack.translatesAutoresizingMaskIntoConstraints = NO;

    [scrollView addSubview:stack];

    [NSLayoutConstraint activateConstraints:@[
        [stack.topAnchor constraintEqualToAnchor:scrollView.contentLayoutGuide.topAnchor],
        [stack.bottomAnchor constraintEqualToAnchor:scrollView.contentLayoutGuide.bottomAnchor],
        [stack.leadingAnchor constraintEqualToAnchor:scrollView.frameLayoutGuide.leadingAnchor],
        [stack.trailingAnchor constraintEqualToAnchor:scrollView.frameLayoutGuide.trailingAnchor],
        [stack.widthAnchor constraintEqualToAnchor:scrollView.frameLayoutGuide.widthAnchor]
    ]];

    UIImageView *icon =
        [[UIImageView alloc] initWithImage:[UIImage systemImageNamed:self.symbol]];

    icon.tintColor = Theme.accent;
    icon.contentMode = UIViewContentModeScaleAspectFit;
    icon.translatesAutoresizingMaskIntoConstraints = NO;

    [NSLayoutConstraint activateConstraints:@[
        [icon.heightAnchor constraintEqualToConstant:48]
    ]];

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
        [details.topAnchor constraintEqualToAnchor:card.topAnchor constant:18],
        [details.bottomAnchor constraintEqualToAnchor:card.bottomAnchor constant:-18],
        [details.leadingAnchor constraintEqualToAnchor:card.leadingAnchor constant:18],
        [details.trailingAnchor constraintEqualToAnchor:card.trailingAnchor constant:-18]
    ]];

    if ([self.section isEqualToString:@"Explore"]) {

        NSString *documents =
            NSSearchPathForDirectoriesInDomains(
                NSDocumentDirectory,
                NSUserDomainMask,
                YES
            ).firstObject ?: @"Unavailable";

        NSString *temporary = NSTemporaryDirectory() ?: @"Unavailable";

        [details addArrangedSubview:
            [Theme label:@"Accessible Locations"
                    size:17
                  weight:UIFontWeightBold
                   color:Theme.text]];

        [details addArrangedSubview:
            [Theme label:[NSString stringWithFormat:@"Documents\n%@", documents]
                    size:13
                  weight:UIFontWeightRegular
                   color:Theme.muted]];

        [details addArrangedSubview:
            [Theme label:[NSString stringWithFormat:@"Temporary\n%@", temporary]
                    size:13
                  weight:UIFontWeightRegular
                   color:Theme.muted]];

        [details addArrangedSubview:
            [Theme label:@"Access is limited to locations available to this app."
                    size:12
                  weight:UIFontWeightMedium
                   color:Theme.mint]];

    } else if ([self.section isEqualToString:@"Modules"]) {

        [details addArrangedSubview:
            [Theme label:@"Device Diagnostics"
                    size:17
                  weight:UIFontWeightBold
                   color:Theme.text]];

        [details addArrangedSubview:
            [Theme label:@"AVAILABLE"
                    size:12
                  weight:UIFontWeightSemibold
                   color:Theme.mint]];

        [details addArrangedSubview:
            [Theme label:@"cha0s can display basic device information and run its existing diagnostic checks."
                    size:13
                  weight:UIFontWeightRegular
                   color:Theme.muted]];

        [details addArrangedSubview:
            [Theme label:@"CVE Research"
                    size:17
                  weight:UIFontWeightBold
                   color:Theme.text]];

        NSArray<NSString *> *cveIDs = @[
            @"CVE-2026-84635",
            @"CVE-2026-43664",
            @"CVE-2026-65415",
            @"CVE-2026-84566"
        ];

        for (NSString *cveID in cveIDs) {
            [details addArrangedSubview:
                [Theme label:cveID
                        size:15
                      weight:UIFontWeightSemibold
                       color:Theme.text]];

            [details addArrangedSubview:
                [Theme label:@"Research module not implemented; compatibility and exploitability unverified."
                        size:12
                      weight:UIFontWeightRegular
                       color:Theme.muted]];
        }

    } else if ([self.section isEqualToString:@"Diagnostics"]) {

        NSDictionary *checks = CapabilityManager.status;

        [details addArrangedSubview:
            [Theme label:@"Diagnostic Checks"
                    size:17
                  weight:UIFontWeightBold
                   color:Theme.text]];

        NSArray<NSString *> *keys = @[
            @"App sandbox",
            @"Documents write",
            @"Process UID",
            @"Elevated access",
            @"Exploit status"
        ];

        for (NSString *key in keys) {
            NSString *value = checks[key] ?: @"Unknown";

            [details addArrangedSubview:
                [Theme label:[NSString stringWithFormat:@"%@: %@", key, value]
                        size:13
                      weight:UIFontWeightRegular
                       color:Theme.muted]];
        }

    } else {

        NSDictionary *info = NSBundle.mainBundle.infoDictionary;

        NSString *version =
            info[@"CFBundleShortVersionString"] ?: @"Unknown";

        NSString *build =
            info[@"CFBundleVersion"] ?: @"Unknown";

        [details addArrangedSubview:
            [Theme label:[NSString stringWithFormat:@"cha0s v%@", version]
                    size:18
                  weight:UIFontWeightBold
                   color:Theme.text]];

        [details addArrangedSubview:
            [Theme label:[NSString stringWithFormat:@"Build %@", build]
                    size:13
                  weight:UIFontWeightRegular
                   color:Theme.muted]];

        [details addArrangedSubview:
            [Theme label:@"Experimental iOS research toolkit."
                    size:13
                  weight:UIFontWeightRegular
                   color:Theme.muted]];

        [details addArrangedSubview:
            [Theme label:@"Privacy: this build does not send telemetry or upload reports."
                    size:13
                  weight:UIFontWeightRegular
                   color:Theme.muted]];

        [details addArrangedSubview:
            [Theme label:[NSString stringWithFormat:@"Device: %@", DeviceInfo.machine]
                    size:12
                  weight:UIFontWeightRegular
                   color:Theme.muted]];

        [details addArrangedSubview:
            [Theme label:[NSString stringWithFormat:@"iOS: %@", DeviceInfo.systemVersion]
                    size:12
                  weight:UIFontWeightRegular
                   color:Theme.muted]];
    }

    [stack addArrangedSubview:card];
}

@end
