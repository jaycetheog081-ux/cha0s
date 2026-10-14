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
    self.navigationController.navigationBarHidden = NO;

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

    if ([self.section isEqualToString:@"Explore"]) {

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

    } else if ([self.section isEqualToString:@"Modules"]) {

        [details addArrangedSubview:
            [Theme label:@"Baseline diagnostics"
                    size:16
                  weight:UIFontWeightSemibold
                   color:Theme.text]];

        [details addArrangedSubview:
            [Theme label:@"AVAILABLE · Reads ordinary app and device information."
                    size:12
                  weight:UIFontWeightMedium
                   color:Theme.mint]];

        [details addArrangedSubview:
            [Theme label:@"CVE research modules"
                    size:16
                  weight:UIFontWeightSemibold
                   color:Theme.text]];

        [details addArrangedSubview:
            [Theme label:@"NOT IMPLEMENTED · Compatibility and exploitability have not been verified."
                    size:12
                  weight:UIFontWeightMedium
                   color:Theme.muted]];

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

    } else {

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

        UISegmentedControl *appearanceSelector =
            [[UISegmentedControl alloc]
                initWithItems:@[@"System", @"Light", @"Dark"]];

        appearanceSelector.translatesAutoresizingMaskIntoConstraints = NO;
        [appearanceSelector addTarget:self
                               action:@selector(appearanceChanged:)
                     forControlEvents:UIControlEventValueChanged];

        NSString *mode = [[NSUserDefaults standardUserDefaults]
                          stringForKey:@"cha0sAppearanceMode"];

        if ([mode isEqualToString:@"light"]) {
            appearanceSelector.selectedSegmentIndex = 1;
        } else if ([mode isEqualToString:@"dark"]) {
            appearanceSelector.selectedSegmentIndex = 2;
        } else {
            appearanceSelector.selectedSegmentIndex = 0;
        }

        [details addArrangedSubview:appearanceSelector];

        [details addArrangedSubview:
            [Theme label:@"System follows your iPhone's appearance. Light uses black text; Dark uses white text."
                    size:12
                  weight:UIFontWeightRegular
                   color:Theme.muted]];

        [details addArrangedSubview:
            [Theme label:@"cha0s v0.2.0"
                    size:18
                  weight:UIFontWeightBold
                   color:Theme.text]];

        [details addArrangedSubview:
            [Theme label:@"Experimental iOS system research toolkit."
                    size:13
                  weight:UIFontWeightRegular
                   color:Theme.muted]];

        [details addArrangedSubview:
            [Theme label:@"Privacy: this build does not send telemetry or upload reports."
                    size:13
                  weight:UIFontWeightRegular
                   color:Theme.muted]];

        [details addArrangedSubview:
            [Theme label:[NSString stringWithFormat:
                @"Hardware identifier: %@", DeviceInfo.machine]
                    size:12
                  weight:UIFontWeightRegular
                   color:Theme.muted]];
    }

    [stack addArrangedSubview:card];
}

- (void)appearanceChanged:(UISegmentedControl *)sender {

    NSString *mode;

    switch (sender.selectedSegmentIndex) {
        case 1:
            mode = @"light";
            break;

        case 2:
            mode = @"dark";
            break;

        default:
            mode = @"system";
            break;
    }

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
