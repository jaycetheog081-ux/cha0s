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
     * EXPLORE
     */

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
            [Theme label:@"Access is limited to locations available to this application."
                    size:12
                  weight:UIFontWeightMedium
                   color:Theme.mint]];
    }

    /*
     * MODULES
     *
     * These entries are research records only.
     * Their identifiers, applicability, and exploitability must be verified.
     */

    else if ([self.section isEqualToString:@"Modules"]) {
        [details addArrangedSubview:
            [Theme label:@"Research Overview"
                    size:18
                  weight:UIFontWeightBold
                   color:Theme.text]];

        [details addArrangedSubview:
            [Theme label:@"Research entries are not proof of a working exploit."
                    size:13
                  weight:UIFontWeightRegular
                   color:Theme.muted]];

        NSArray<NSDictionary *> *researchEntries = @[
            @{
                @"identifier": @"CVE-2026-84635",
                @"status": @"UNKNOWN"
            },
            @{
                @"identifier": @"CVE-2026-43664",
                @"status": @"UNKNOWN"
            },
            @{
                @"identifier": @"CVE-2026-65415",
                @"status": @"UNKNOWN"
            },
            @{
                @"identifier": @"CVE-2026-84566",
                @"status": @"UNKNOWN"
            }
        ];

        for (NSDictionary *entry in researchEntries) {
            NSString *identifier = entry[@"identifier"];

            UIView *entryView = [UIView new];
            entryView.translatesAutoresizingMaskIntoConstraints = NO;

            UIStackView *entryStack = [UIStackView new];
            entryStack.axis = UILayoutConstraintAxisVertical;
            entryStack.spacing = 5;
            entryStack.translatesAutoresizingMaskIntoConstraints = NO;

            [entryView addSubview:entryStack];

            [NSLayoutConstraint activateConstraints:@[
                [entryStack.topAnchor constraintEqualToAnchor:entryView.topAnchor constant:8],
                [entryStack.bottomAnchor constraintEqualToAnchor:entryView.bottomAnchor constant:-8],
                [entryStack.leadingAnchor constraintEqualToAnchor:entryView.leadingAnchor],
                [entryStack.trailingAnchor constraintEqualToAnchor:entryView.trailingAnchor]
            ]];

            [entryStack addArrangedSubview:
                [Theme label:identifier
                        size:15
                      weight:UIFontWeightSemibold
                       color:Theme.text]];

            [entryStack addArrangedSubview:
                [Theme label:@"Compatibility: UNKNOWN"
                        size:12
                      weight:UIFontWeightMedium
                       color:Theme.muted]];

            [entryStack addArrangedSubview:
                [Theme label:@"Verification: NOT VERIFIED"
                        size:12
                      weight:UIFontWeightMedium
                       color:Theme.muted]];

            [details addArrangedSubview:entryView];

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
                          DeviceInfo.machine]
                    size:13
                  weight:UIFontWeightRegular
                   color:Theme.muted]];

        [details addArrangedSubview:
            [Theme label:[NSString stringWithFormat:@"iOS Version: %@",
                          DeviceInfo.systemVersion]
                    size:13
                  weight:UIFontWeightRegular
                   color:Theme.muted]];

        [details addArrangedSubview:
            [Theme label:[NSString stringWithFormat:@"Build: %@",
                          DeviceInfo.systemBuild]
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
            NSString *value = capabilities[key];

            if (![value isKindOfClass:[NSString class]]) {
                value = @"Unknown";
            }

            [details addArrangedSubview:
                [Theme label:[NSString stringWithFormat:@"%@: %@",
                              key, value]
                        size:13
                      weight:UIFontWeightRegular
                       color:Theme.muted]];
        }

        [details addArrangedSubview:
            [Theme label:@"A detected device or OS version does not establish vulnerability or elevated access."
                    size:12
                  weight:UIFontWeightMedium
                   color:Theme.muted]];
    }

    /*
     * DASHBOARD / DEFAULT SECTION
     */

    else {
        [details addArrangedSubview:
            [Theme label:@"cha0s v0.4.0"
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
                          DeviceInfo.machine]
                    size:13
                  weight:UIFontWeightRegular
                   color:Theme.muted]];

        [details addArrangedSubview:
            [Theme label:[NSString stringWithFormat:@"iOS: %@",
                          DeviceInfo.systemVersion]
                    size:13
                  weight:UIFontWeightRegular
                   color:Theme.muted]];

        [details addArrangedSubview:
            [Theme label:[NSString stringWithFormat:@"Build: %@",
                          DeviceInfo.systemBuild]
                    size:13
                  weight:UIFontWeightRegular
                   color:Theme.muted]];

        [details addArrangedSubview:
            [Theme label:@"Research Status"
                    size:17
                  weight:UIFontWeightBold
                   color:Theme.text]];

        [details addArrangedSubview:
            [Theme label:@"Baseline device reporting: AVAILABLE"
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

    [stack addArrangedSubview:card];
}

@end
