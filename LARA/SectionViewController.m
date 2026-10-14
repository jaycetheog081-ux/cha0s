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

- (UILabel *)makeLabel:(NSString *)text
                  size:(CGFloat)size
                weight:(UIFontWeight)weight
                 color:(UIColor *)color {
    return [Theme label:text size:size weight:weight color:color];
}

- (void)addText:(NSString *)text
           size:(CGFloat)size
         weight:(UIFontWeight)weight
          color:(UIColor *)color
          toStack:(UIStackView *)stack {
    [stack addArrangedSubview:
        [self makeLabel:text size:size weight:weight color:color]];
}

- (void)addCVE:(NSString *)identifier
   description:(NSString *)description
         impact:(NSString *)impact
        fixedIn:(NSString *)fixedIn
           url:(NSString *)url
        toStack:(UIStackView *)stack {

    UIView *card = [Theme card];

    UIStackView *content = [UIStackView new];
    content.axis = UILayoutConstraintAxisVertical;
    content.spacing = 9;
    content.translatesAutoresizingMaskIntoConstraints = NO;

    [card addSubview:content];

    [NSLayoutConstraint activateConstraints:@[
        [content.topAnchor constraintEqualToAnchor:card.topAnchor constant:16],
        [content.bottomAnchor constraintEqualToAnchor:card.bottomAnchor constant:-16],
        [content.leadingAnchor constraintEqualToAnchor:card.leadingAnchor constant:16],
        [content.trailingAnchor constraintEqualToAnchor:card.trailingAnchor constant:-16]
    ]];

    [self addText:identifier
             size:17
           weight:UIFontWeightBold
            color:Theme.text
          toStack:content];

    [self addText:description
             size:13
           weight:UIFontWeightRegular
            color:Theme.text
          toStack:content];

    [self addText:[NSString stringWithFormat:@"Reported impact: %@", impact]
             size:12
           weight:UIFontWeightMedium
            color:Theme.muted
          toStack:content];

    [self addText:[NSString stringWithFormat:@"Vendor fix: %@", fixedIn]
             size:12
           weight:UIFontWeightMedium
            color:Theme.muted
          toStack:content];

    [self addText:@"Device applicability: NOT VERIFIED"
             size:12
           weight:UIFontWeightSemibold
            color:Theme.muted
          toStack:content];

    [self addText:@"Exploit implementation: NOT INCLUDED"
             size:12
           weight:UIFontWeightSemibold
            color:Theme.muted
          toStack:content];

    UIButton *sourceButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [sourceButton setTitle:@"View CVE record ↗"
                  forState:UIControlStateNormal];

    sourceButton.contentHorizontalAlignment =
        UIControlContentHorizontalAlignmentLeft;

    sourceButton.titleLabel.font =
        [UIFont systemFontOfSize:14 weight:UIFontWeightSemibold];

    sourceButton.accessibilityHint =
        @"Opens the external vulnerability record.";

    objc_setAssociatedObject(
        sourceButton,
        "cha0s.cve.url",
        url,
        OBJC_ASSOCIATION_COPY_NONATOMIC
    );

    [sourceButton addTarget:self
                     action:@selector(openCVEReference:)
           forControlEvents:UIControlEventTouchUpInside];

    [content addArrangedSubview:sourceButton];

    [stack addArrangedSubview:card];
}

- (void)openCVEReference:(UIButton *)sender {
    NSString *urlString =
        objc_getAssociatedObject(sender, "cha0s.cve.url");

    NSURL *url = [NSURL URLWithString:urlString];

    if (url &&
        [url.scheme.lowercaseString isEqualToString:@"https"] &&
        url.host.length > 0) {

        [[UIApplication sharedApplication]
            openURL:url
            options:@{}
            completionHandler:nil];
    }
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
        [scroll.topAnchor
            constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
        [scroll.bottomAnchor
            constraintEqualToAnchor:self.view.bottomAnchor],
        [scroll.leadingAnchor
            constraintEqualToAnchor:self.view.leadingAnchor],
        [scroll.trailingAnchor
            constraintEqualToAnchor:self.view.trailingAnchor]
    ]];

    UIStackView *stack = [UIStackView new];
    stack.axis = UILayoutConstraintAxisVertical;
    stack.spacing = 16;
    stack.layoutMargins = UIEdgeInsetsMake(24, 20, 30, 20);
    stack.layoutMarginsRelativeArrangement = YES;
    stack.translatesAutoresizingMaskIntoConstraints = NO;

    [scroll addSubview:stack];

    [NSLayoutConstraint activateConstraints:@[
        [stack.topAnchor
            constraintEqualToAnchor:scroll.contentLayoutGuide.topAnchor],
        [stack.bottomAnchor
            constraintEqualToAnchor:scroll.contentLayoutGuide.bottomAnchor],
        [stack.leadingAnchor
            constraintEqualToAnchor:scroll.frameLayoutGuide.leadingAnchor],
        [stack.trailingAnchor
            constraintEqualToAnchor:scroll.frameLayoutGuide.trailingAnchor],
        [stack.widthAnchor
            constraintEqualToAnchor:scroll.frameLayoutGuide.widthAnchor]
    ]];

    UIImageView *icon =
        [[UIImageView alloc]
            initWithImage:[UIImage systemImageNamed:self.symbol]];

    icon.tintColor = Theme.accent;
    icon.contentMode = UIViewContentModeScaleAspectFit;
    icon.translatesAutoresizingMaskIntoConstraints = NO;

    [icon.heightAnchor constraintEqualToConstant:48].active = YES;
    [stack addArrangedSubview:icon];

    [stack addArrangedSubview:
        [self makeLabel:self.section
                   size:30
                 weight:UIFontWeightHeavy
                  color:Theme.text]];

    [stack addArrangedSubview:
        [self makeLabel:self.sectionSubtitle
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

        [self addText:@"Accessible Locations"
                 size:17
               weight:UIFontWeightBold
                color:Theme.text
              toStack:details];

        [self addText:[NSString stringWithFormat:@"Documents\n%@", documents]
                 size:13
               weight:UIFontWeightRegular
                color:Theme.muted
              toStack:details];

        [self addText:[NSString stringWithFormat:@"Temporary\n%@", temporary]
                 size:13
               weight:UIFontWeightRegular
                color:Theme.muted
              toStack:details];

        [self addText:@"This explorer stays within the app's ordinary sandbox."
                 size:12
               weight:UIFontWeightMedium
                color:Theme.mint
              toStack:details];
    }

    /*
     * MODULES
     */

    else if ([self.section isEqualToString:@"Modules"]) {

        [self addText:@"cha0s Research Modules"
                 size:20
               weight:UIFontWeightHeavy
                color:Theme.text
              toStack:details];

        [self addText:
            @"Research records, vendor advisories, and compatibility tracking."
                 size:13
               weight:UIFontWeightRegular
                color:Theme.muted
              toStack:details];

        [self addCVE:@"CVE-2026-84635"
         description:@"WebKit logic issue involving maliciously crafted web content."
               impact:@"Unexpected process termination."
              fixedIn:@"iOS 27 and related platform releases, according to published records."
                 url:@"https://nvd.nist.gov/vuln/detail/CVE-2026-84635"
              toStack:details];

        [self addCVE:@"CVE-2026-43664"
         description:@"Insufficient data protection."
               impact:@"An app may be able to access sensitive user data."
              fixedIn:@"iOS 26.7 and iOS 27, according to published records."
                 url:@"https://nvd.nist.gov/vuln/detail/CVE-2026-43664"
              toStack:details];

        [self addCVE:@"CVE-2026-65415"
         description:@"Race condition addressed with additional validation."
               impact:@"Potential system termination or kernel-memory disclosure."
              fixedIn:@"iOS 27 and related platform releases, according to published records."
                 url:@"https://nvd.nist.gov/vuln/detail/CVE-2026-65415"
              toStack:details];

        [self addCVE:@"CVE-2026-84566"
         description:@"Memory-handling vulnerability."
               impact:@"Potential system termination or kernel-memory corruption."
              fixedIn:@"iOS 26.7 and iOS 27, according to published records."
                 url:@"https://nvd.nist.gov/vuln/detail/CVE-2026-84566"
              toStack:details];

        [self addText:@"Implementation Status"
                 size:17
               weight:UIFontWeightBold
                color:Theme.text
              toStack:details];

        [self addText:
            @"Research UI: AVAILABLE"
                 size:12
               weight:UIFontWeightSemibold
                color:Theme.mint
              toStack:details];

        [self addText:
            @"Exploit chain: UNVERIFIED"
                 size:12
               weight:UIFontWeightSemibold
                color:Theme.muted
              toStack:details];

        [self addText:
            @"These records do not establish that the vulnerabilities affect the running device or can be combined into a jailbreak."
                 size:12
               weight:UIFontWeightRegular
                color:Theme.muted
              toStack:details];
    }

    /*
     * DIAGNOSTICS
     */

    else if ([self.section isEqualToString:@"Diagnostics"]) {

        NSDictionary *capabilities = CapabilityManager.status;

        [self addText:@"Device Report"
                 size:18
               weight:UIFontWeightBold
                color:Theme.text
              toStack:details];

        [self addText:
            [NSString stringWithFormat:@"Device: %@", DeviceInfo.machine ?: @"Unknown"]
                 size:13
               weight:UIFontWeightRegular
                color:Theme.muted
              toStack:details];

        [self addText:
            [NSString stringWithFormat:@"iOS Version: %@", DeviceInfo.systemVersion ?: @"Unknown"]
                 size:13
               weight:UIFontWeightRegular
                color:Theme.muted
              toStack:details];

        [self addText:
            [NSString stringWithFormat:@"Build: %@", DeviceInfo.systemBuild ?: @"Unknown"]
                 size:13
               weight:UIFontWeightRegular
                color:Theme.muted
              toStack:details];

        [self addText:@"Capability Checks"
                 size:17
               weight:UIFontWeightBold
                color:Theme.text
              toStack:details];

        for (NSString *key in @[
            @"App sandbox",
            @"Documents write",
            @"Process UID",
            @"Elevated access",
            @"Exploit status"
        ]) {
            id value = capabilities[key];

            NSString *displayValue =
                [value isKindOfClass:[NSString class]]
                    ? value
                    : @"Unknown";

            [self addText:
                [NSString stringWithFormat:@"%@: %@", key, displayValue]
                     size:13
                   weight:UIFontWeightRegular
                    color:Theme.muted
                  toStack:details];
        }
    }

    /*
     * HOME / DEFAULT SECTION
     */

    else {

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

        [self addText:versionText
                 size:20
               weight:UIFontWeightHeavy
                color:Theme.text
              toStack:details];

        [self addText:
            @"Experimental iOS system research toolkit."
                 size:13
               weight:UIFontWeightRegular
                color:Theme.muted
              toStack:details];

        [self addText:
            [NSString stringWithFormat:@"Hardware identifier: %@",
                DeviceInfo.machine ?: @"Unknown"]
                 size:12
               weight:UIFontWeightRegular
                color:Theme.muted
              toStack:details];

        [self addText:
            [NSString stringWithFormat:@"iOS version: %@",
                DeviceInfo.systemVersion ?: @"Unknown"]
                 size:12
               weight:UIFontWeightRegular
                color:Theme.muted
              toStack:details];

        [self addText:
            @"Privacy: this build does not send telemetry or upload reports."
                 size:13
               weight:UIFontWeightRegular
                color:Theme.muted
              toStack:details];
    }

    [stack addArrangedSubview:card];
}

@end
