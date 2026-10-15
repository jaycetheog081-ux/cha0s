#import "DashboardViewController.h"
#import "Theme.h"
#import "DeviceInfo.h"
#import "CapabilityManager.h"
#import "BadQueryModule.h"

@interface DashboardViewController ()

@property (nonatomic, strong) UILabel *badQueryStatusLabel;
@property (nonatomic, strong) UILabel *badQueryCompatibilityLabel;
@property (nonatomic, strong) UIButton *badQueryRunButton;
@property (nonatomic, strong) UIActivityIndicatorView *badQuerySpinner;
@property (nonatomic, strong) UISwitch *confirmBeforeRunSwitch;
@property (nonatomic, strong) UISwitch *detailedDiagnosticsSwitch;

@end

@implementation DashboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = Theme.background;
    self.navigationController.navigationBarHidden = YES;

    [self buildDashboard];
}

#pragma mark - Dashboard

- (void)buildDashboard {
    UIScrollView *scroll = [UIScrollView new];
    scroll.translatesAutoresizingMaskIntoConstraints = NO;
    scroll.alwaysBounceVertical = YES;
    scroll.showsVerticalScrollIndicator = NO;

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
    stack.layoutMargins = UIEdgeInsetsMake(22, 20, 28, 20);
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

    [stack addArrangedSubview:
        [Theme label:@"cha0s"
                size:38
              weight:UIFontWeightHeavy
               color:Theme.text]];

    [stack addArrangedSubview:
        [Theme label:@"iOS SYSTEM RESEARCH TOOLKIT"
                size:11
              weight:UIFontWeightBold
               color:Theme.mint]];

    [stack addArrangedSubview:[self overviewCard]];
    [stack addArrangedSubview:[self deviceCard]];
    [stack addArrangedSubview:[self capabilitiesCard]];
    [stack addArrangedSubview:[self badQueryCard]];
    [stack addArrangedSubview:[self badQueryTweaksCard]];

    UILabel *footer =
        [Theme label:@"Independent project · No telemetry"
                size:11
              weight:UIFontWeightMedium
               color:Theme.muted];

    footer.textAlignment = NSTextAlignmentCenter;
    [stack addArrangedSubview:footer];
}

#pragma mark - Helpers

- (UIView *)cardWithContent:(UIView *)content {
    UIView *card = [Theme card];

    content.translatesAutoresizingMaskIntoConstraints = NO;
    [card addSubview:content];

    [NSLayoutConstraint activateConstraints:@[
        [content.topAnchor constraintEqualToAnchor:card.topAnchor constant:17],
        [content.bottomAnchor constraintEqualToAnchor:card.bottomAnchor constant:-17],
        [content.leadingAnchor constraintEqualToAnchor:card.leadingAnchor constant:17],
        [content.trailingAnchor constraintEqualToAnchor:card.trailingAnchor constant:-17]
    ]];

    return card;
}

- (UIStackView *)verticalStack:(NSArray<UIView *> *)views {
    UIStackView *stack = [[UIStackView alloc] initWithArrangedSubviews:views];
    stack.axis = UILayoutConstraintAxisVertical;
    stack.spacing = 12;
    stack.alignment = UIStackViewAlignmentFill;
    stack.distribution = UIStackViewDistributionFill;
    return stack;
}

- (UILabel *)sectionTitle:(NSString *)title {
    return [Theme label:title
                   size:11
                 weight:UIFontWeightBold
                  color:Theme.accent];
}

#pragma mark - Overview

- (UIView *)overviewCard {
    UIStackView *content = [self verticalStack:@[
        [Theme label:@"Capability overview"
                size:18
              weight:UIFontWeightBold
               color:Theme.text],

        [Theme label:@"Baseline mode is active. Exploit modules are tested individually and must pass their compatibility checks."
                size:13
              weight:UIFontWeightRegular
               color:Theme.muted],

        [Theme label:@"●  EXPERIMENTAL BUILD · v0.1.0"
                size:11
              weight:UIFontWeightBold
               color:Theme.mint]
    ]];

    return [self cardWithContent:content];
}

#pragma mark - Device

- (UIView *)deviceCard {
    NSString *deviceText = [NSString stringWithFormat:
        @"Model: %@\niOS: %@\nBuild: %@",
        DeviceInfo.machine ?: @"Unknown",
        DeviceInfo.systemVersion ?: @"Unknown",
        DeviceInfo.systemBuild ?: @"Unknown"];

    UIStackView *content = [self verticalStack:@[
        [self sectionTitle:@"DEVICE"],

        [Theme label:deviceText
                size:13
              weight:UIFontWeightMedium
               color:Theme.text]
    ]];

    return [self cardWithContent:content];
}

#pragma mark - Capabilities

- (UIView *)capabilitiesCard {
    NSDictionary *caps = CapabilityManager.status;

    NSString *capabilityText = [NSString stringWithFormat:
        @"App sandbox: %@\n"
         "Documents write: %@\n"
         "Process UID: %@\n"
         "Elevated access: %@\n"
         "Exploit status: %@",
        caps[@"App sandbox"] ?: @"Unknown",
        caps[@"Documents write"] ?: @"Unknown",
        caps[@"Process UID"] ?: @"Unknown",
        caps[@"Elevated access"] ?: @"Unknown",
        caps[@"Exploit status"] ?: @"Unknown"];

    UIStackView *content = [self verticalStack:@[
        [self sectionTitle:@"CAPABILITIES"],

        [Theme label:capabilityText
                size:13
              weight:UIFontWeightMedium
               color:Theme.text]
    ]];

    return [self cardWithContent:content];
}

#pragma mark - BadQuery

- (UIView *)badQueryCard {
    self.badQueryCompatibilityLabel =
        [Theme label:[BadQueryModule compatibilityStatus]
                size:13
              weight:UIFontWeightMedium
               color:Theme.muted];

    self.badQueryCompatibilityLabel.numberOfLines = 0;

    self.badQueryStatusLabel =
        [Theme label:@"Ready. No self-test has been run."
                size:13
              weight:UIFontWeightMedium
               color:Theme.text];

    self.badQueryStatusLabel.numberOfLines = 0;

    self.badQueryRunButton = [UIButton buttonWithType:UIButtonTypeSystem];

    [self.badQueryRunButton setTitle:@"Run Module Self-Test"
                            forState:UIControlStateNormal];

    [self.badQueryRunButton setTitleColor:Theme.background
                                forState:UIControlStateNormal];

    self.badQueryRunButton.backgroundColor = Theme.mint;
    self.badQueryRunButton.titleLabel.font =
        [UIFont systemFontOfSize:15 weight:UIFontWeightBold];

    self.badQueryRunButton.layer.cornerRadius = 12;
    self.badQueryRunButton.contentEdgeInsets = UIEdgeInsetsMake(14, 16, 14, 16);

    [self.badQueryRunButton addTarget:self
                               action:@selector(runBadQueryPressed)
                     forControlEvents:UIControlEventTouchUpInside];

    self.badQuerySpinner =
        [[UIActivityIndicatorView alloc]
            initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleMedium];

    self.badQuerySpinner.hidesWhenStopped = YES;

    UIStackView *content = [self verticalStack:@[
        [self sectionTitle:@"EXPLOIT MODULE"],

        [Theme label:@"bad_query"
                size:22
              weight:UIFontWeightBold
               color:Theme.text],

        [Theme label:@"Module: BadQueryModule"
                size:12
              weight:UIFontWeightMedium
               color:Theme.mint],

        self.badQueryCompatibilityLabel,
        self.badQueryRunButton,
        self.badQuerySpinner,
        self.badQueryStatusLabel
    ]];

    return [self cardWithContent:content];
}

- (void)runBadQueryPressed {
    if (self.badQuerySpinner.isAnimating) {
        return;
    }

    BOOL confirm = [[NSUserDefaults standardUserDefaults]
        boolForKey:@"cha0s.bad_query.confirm"];

    if (confirm) {
        UIAlertController *alert =
            [UIAlertController alertControllerWithTitle:@"Run bad_query self-test?"
                                                message:@"The module invokes its existing implementation against the app's temporary directory. Compatibility does not guarantee safety."
                                         preferredStyle:UIAlertControllerStyleAlert];

        [alert addAction:
            [UIAlertAction actionWithTitle:@"Cancel"
                                     style:UIAlertActionStyleCancel
                                   handler:nil]];

        [alert addAction:
            [UIAlertAction actionWithTitle:@"Run Self-Test"
                                     style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action) {
            [self executeBadQuerySelfTest];
        }]];

        [self presentViewController:alert animated:YES completion:nil];
        return;
    }

    [self executeBadQuerySelfTest];
}

- (void)executeBadQuerySelfTest {
    if (![BadQueryModule isSupported]) {
        self.badQueryStatusLabel.text = [BadQueryModule compatibilityStatus];
        self.badQueryCompatibilityLabel.text =
            @"Compatibility check failed. The module was not executed.";
        return;
    }

    self.badQueryRunButton.enabled = NO;
    self.badQueryRunButton.alpha = 0.55;
    self.badQueryStatusLabel.text = @"Running module self-test…";

    [self.badQuerySpinner startAnimating];

    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        NSString *result = [BadQueryModule runSelfTest];

        dispatch_async(dispatch_get_main_queue(), ^{
            [self.badQuerySpinner stopAnimating];

            self.badQueryRunButton.enabled = YES;
            self.badQueryRunButton.alpha = 1.0;

            self.badQueryStatusLabel.text =
                result ?: @"The module returned no status.";

            BOOL diagnostics = [[NSUserDefaults standardUserDefaults]
                boolForKey:@"cha0s.bad_query.diagnostics"];

            if (diagnostics) {
                self.badQueryCompatibilityLabel.text =
                    [NSString stringWithFormat:@"%@\nDevice build: %@",
                        [BadQueryModule compatibilityStatus],
                        DeviceInfo.systemBuild ?: @"Unknown"];
            } else {
                self.badQueryCompatibilityLabel.text =
                    [BadQueryModule compatibilityStatus];
            }
        });
    });
}

#pragma mark - BadQuery Tweaks

- (UIView *)badQueryTweaksCard {
    BOOL confirm = [[NSUserDefaults standardUserDefaults]
        boolForKey:@"cha0s.bad_query.confirm"];

    BOOL diagnostics = [[NSUserDefaults standardUserDefaults]
        boolForKey:@"cha0s.bad_query.diagnostics"];

    self.confirmBeforeRunSwitch = [UISwitch new];
    self.confirmBeforeRunSwitch.on = confirm;

    [self.confirmBeforeRunSwitch addTarget:self
                                    action:@selector(confirmSettingChanged:)
                          forControlEvents:UIControlEventValueChanged];

    self.detailedDiagnosticsSwitch = [UISwitch new];
    self.detailedDiagnosticsSwitch.on = diagnostics;

    [self.detailedDiagnosticsSwitch addTarget:self
                                       action:@selector(diagnosticsSettingChanged:)
                             forControlEvents:UIControlEventValueChanged];

    UIStackView *content = [self verticalStack:@[
        [self sectionTitle:@"BAD_QUERY TWEAKS"],

        [Theme label:@"Module Settings"
                size:18
              weight:UIFontWeightBold
               color:Theme.text],

        [self settingRow:@"Confirm before running"
                subtitle:@"Ask before starting a self-test."
                  toggle:self.confirmBeforeRunSwitch],

        [self settingRow:@"Detailed diagnostics"
                subtitle:@"Show additional compatibility information."
                  toggle:self.detailedDiagnosticsSwitch],

        [Theme label:@"Compatibility checks remain mandatory. These settings change the module interface, not the underlying exploit."
                size:12
              weight:UIFontWeightRegular
               color:Theme.muted]
    ]];

    return [self cardWithContent:content];
}

- (UIView *)settingRow:(NSString *)title
              subtitle:(NSString *)subtitle
                toggle:(UISwitch *)toggle {
    UIStackView *textStack = [self verticalStack:@[
        [Theme label:title
                size:14
              weight:UIFontWeightSemibold
               color:Theme.text],

        [Theme label:subtitle
                size:12
              weight:UIFontWeightRegular
               color:Theme.muted]
    ]];

    textStack.spacing = 4;

    UIStackView *row = [[UIStackView alloc]
        initWithArrangedSubviews:@[textStack, toggle]];

    row.axis = UILayoutConstraintAxisHorizontal;
    row.spacing = 12;
    row.alignment = UIStackViewAlignmentCenter;
    row.distribution = UIStackViewDistributionFill;

    [toggle setContentHuggingPriority:UILayoutPriorityRequired
                             forAxis:UILayoutConstraintAxisHorizontal];

    return row;
}

- (void)confirmSettingChanged:(UISwitch *)sender {
    [[NSUserDefaults standardUserDefaults]
        setBool:sender.isOn
        forKey:@"cha0s.bad_query.confirm"];
}

- (void)diagnosticsSettingChanged:(UISwitch *)sender {
    [[NSUserDefaults standardUserDefaults]
        setBool:sender.isOn
        forKey:@"cha0s.bad_query.diagnostics"];

    if (sender.isOn) {
        self.badQueryCompatibilityLabel.text =
            [NSString stringWithFormat:@"%@\nDevice build: %@",
                [BadQueryModule compatibilityStatus],
                DeviceInfo.systemBuild ?: @"Unknown"];
    } else {
        self.badQueryCompatibilityLabel.text =
            [BadQueryModule compatibilityStatus];
    }
}

@end
