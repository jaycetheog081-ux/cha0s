#import "ModuleViewController.h"

#import "BadQueryModule.h"
#import "Theme.h"

#import <sys/sysctl.h>
#import <sys/utsname.h>

static NSString * const BQConfirmKey =
    @"cha0s.bad_query.confirm";

static NSString * const BQDiagnosticsKey =
    @"cha0s.bad_query.diagnostics";

#pragma mark - Module Detail Controller

@interface BadQuerySettingsViewController : UIViewController

@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UILabel *resultLabel;
@property (nonatomic, strong) UISwitch *confirmationSwitch;
@property (nonatomic, strong) UISwitch *diagnosticsSwitch;
@property (nonatomic, strong) UIButton *testButton;

@end

@implementation BadQuerySettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"bad_query";
    self.view.backgroundColor = Theme.background;

    [self buildInterface];
    [self refreshCompatibility];
}

- (UIView *)makeCard {
    UIView *card = [UIView new];

    card.backgroundColor = UIColor.whiteColor;
    card.layer.cornerRadius = 16.0;
    card.layer.borderWidth = 1.0;
    card.layer.borderColor =
        [UIColor colorWithWhite:0.0 alpha:0.06].CGColor;

    card.translatesAutoresizingMaskIntoConstraints = NO;

    return card;
}

- (UILabel *)makeLabel:(NSString *)text
                  size:(CGFloat)size
                weight:(UIFontWeight)weight {

    UILabel *label = [UILabel new];

    label.text = text;
    label.font = [UIFont systemFontOfSize:size weight:weight];
    label.textColor = Theme.text;
    label.numberOfLines = 0;
    label.translatesAutoresizingMaskIntoConstraints = NO;

    return label;
}

- (void)buildInterface {
    UIScrollView *scrollView = [UIScrollView new];

    scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    scrollView.alwaysBounceVertical = YES;

    [self.view addSubview:scrollView];

    UIStackView *stack = [[UIStackView alloc] init];

    stack.axis = UILayoutConstraintAxisVertical;
    stack.spacing = 16.0;
    stack.translatesAutoresizingMaskIntoConstraints = NO;

    [scrollView addSubview:stack];

    UILayoutGuide *safe = self.view.safeAreaLayoutGuide;

    [NSLayoutConstraint activateConstraints:@[
        [scrollView.topAnchor constraintEqualToAnchor:safe.topAnchor],
        [scrollView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [scrollView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [scrollView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],

        [stack.topAnchor constraintEqualToAnchor:scrollView.contentLayoutGuide.topAnchor constant:20.0],
        [stack.bottomAnchor constraintEqualToAnchor:scrollView.contentLayoutGuide.bottomAnchor constant:-28.0],
        [stack.leadingAnchor constraintEqualToAnchor:scrollView.frameLayoutGuide.leadingAnchor constant:18.0],
        [stack.trailingAnchor constraintEqualToAnchor:scrollView.frameLayoutGuide.trailingAnchor constant:-18.0]
    ]];

    // Module header

    UIView *header = [self makeCard];

    UILabel *title = [self makeLabel:
        @"bad_query"
        size:25.0
        weight:UIFontWeightBold];

    UILabel *subtitle = [self makeLabel:
        @"Exploit research module"
        size:14.0
        weight:UIFontWeightMedium];

    subtitle.textColor = Theme.muted;

    UILabel *description = [self makeLabel:
        @"Run the integrated module self-test against cha0s's own temporary directory. This test does not establish jailbreak capability."
        size:13.0
        weight:UIFontWeightRegular];

    UIStackView *headerStack =
        [[UIStackView alloc] initWithArrangedSubviews:@[
            title, subtitle, description
        ]];

    headerStack.axis = UILayoutConstraintAxisVertical;
    headerStack.spacing = 9.0;
    headerStack.translatesAutoresizingMaskIntoConstraints = NO;

    [header addSubview:headerStack];

    [NSLayoutConstraint activateConstraints:@[
        [headerStack.topAnchor constraintEqualToAnchor:header.topAnchor constant:18.0],
        [headerStack.leadingAnchor constraintEqualToAnchor:header.leadingAnchor constant:16.0],
        [headerStack.trailingAnchor constraintEqualToAnchor:header.trailingAnchor constant:-16.0],
        [headerStack.bottomAnchor constraintEqualToAnchor:header.bottomAnchor constant:-18.0]
    ]];

    [stack addArrangedSubview:header];

    // Compatibility card

    UIView *compatibilityCard = [self makeCard];

    UILabel *compatibilityTitle = [self makeLabel:
        @"COMPATIBILITY"
        size:12.0
        weight:UIFontWeightBold];

    self.statusLabel = [self makeLabel:
        @"Checking device…"
        size:15.0
        weight:UIFontWeightSemibold];

    UIStackView *compatibilityStack =
        [[UIStackView alloc] initWithArrangedSubviews:@[
            compatibilityTitle,
            self.statusLabel
        ]];

    compatibilityStack.axis = UILayoutConstraintAxisVertical;
    compatibilityStack.spacing = 12.0;
    compatibilityStack.translatesAutoresizingMaskIntoConstraints = NO;

    [compatibilityCard addSubview:compatibilityStack];

    [NSLayoutConstraint activateConstraints:@[
        [compatibilityStack.topAnchor constraintEqualToAnchor:compatibilityCard.topAnchor constant:17.0],
        [compatibilityStack.leadingAnchor constraintEqualToAnchor:compatibilityCard.leadingAnchor constant:16.0],
        [compatibilityStack.trailingAnchor constraintEqualToAnchor:compatibilityCard.trailingAnchor constant:-16.0],
        [compatibilityStack.bottomAnchor constraintEqualToAnchor:compatibilityCard.bottomAnchor constant:-17.0]
    ]];

    [stack addArrangedSubview:compatibilityCard];

    // Individual settings

    UIView *settingsCard = [self makeCard];

    UILabel *settingsTitle = [self makeLabel:
        @"MODULE TWEAKS"
        size:12.0
        weight:UIFontWeightBold];

    self.confirmationSwitch = [UISwitch new];
    self.confirmationSwitch.onTintColor = Theme.accent;

    id confirmationValue =
        [[NSUserDefaults standardUserDefaults] objectForKey:BQConfirmKey];

    self.confirmationSwitch.on =
        confirmationValue ? [confirmationValue boolValue] : YES;

    [self.confirmationSwitch addTarget:self
                                action:@selector(confirmationChanged:)
                      forControlEvents:UIControlEventValueChanged];

    UILabel *confirmationTitle = [self makeLabel:
        @"Confirm before testing"
        size:15.0
        weight:UIFontWeightMedium];

    UILabel *confirmationSubtitle = [self makeLabel:
        @"Show a confirmation dialog before each self-test."
        size:12.0
        weight:UIFontWeightRegular];

    confirmationSubtitle.textColor = Theme.muted;

    UIStackView *confirmationText =
        [[UIStackView alloc] initWithArrangedSubviews:@[
            confirmationTitle,
            confirmationSubtitle
        ]];

    confirmationText.axis = UILayoutConstraintAxisVertical;
    confirmationText.spacing = 4.0;

    UIStackView *confirmationRow =
        [[UIStackView alloc] initWithArrangedSubviews:@[
            confirmationText,
            self.confirmationSwitch
        ]];

    confirmationRow.axis = UILayoutConstraintAxisHorizontal;
    confirmationRow.alignment = UIStackViewAlignmentCenter;
    confirmationRow.spacing = 12.0;

    self.diagnosticsSwitch = [UISwitch new];
    self.diagnosticsSwitch.onTintColor = Theme.accent;

    id diagnosticsValue =
        [[NSUserDefaults standardUserDefaults] objectForKey:BQDiagnosticsKey];

    self.diagnosticsSwitch.on =
        diagnosticsValue ? [diagnosticsValue boolValue] : NO;

    [self.diagnosticsSwitch addTarget:self
                               action:@selector(diagnosticsChanged:)
                     forControlEvents:UIControlEventValueChanged];

    UILabel *diagnosticsTitle = [self makeLabel:
        @"Detailed diagnostics"
        size:15.0
        weight:UIFontWeightMedium];

    UILabel *diagnosticsSubtitle = [self makeLabel:
        @"Include device, build, and test context in results."
        size:12.0
        weight:UIFontWeightRegular];

    diagnosticsSubtitle.textColor = Theme.muted;

    UIStackView *diagnosticsText =
        [[UIStackView alloc] initWithArrangedSubviews:@[
            diagnosticsTitle,
            diagnosticsSubtitle
        ]];

    diagnosticsText.axis = UILayoutConstraintAxisVertical;
    diagnosticsText.spacing = 4.0;

    UIStackView *diagnosticsRow =
        [[UIStackView alloc] initWithArrangedSubviews:@[
            diagnosticsText,
            self.diagnosticsSwitch
        ]];

    diagnosticsRow.axis = UILayoutConstraintAxisHorizontal;
    diagnosticsRow.alignment = UIStackViewAlignmentCenter;
    diagnosticsRow.spacing = 12.0;

    UIStackView *settingsStack =
        [[UIStackView alloc] initWithArrangedSubviews:@[
            settingsTitle,
            confirmationRow,
            diagnosticsRow
        ]];

    settingsStack.axis = UILayoutConstraintAxisVertical;
    settingsStack.spacing = 20.0;
    settingsStack.translatesAutoresizingMaskIntoConstraints = NO;

    [settingsCard addSubview:settingsStack];

    [NSLayoutConstraint activateConstraints:@[
        [settingsStack.topAnchor constraintEqualToAnchor:settingsCard.topAnchor constant:17.0],
        [settingsStack.leadingAnchor constraintEqualToAnchor:settingsCard.leadingAnchor constant:16.0],
        [settingsStack.trailingAnchor constraintEqualToAnchor:settingsCard.trailingAnchor constant:-16.0],
        [settingsStack.bottomAnchor constraintEqualToAnchor:settingsCard.bottomAnchor constant:-17.0]
    ]];

    [stack addArrangedSubview:settingsCard];

    // Self-test card

    UIView *testCard = [self makeCard];

    UILabel *testTitle = [self makeLabel:
        @"SELF-TEST"
        size:12.0
        weight:UIFontWeightBold];

    self.resultLabel = [self makeLabel:
        @"No test has been run from this screen yet."
        size:13.0
        weight:UIFontWeightRegular];

    self.resultLabel.textColor = Theme.muted;

    self.testButton = [UIButton buttonWithType:UIButtonTypeSystem];

    [self.testButton setTitle:@"Run Module Self-Test"
                     forState:UIControlStateNormal];

    self.testButton.titleLabel.font =
        [UIFont systemFontOfSize:15.0 weight:UIFontWeightSemibold];

    self.testButton.backgroundColor = Theme.accent;
    [self.testButton setTitleColor:UIColor.whiteColor
                          forState:UIControlStateNormal];

    self.testButton.layer.cornerRadius = 12.0;
    self.testButton.contentEdgeInsets =
        UIEdgeInsetsMake(13.0, 16.0, 13.0, 16.0);

    [self.testButton addTarget:self
                        action:@selector(runTestPressed)
              forControlEvents:UIControlEventTouchUpInside];

    UIStackView *testStack =
        [[UIStackView alloc] initWithArrangedSubviews:@[
            testTitle,
            self.resultLabel,
            self.testButton
        ]];

    testStack.axis = UILayoutConstraintAxisVertical;
    testStack.spacing = 14.0;
    testStack.translatesAutoresizingMaskIntoConstraints = NO;

    [testCard addSubview:testStack];

    [NSLayoutConstraint activateConstraints:@[
        [testStack.topAnchor constraintEqualToAnchor:testCard.topAnchor constant:17.0],
        [testStack.leadingAnchor constraintEqualToAnchor:testCard.leadingAnchor constant:16.0],
        [testStack.trailingAnchor constraintEqualToAnchor:testCard.trailingAnchor constant:-16.0],
        [testStack.bottomAnchor constraintEqualToAnchor:testCard.bottomAnchor constant:-17.0]
    ]];

    [stack addArrangedSubview:testCard];

    UILabel *disclaimer = [self makeLabel:
        @"Compatibility status is preliminary. A successful temporary-directory self-test does not prove that the exploit works against the operating system."
        size:12.0
        weight:UIFontWeightRegular];

    disclaimer.textColor = Theme.muted;

    [stack addArrangedSubview:disclaimer];
}

- (void)refreshCompatibility {
    self.statusLabel.text = [BadQueryModule compatibilityStatus];
}

- (void)confirmationChanged:(UISwitch *)sender {
    [[NSUserDefaults standardUserDefaults]
        setBool:sender.isOn
        forKey:BQConfirmKey];
}

- (void)diagnosticsChanged:(UISwitch *)sender {
    [[NSUserDefaults standardUserDefaults]
        setBool:sender.isOn
        forKey:BQDiagnosticsKey];
}

- (void)runTestPressed {
    if (![BadQueryModule isSupported]) {
        self.resultLabel.text =
            [BadQueryModule compatibilityStatus];

        return;
    }

    if (self.confirmationSwitch.isOn) {
        UIAlertController *confirmation =
            [UIAlertController
                alertControllerWithTitle:@"Run bad_query self-test?"
                message:@"This runs the existing module test against cha0s's temporary directory. It is not a jailbreak operation."
                preferredStyle:UIAlertControllerStyleAlert];

        [confirmation addAction:
            [UIAlertAction
                actionWithTitle:@"Cancel"
                style:UIAlertActionStyleCancel
                handler:nil]];

        [confirmation addAction:
            [UIAlertAction
                actionWithTitle:@"Run Test"
                style:UIAlertActionStyleDefault
                handler:^(__unused UIAlertAction *action) {
                    [self executeSelfTest];
                }]];

        [self presentViewController:confirmation
                           animated:YES
                         completion:nil];
    } else {
        [self executeSelfTest];
    }
}

- (void)executeSelfTest {
    self.testButton.enabled = NO;
    [self.testButton setTitle:@"Testing…"
                     forState:UIControlStateNormal];

    self.resultLabel.text = @"Running self-test…";

    dispatch_async(dispatch_get_global_queue(QOS_CLASS_UTILITY, 0), ^{
        NSString *result = [BadQueryModule runSelfTest];

        NSString *details = nil;

        if ([[NSUserDefaults standardUserDefaults]
                boolForKey:BQDiagnosticsKey]) {

            NSOperatingSystemVersion version =
                NSProcessInfo.processInfo.operatingSystemVersion;

            char build[128] = {0};
            size_t buildSize = sizeof(build);

            NSString *buildString = @"Unavailable";

            if (sysctlbyname("kern.osversion",
                             build,
                             &buildSize,
                             NULL,
                             0) == 0) {

                buildString =
                    [NSString stringWithUTF8String:build] ?: @"Unavailable";
            }

            struct utsname systemInfo;
            NSString *machine = @"Unavailable";

            if (uname(&systemInfo) == 0) {
                machine =
                    [NSString stringWithUTF8String:systemInfo.machine]
                    ?: @"Unavailable";
            }

            details = [NSString stringWithFormat:
                @"\n\nDevice identifier: %@\niOS/iPadOS: %ld.%ld.%ld\nBuild: %@\nTemporary directory: %@",
                machine,
                (long)version.majorVersion,
                (long)version.minorVersion,
                (long)version.patchVersion,
                buildString,
                NSTemporaryDirectory()];
        }

        NSString *fullResult = details
            ? [result stringByAppendingString:details]
            : result;

        dispatch_async(dispatch_get_main_queue(), ^{
            self.resultLabel.text = fullResult;

            self.testButton.enabled = YES;
            [self.testButton setTitle:@"Run Module Self-Test"
                             forState:UIControlStateNormal];
        });
    });
}

@end

#pragma mark - Modules Browser

@interface ModuleViewController ()

@property (nonatomic, strong) UILabel *deviceLabel;
@property (nonatomic, strong) UILabel *moduleStatusLabel;

@end

@implementation ModuleViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Modules";
    self.view.backgroundColor = Theme.background;

    [self buildInterface];
}

- (UILabel *)makeLabel:(NSString *)text
                  size:(CGFloat)size
                weight:(UIFontWeight)weight {

    UILabel *label = [UILabel new];

    label.text = text;
    label.font = [UIFont systemFontOfSize:size weight:weight];
    label.textColor = Theme.text;
    label.numberOfLines = 0;
    label.translatesAutoresizingMaskIntoConstraints = NO;

    return label;
}

- (UIView *)makeCard {
    UIView *card = [UIView new];

    card.backgroundColor = UIColor.whiteColor;
    card.layer.cornerRadius = 16.0;
    card.layer.borderWidth = 1.0;
    card.layer.borderColor =
        [UIColor colorWithWhite:0.0 alpha:0.06].CGColor;

    card.translatesAutoresizingMaskIntoConstraints = NO;

    return card;
}

- (void)buildInterface {
    UIScrollView *scrollView = [UIScrollView new];

    scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    scrollView.alwaysBounceVertical = YES;

    [self.view addSubview:scrollView];

    UIStackView *stack = [UIStackView new];

    stack.axis = UILayoutConstraintAxisVertical;
    stack.spacing = 16.0;
    stack.translatesAutoresizingMaskIntoConstraints = NO;

    [scrollView addSubview:stack];

    UILayoutGuide *safe = self.view.safeAreaLayoutGuide;

    [NSLayoutConstraint activateConstraints:@[
        [scrollView.topAnchor constraintEqualToAnchor:safe.topAnchor],
        [scrollView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [scrollView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [scrollView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],

        [stack.topAnchor constraintEqualToAnchor:scrollView.contentLayoutGuide.topAnchor constant:20.0],
        [stack.bottomAnchor constraintEqualToAnchor:scrollView.contentLayoutGuide.bottomAnchor constant:-28.0],
        [stack.leadingAnchor constraintEqualToAnchor:scrollView.frameLayoutGuide.leadingAnchor constant:18.0],
        [stack.trailingAnchor constraintEqualToAnchor:scrollView.frameLayoutGuide.trailingAnchor constant:-18.0]
    ]];

    // Introduction

    UIView *introCard = [self makeCard];

    UILabel *heading = [self makeLabel:
        @"Exploit Modules"
        size:25.0
        weight:UIFontWeightBold];

    UILabel *description = [self makeLabel:
        @"Inspect available modules, review compatibility, and manage each module's settings."
        size:14.0
        weight:UIFontWeightRegular];

    description.textColor = Theme.muted;

    UIStackView *introStack =
        [[UIStackView alloc] initWithArrangedSubviews:@[
            heading,
            description
        ]];

    introStack.axis = UILayoutConstraintAxisVertical;
    introStack.spacing = 9.0;
    introStack.translatesAutoresizingMaskIntoConstraints = NO;

    [introCard addSubview:introStack];

    [NSLayoutConstraint activateConstraints:@[
        [introStack.topAnchor constraintEqualToAnchor:introCard.topAnchor constant:18.0],
        [introStack.leadingAnchor constraintEqualToAnchor:introCard.leadingAnchor constant:16.0],
        [introStack.trailingAnchor constraintEqualToAnchor:introCard.trailingAnchor constant:-16.0],
        [introStack.bottomAnchor constraintEqualToAnchor:introCard.bottomAnchor constant:-18.0]
    ]];

    [stack addArrangedSubview:introCard];

    // Device information

    UIView *deviceCard = [self makeCard];

    UILabel *deviceHeading = [self makeLabel:
        @"CURRENT DEVICE"
        size:12.0
        weight:UIFontWeightBold];

    NSOperatingSystemVersion version =
        NSProcessInfo.processInfo.operatingSystemVersion;

    NSString *versionString = [NSString stringWithFormat:
        @"iOS/iPadOS %ld.%ld.%ld",
        (long)version.majorVersion,
        (long)version.minorVersion,
        (long)version.patchVersion];

    char build[128] = {0};
    size_t buildSize = sizeof(build);

    NSString *buildString = @"Build unavailable";

    if (sysctlbyname("kern.osversion",
                     build,
                     &buildSize,
                     NULL,
                     0) == 0) {

        buildString =
            [NSString stringWithUTF8String:build] ?: @"Build unavailable";
    }

    struct utsname systemInfo;
    NSString *machine = @"Device identifier unavailable";

    if (uname(&systemInfo) == 0) {
        machine =
            [NSString stringWithUTF8String:systemInfo.machine]
            ?: machine;
    }

    self.deviceLabel = [self makeLabel:
        [NSString stringWithFormat:@"%@\n%@\n%@",
            machine, versionString, buildString]
        size:14.0
        weight:UIFontWeightMedium];

    UIStackView *deviceStack =
        [[UIStackView alloc] initWithArrangedSubviews:@[
            deviceHeading,
            self.deviceLabel
        ]];

    deviceStack.axis = UILayoutConstraintAxisVertical;
    deviceStack.spacing = 10.0;
    deviceStack.translatesAutoresizingMaskIntoConstraints = NO;

    [deviceCard addSubview:deviceStack];

    [NSLayoutConstraint activateConstraints:@[
        [deviceStack.topAnchor constraintEqualToAnchor:deviceCard.topAnchor constant:17.0],
        [deviceStack.leadingAnchor constraintEqualToAnchor:deviceCard.leadingAnchor constant:16.0],
        [deviceStack.trailingAnchor constraintEqualToAnchor:deviceCard.trailingAnchor constant:-16.0],
        [deviceStack.bottomAnchor constraintEqualToAnchor:deviceCard.bottomAnchor constant:-17.0]
    ]];

    [stack addArrangedSubview:deviceCard];

    // bad_query module card

    UIView *moduleCard = [self makeCard];

    UILabel *moduleTitle = [self makeLabel:
        @"bad_query"
        size:21.0
        weight:UIFontWeightBold];

    UILabel *moduleDescription = [self makeLabel:
        @"The first integrated research module in cha0s."
        size:13.0
        weight:UIFontWeightRegular];

    moduleDescription.textColor = Theme.muted;

    self.moduleStatusLabel = [self makeLabel:
        [BadQueryModule compatibilityStatus]
        size:13.0
        weight:UIFontWeightSemibold];

    UIButton *detailsButton =
        [UIButton buttonWithType:UIButtonTypeSystem];

    [detailsButton setTitle:@"Module Settings & Self-Test"
                   forState:UIControlStateNormal];

    detailsButton.titleLabel.font =
        [UIFont systemFontOfSize:14.0 weight:UIFontWeightSemibold];

    detailsButton.backgroundColor = Theme.accent;

    [detailsButton setTitleColor:UIColor.whiteColor
                        forState:UIControlStateNormal];

    detailsButton.layer.cornerRadius = 12.0;
    detailsButton.contentEdgeInsets =
        UIEdgeInsetsMake(12.0, 14.0, 12.0, 14.0);

    [detailsButton addTarget:self
                     action:@selector(openBadQuery)
           forControlEvents:UIControlEventTouchUpInside];

    UIStackView *moduleStack =
        [[UIStackView alloc] initWithArrangedSubviews:@[
            moduleTitle,
            moduleDescription,
            self.moduleStatusLabel,
            detailsButton
        ]];

    moduleStack.axis = UILayoutConstraintAxisVertical;
    moduleStack.spacing = 12.0;
    moduleStack.translatesAutoresizingMaskIntoConstraints = NO;

    [moduleCard addSubview:moduleStack];

    [NSLayoutConstraint activateConstraints:@[
        [moduleStack.topAnchor constraintEqualToAnchor:moduleCard.topAnchor constant:18.0],
        [moduleStack.leadingAnchor constraintEqualToAnchor:moduleCard.leadingAnchor constant:16.0],
        [moduleStack.trailingAnchor constraintEqualToAnchor:moduleCard.trailingAnchor constant:-16.0],
        [moduleStack.bottomAnchor constraintEqualToAnchor:moduleCard.bottomAnchor constant:-18.0]
    ]];

    [stack addArrangedSubview:moduleCard];

    // Honest module count

    UIView *infoCard = [self makeCard];

    UILabel *info = [self makeLabel:
        @"1 module integrated\n\nMore modules can be added when their implementations and compatibility requirements are available. No placeholder exploits are listed as functional."
        size:13.0
        weight:UIFontWeightRegular];

    UIStackView *infoStack =
        [[UIStackView alloc] initWithArrangedSubviews:@[info]];

    infoStack.translatesAutoresizingMaskIntoConstraints = NO;

    [infoCard addSubview:infoStack];

    [NSLayoutConstraint activateConstraints:@[
        [infoStack.topAnchor constraintEqualToAnchor:infoCard.topAnchor constant:16.0],
        [infoStack.leadingAnchor constraintEqualToAnchor:infoCard.leadingAnchor constant:16.0],
        [infoStack.trailingAnchor constraintEqualToAnchor:infoCard.trailingAnchor constant:-16.0],
        [infoStack.bottomAnchor constraintEqualToAnchor:infoCard.bottomAnchor constant:-16.0]
    ]];

    [stack addArrangedSubview:infoCard];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    self.moduleStatusLabel.text =
        [BadQueryModule compatibilityStatus];
}

- (void)openBadQuery {
    BadQuerySettingsViewController *settings =
        [BadQuerySettingsViewController new];

    [self.navigationController pushViewController:settings
                                         animated:YES];
}

@end
