#import "TweaksViewController.h"
#import "Theme.h"

@interface TweaksViewController () <
    UITableViewDataSource,
    UITableViewDelegate,
    UISearchBarDelegate
>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) NSArray<NSDictionary *> *allFeatures;
@property (nonatomic, strong) NSArray<NSDictionary *> *filteredFeatures;

@end

@implementation TweaksViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Tweaks";
    self.view.backgroundColor = Theme.background;

    [self loadFeatures];
    [self configureSearchBar];
    [self configureTableView];
    [self configureConstraints];
}

#pragma mark - Feature Catalogue

- (void)loadFeatures {
    self.allFeatures = @[
        @{
            @"category": @"System Utilities",
            @"name": @"3-App Sideloading Limit",
            @"symbol": @"app.badge",
            @"detail": @"Remove Apple's three-app sideloading restriction where a compatible system-level method is available.",
            @"status": @"Not implemented"
        },
        @{
            @"category": @"System Utilities",
            @"name": @"Full Disk File Manager",
            @"symbol": @"folder",
            @"detail": @"Browse and manage files. Access to protected system locations requires appropriate privileges.",
            @"status": @"Not implemented"
        },
        @{
            @"category": @"System Utilities",
            @"name": @"MobileGestalt Editor",
            @"symbol": @"slider.horizontal.3",
            @"detail": @"Customize supported device properties using a compatible MobileGestalt modification method.",
            @"status": @"Not implemented"
        },
        @{
            @"category": @"System Utilities",
            @"name": @"Disable OTA Updates",
            @"symbol": @"arrow.down.circle",
            @"detail": @"Control over-the-air update behavior using a compatible system-level method.",
            @"status": @"Not implemented"
        },
        @{
            @"category": @"Home Screen",
            @"name": @"Five-App Dock",
            @"symbol": @"rectangle.bottomthird.inset.filled",
            @"detail": @"Configure a five-icon dock where the operating system permits Home Screen customization.",
            @"status": @"Not implemented"
        },
        @{
            @"category": @"Home Screen",
            @"name": @"Floating iPad-Style Dock",
            @"symbol": @"dock.rectangle",
            @"detail": @"Customize dock presentation on compatible devices.",
            @"status": @"Not implemented"
        },
        @{
            @"category": @"Home Screen",
            @"name": @"Icon Grid and Spacing",
            @"symbol": @"square.grid.3x3",
            @"detail": @"Customize Home Screen icon layout and spacing where supported.",
            @"status": @"Not implemented"
        },
        @{
            @"category": @"Home Screen",
            @"name": @"Hide Icon Labels",
            @"symbol": @"textformat",
            @"detail": @"Hide Home Screen icon labels using a compatible customization method.",
            @"status": @"Not implemented"
        },
        @{
            @"category": @"Home Screen",
            @"name": @"Disable App Library",
            @"symbol": @"square.grid.2x2",
            @"detail": @"Change App Library behavior where supported.",
            @"status": @"Not implemented"
        },
        @{
            @"category": @"Home Screen",
            @"name": @"Disable Icon Fly-In",
            @"symbol": @"square.stack.3d.up",
            @"detail": @"Customize Home Screen icon launch animations where supported.",
            @"status": @"Not implemented"
        },
        @{
            @"category": @"Interaction",
            @"name": @"Double Tap to Lock",
            @"symbol": @"lock",
            @"detail": @"Configure a double-tap locking action using a compatible system-level mechanism.",
            @"status": @"Not implemented"
        },
        @{
            @"category": @"Interaction",
            @"name": @"Scroll Physics",
            @"symbol": @"arrow.up.and.down",
            @"detail": @"Customize scrolling and drag behavior where supported.",
            @"status": @"Not implemented"
        },
        @{
            @"category": @"Device Features",
            @"name": @"Dynamic Island",
            @"symbol": @"capsule",
            @"detail": @"Enable Dynamic Island behavior on compatible devices using a supported method.",
            @"status": @"Not implemented"
        },
        @{
            @"category": @"Device Features",
            @"name": @"Boot Chime",
            @"symbol": @"speaker.wave.2",
            @"detail": @"Configure a startup sound where supported.",
            @"status": @"Not implemented"
        },
        @{
            @"category": @"Device Features",
            @"name": @"Charge Limit",
            @"symbol": @"battery.100",
            @"detail": @"Configure charging limits on supported hardware and operating system versions.",
            @"status": @"Not implemented"
        },
        @{
            @"category": @"Device Features",
            @"name": @"Always-On Display",
            @"symbol": @"sun.max",
            @"detail": @"Configure always-on display behavior on compatible hardware.",
            @"status": @"Not implemented"
        },
        @{
            @"category": @"Device Features",
            @"name": @"Camera Control",
            @"symbol": @"camera",
            @"detail": @"Customize Camera Control behavior where supported.",
            @"status": @"Not implemented"
        },
        @{
            @"category": @"Device Features",
            @"name": @"Regional Restrictions",
            @"symbol": @"globe",
            @"detail": @"Adjust supported regional feature settings where a compatible method exists.",
            @"status": @"Not implemented"
        },
        @{
            @"category": @"Status Bar",
            @"name": @"Custom Carrier Text",
            @"symbol": @"antenna.radiowaves.left.and.right",
            @"detail": @"Customize carrier text where supported.",
            @"status": @"Not implemented"
        },
        @{
            @"category": @"Status Bar",
            @"name": @"Numeric Wi-Fi Strength",
            @"symbol": @"wifi",
            @"detail": @"Display numerical Wi-Fi signal information where supported.",
            @"status": @"Not implemented"
        },
        @{
            @"category": @"Status Bar",
            @"name": @"Hide Status Icons",
            @"symbol": @"eye.slash",
            @"detail": @"Hide selected status-bar indicators where supported.",
            @"status": @"Not implemented"
        },
        @{
            @"category": @"Status Bar",
            @"name": @"Custom Battery Text",
            @"symbol": @"battery.75percent",
            @"detail": @"Customize displayed battery percentage text where supported.",
            @"status": @"Not implemented"
        },
        @{
            @"category": @"Status Bar",
            @"name": @"Build Version",
            @"symbol": @"number",
            @"detail": @"Display the operating system build version in the status bar where supported.",
            @"status": @"Not implemented"
        },
        @{
            @"category": @"Lock Screen",
            @"name": @"Custom Lock Screen Footnote",
            @"symbol": @"text.alignleft",
            @"detail": @"Customize supported lock-screen footnote or supervision text.",
            @"status": @"Not implemented"
        },
        @{
            @"category": @"Lock Screen",
            @"name": @"Disable Low Battery Alerts",
            @"symbol": @"battery.25percent",
            @"detail": @"Change low-battery alert behavior where supported.",
            @"status": @"Not implemented"
        },
        @{
            @"category": @"Lock Screen",
            @"name": @"Disable Charging Dimming",
            @"symbol": @"sun.max.fill",
            @"detail": @"Prevent screen dimming while charging where supported.",
            @"status": @"Not implemented"
        },
        @{
            @"category": @"System Behavior",
            @"name": @"Remove Wallpaper Parallax",
            @"symbol": @"viewfinder",
            @"detail": @"Disable wallpaper parallax effects where supported.",
            @"status": @"Not implemented"
        },
        @{
            @"category": @"System Behavior",
            @"name": @"iPad Multitasking on iPhone",
            @"symbol": @"rectangle.split.2x1",
            @"detail": @"Enable compatible multitasking features only where the device and operating system support them.",
            @"status": @"Not implemented"
        },
        @{
            @"category": @"Developer",
            @"name": @"JIT Support",
            @"symbol": @"terminal",
            @"detail": @"Just-in-time execution requires a compatible signing, debugging, or execution workflow.",
            @"status": @"Not implemented"
        },
        @{
            @"category": @"Developer",
            @"name": @"Metal HUD",
            @"symbol": @"speedometer",
            @"detail": @"Enable a graphics performance overlay where supported.",
            @"status": @"Not implemented"
        },
        @{
            @"category": @"Developer",
            @"name": @"Font Override",
            @"symbol": @"textformat.size",
            @"detail": @"Customize system fonts where a compatible system-level mechanism exists.",
            @"status": @"Not implemented"
        }
    ];

    self.filteredFeatures = self.allFeatures;
}

#pragma mark - Search Bar

- (void)configureSearchBar {
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectZero];
    self.searchBar.translatesAutoresizingMaskIntoConstraints = NO;
    self.searchBar.delegate = self;
    self.searchBar.placeholder = @"Search tweaks";
    self.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    self.searchBar.tintColor = Theme.accent;
    self.searchBar.backgroundColor = Theme.background;
    self.searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.searchBar.autocorrectionType = UITextAutocorrectionTypeNo;

    [self.view addSubview:self.searchBar];
}

#pragma mark - Table View

- (void)configureTableView {
    self.tableView = [[UITableView alloc]
        initWithFrame:CGRectZero
        style:UITableViewStyleInsetGrouped];

    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = Theme.background;
    self.tableView.separatorColor = UIColor.separatorColor;
    self.tableView.rowHeight = 68.0;
    self.tableView.estimatedRowHeight = 68.0;

    [self.tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:@"TweakCell"];

    [self.view addSubview:self.tableView];
}

#pragma mark - Layout

- (void)configureConstraints {
    [NSLayoutConstraint activateConstraints:@[
        [self.searchBar.topAnchor
            constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],

        [self.searchBar.leadingAnchor
            constraintEqualToAnchor:self.view.leadingAnchor],

        [self.searchBar.trailingAnchor
            constraintEqualToAnchor:self.view.trailingAnchor],

        [self.tableView.topAnchor
            constraintEqualToAnchor:self.searchBar.bottomAnchor],

        [self.tableView.leadingAnchor
            constraintEqualToAnchor:self.view.leadingAnchor],

        [self.tableView.trailingAnchor
            constraintEqualToAnchor:self.view.trailingAnchor],

        [self.tableView.bottomAnchor
            constraintEqualToAnchor:self.view.bottomAnchor]
    ]];
}

#pragma mark - Table Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return self.filteredFeatures.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell =
        [tableView dequeueReusableCellWithIdentifier:@"TweakCell"
                                        forIndexPath:indexPath];

    NSDictionary *feature = self.filteredFeatures[indexPath.row];

    cell.backgroundColor = Theme.panel;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;

    cell.textLabel.text = feature[@"name"];
    cell.textLabel.textColor = Theme.text;
    cell.textLabel.font = [UIFont systemFontOfSize:16.0
                                            weight:UIFontWeightMedium];
    cell.textLabel.numberOfLines = 2;

    UIImageSymbolConfiguration *symbolConfiguration =
        [UIImageSymbolConfiguration configurationWithPointSize:21.0
                                                        weight:UIImageSymbolWeightMedium];

    UIImage *symbolImage =
        [UIImage systemImageNamed:feature[@"symbol"]
                withConfiguration:symbolConfiguration];

    UIImageView *iconView =
        [[UIImageView alloc] initWithImage:symbolImage];

    iconView.tintColor = Theme.accent;
    iconView.contentMode = UIViewContentModeScaleAspectFit;
    iconView.frame = CGRectMake(0, 0, 28, 28);

    cell.imageView.image = symbolImage;
    cell.imageView.tintColor = Theme.accent;
    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;

    cell.accessoryView = nil;

    return cell;
}

#pragma mark - Table Delegate

- (void)tableView:(UITableView *)tableView
 didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    NSDictionary *feature = self.filteredFeatures[indexPath.row];

    NSString *title = feature[@"name"];
    NSString *detail = feature[@"detail"];
    NSString *status = feature[@"status"];

    NSString *message =
        [NSString stringWithFormat:@"%@\n\nStatus: %@",
                                   detail,
                                   status];

    UIAlertController *alert =
        [UIAlertController alertControllerWithTitle:title
                                            message:message
                                     preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *closeAction =
        [UIAlertAction actionWithTitle:@"Close"
                                 style:UIAlertActionStyleCancel
                               handler:nil];

    [alert addAction:closeAction];

    [self presentViewController:alert
                       animated:YES
                     completion:nil];
}

#pragma mark - Search

- (void)searchBar:(UISearchBar *)searchBar
    textDidChange:(NSString *)searchText {

    NSString *query =
        [searchText stringByTrimmingCharactersInSet:
            [NSCharacterSet whitespaceAndNewlineCharacterSet]];

    if (query.length == 0) {
        self.filteredFeatures = self.allFeatures;
    } else {
        NSMutableArray<NSDictionary *> *matches =
            [NSMutableArray array];

        for (NSDictionary *feature in self.allFeatures) {
            NSString *name = feature[@"name"];
            NSString *category = feature[@"category"];
            NSString *detail = feature[@"detail"];

            BOOL matchesName =
                [name localizedCaseInsensitiveContainsString:query];

            BOOL matchesCategory =
                [category localizedCaseInsensitiveContainsString:query];

            BOOL matchesDetail =
                [detail localizedCaseInsensitiveContainsString:query];

            if (matchesName || matchesCategory || matchesDetail) {
                [matches addObject:feature];
            }
        }

        self.filteredFeatures = matches;
    }

    [self.tableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

#pragma mark - Empty Search Results

- (NSString *)tableView:(UITableView *)tableView
titleForFooterInSection:(NSInteger)section {

    if (self.filteredFeatures.count == 0) {
        return @"No tweaks match your search.";
    }

    return nil;
}

@end
