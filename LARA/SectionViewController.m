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
    self.navigationController.navigationBar.titleTextAttributes = @{
        NSForegroundColorAttributeName: Theme.text
    };

    UIScrollView *scroll = [UIScrollView new];
    scroll.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:scroll];

    [NSLayoutConstraint activateConstraints:@[
        [scroll.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
        [scroll.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
        [scroll.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [scroll.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor]
    ]];

    UIStackView *stack = [UIStackView new];
    stack.axis = UILayoutConstraintAxisVertical;
    stack.spacing = 16;
    stack.layoutMargins = UIEdgeInsetsMake(24, 20, 30, 20);
    stack.layoutMarginsRelativeArrangement = YES;
    stack.translatesAutoresizingMaskIntoConstraints = NO;

    [scroll addSubview:stack];

    [NSLayoutConstraint activateConstraints:@[
        [stack.topAnchor constraintEqualToAnchor:scroll.contentLayoutGuide.topAnchor],
        [stack.bottomAnchor constraintEqualToAnchor:scroll.contentLayoutGuide.bottomAnchor],
        [stack.leadingAnchor constraintEqualToAnchor:scroll.frameLayoutGuide.leadingAnchor],
        [stack.trailingAnchor constraintEqualToAnchor:scroll.frameLayoutGuide.trailingAnchor],
        [stack.widthAnchor constraintEqualToAnchor:scroll.frameLayoutGuide.widthAnchor]
    ]];

    UIImageView *icon =
        [[UIImageView alloc] initWithImage:[UIImage systemImageNamed:self.symbol]];

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
        [details.topAnchor constraintEqualToAnchor:card.topAnchor constant:18],
        [details.bottomAnchor constraintEqualToAnchor:card.bottomAnchor constant:-18],
        [details.leadingAnchor constraintEqualToAnchor:card.leadingAnchor constant:18],
        [details.trailingAnchor constraintEqualToAnchor:card.trailingAnchor constant:-18]
    ]];

    /*
     * HOME
     */

    if ([self.section isEqualToString:@"Home"] ||
        [self.section isEqualToString:@"Dashboard"]) {

        NSString *version =
            [[NSBundle mainBundle]
                objectForInfoDictionaryKey:@"CFBundleShortVersionString"];

        NSString *build =
            [[NSBundle mainBundle]
                objectForInfoDictionaryKey:@"CFBundleVersion"];

        NSString *versionText =
            [NSString stringWithFormat:@"cha0s v%@ (build %@)",
                version ?: @"Unknown",
                build ?: @"Unknown"];

        [details addArrangedSubview:
            [Theme label:versionText
                    size:20
                  weight:UIFontWeightHeavy
                   color:Theme.text]];

        [details addArrangedSubview:
            [Theme label:@"Experimental iOS system research toolkit."
                    size:13
                  weight:UIFontWeightRegular
                   color:Theme.muted]];

        [details addArrangedSubview:
            [Theme label:@"Device Information"
                    size:17
                  weight:UIFontWeightBold
                   color:Theme.text]];

        [details addArrangedSubview:
            [Theme label:[NSString stringWithFormat:@"Hardware: %@",
                          DeviceInfo.machine ?: @"Unknown"]
                    size:13
                  weight:UIFontWeightRegular
                   color:Theme.muted]];

        [details addArrangedSubview:
            [Theme label:[NSString stringWithFormat:@"iOS: %@",
                          DeviceInfo.systemVersion ?: @"Unknown"]
                    size:13
                  weight:UIFontWeightRegular
                   color:Theme.muted]];

        [details addArrangedSubview:
            [Theme label:[NSString stringWithFormat:@"Build: %@",
                          DeviceInfo.systemBuild ?: @"Unknown"]
                    size:13
                  weight:UIFontWeightRegular
                   color:Theme.muted]];

        [details addArrangedSubview:
            [Theme label:@"Research Status"
                    size:17
                  weight:UIFontWeightBold
                   color:Theme.text]];

        [details addArrangedSubview:
            [Theme label:@"Device reporting: AVAILABLE"
                    size:12
                  weight:UIFontWeightMedium
                   color:Theme.mint]];

        [details addArrangedSubview:
            [Theme label:@"CVE compatibility: UNKNOWN until verified"
                    size:12
                  weight:UIFontWeightMedium
                   color:Theme.muted]];

        [details addArrangedSubview:
            [Theme label:@"Exploit chain: UNVERIFIED"
                    size:12
                  weight:UIFontWeightMedium
                   color:Theme.muted]];

        [details addArrangedSubview:
            [Theme label:@"Privacy: this screen does not upload diagnostic reports."
                    size:12
                  weight:UIFontWeightRegular
                   color:Theme.muted]];
    }

    /*
     * EXPLORE
     */

    else if ([self.section isEqualToString:@"Explore"]) {
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
            [Theme label:@"Access is limited to locations available to this application."
                    size:12
                  weight:UIFontWeightMedium
                   color:Theme.mint]];
    }

    /*
     * MODULES
     *
     * Research records only; not confirmed exploit components.
     */

    else if ([self.section isEqualToString:@"Modules"]) {
        [details addArrangedSubview:
            [Theme label:@"Research Overview"
                    size:18
                  weight:UIFontWeightBold
                   color:Theme.text]];

        [details addArrangedSubview:
            [Theme label:@"Entries are research records, not proof of a working exploit."
                    size:13
                  weight:UIFontWeightRegular
                   color:Theme.muted]];

        NSArray<NSString *> *identifiers = @[
            @"CVE-2026-84635",
            @"CVE-2026-43664",
            @"CVE-2026-65415",
            @"CVE-2026-84566"
        ];

        for (NSString *identifier in identifiers) {
            UIStackView *entry = [UIStackView new];
            entry.axis = UILayoutConstraintAxisVertical;
            entry.spacing = 5;

            [entry addArrangedSubview:
                [Theme label:identifier
                        size:15
                      weight:UIFontWeightSemibold
                       color:Theme.text]];

            [entry addArrangedSubview:
                [Theme label:@"Compatibility: UNKNOWN"
                        size:12
                      weight:UIFontWeightMedium
                       color:Theme.muted]];

            [entry addArrangedSubview:
                [Theme label:@"Verification: NOT VERIFIED"
                        size:12
                      weight:UIFontWeightMedium
                       color:Theme.muted]];

            [details addArrangedSubview:entry];

            UIView *separator = [UIView new];
            separator.backgroundColor = Theme.muted;
            separator.alpha = 0.2;
            [separator.heightAnchor constraintEqualToConstant:1].active = YES;

            [details addArrangedSubview:separator];
        }

        [details addArrangedSubview:
            [Theme label:@"Exploit Chain"
                    size:16
                  weight:UIFontWeightBold
                   color:Theme.text]];

        [details addArrangedSubview:
            [Theme label:@"UNVERIFIED — no working exploit chain is established by these entries."
                    size:13
                  weight:UIFontWeightMedium
                   color:Theme.muted]];
    }

    /*
     * DIAGNOSTICS
     */

    else if ([self.section isEqualToString:@"Diagnostics"]) {
        NSDictionary *capabilities = CapabilityManager.status;

        [details addArrangedSubview:
            [Theme label:@"Device Report"
                    size:18
                  weight:UIFontWeightBold
                   color:Theme.text]];

        [details addArrangedSubview:
            [Theme label:[NSString stringWithFormat:@"Device: %@",
                          DeviceInfo.machine ?: @"Unknown"]
                    size:13
                  weight:UIFontWeightRegular
                   color:Theme.muted]];

        [details addArrangedSubview:
            [Theme label:[NSString stringWithFormat:@"iOS Version: %@",
                          DeviceInfo.systemVersion ?: @"Unknown"]
                    size:13
                  weight:UIFontWeightRegular
                   color:Theme.muted]];

        [details addArrangedSubview:
            [Theme label:[NSString stringWithFormat:@"Build: %@",
                          DeviceInfo.systemBuild ?: @"Unknown"]
                    size:13
                  weight:UIFontWeightRegular
                   color:Theme.muted]];

        [details addArrangedSubview:
            [Theme label:@"Capability Checks"
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
            id rawValue = capabilities[key];

            NSString *value =
                [rawValue isKindOfClass:[NSString class]]
                    ? rawValue
                    : @"Unknown";

            [details addArrangedSubview:
                [Theme label:[NSString stringWithFormat:@"%@: %@",
                              key, value]
                        size:13
                      weight:UIFontWeightRegular
                       color:Theme.muted]];
        }

        [details addArrangedSubview:
            [Theme label:@"Device identification does not prove vulnerability or elevated access."
                    size:12
                  weight:UIFontWeightMedium
                   color:Theme.muted]];
    }

    /*
     * SETTINGS OR OTHER SECTIONS
     */

    else {
        [details addArrangedSubview:
            [Theme label:self.section
                    size:20
                  weight:UIFontWeightHeavy
                   color:Theme.text]];

        [details addArrangedSubview:
            [Theme label:self.sectionSubtitle
                    size:13
                  weight:UIFontWeightRegular
                   color:Theme.muted]];

        NSString *version =
            [[NSBundle mainBundle]
                objectForInfoDictionaryKey:@"CFBundleShortVersionString"];

        NSString *build =
            [[NSBundle mainBundle]
                objectForInfoDictionaryKey:@"CFBundleVersion"];

        [details addArrangedSubview:
            [Theme label:[NSString stringWithFormat:@"Version: %@ (build %@)",
                          version ?: @"Unknown",
                          build ?: @"Unknown"]
                    size:13
                  weight:UIFontWeightRegular
                   color:Theme.muted]];
    }

    [stack addArrangedSubview:card];
}

@end
