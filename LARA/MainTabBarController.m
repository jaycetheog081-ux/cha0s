#import "MainTabBarController.h"
#import "DashboardViewController.h"
#import "SectionViewController.h"
#import "Theme.h"

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = Theme.background;

    // Colorful, light bottom navigation.
    self.tabBar.tintColor = Theme.accent;
    self.tabBar.unselectedItemTintColor = Theme.muted;
    self.tabBar.backgroundColor = UIColor.whiteColor;
    self.tabBar.barTintColor = UIColor.whiteColor;
    self.tabBar.translucent = NO;

    if (@available(iOS 15.0, *)) {
        UITabBarAppearance *tabAppearance =
            [UITabBarAppearance new];

        [tabAppearance configureWithDefaultBackground];
        tabAppearance.backgroundColor = UIColor.whiteColor;
        tabAppearance.shadowColor =
            [UIColor colorWithWhite:0.0 alpha:0.08];

        tabAppearance.stackedLayoutAppearance.selected.iconColor =
            Theme.accent;
        tabAppearance.stackedLayoutAppearance.selected.titleTextAttributes =
            @{NSForegroundColorAttributeName: Theme.accent};

        tabAppearance.stackedLayoutAppearance.normal.iconColor =
            Theme.muted;
        tabAppearance.stackedLayoutAppearance.normal.titleTextAttributes =
            @{NSForegroundColorAttributeName: Theme.muted};

        self.tabBar.standardAppearance = tabAppearance;
        self.tabBar.scrollEdgeAppearance = tabAppearance;
    }

    DashboardViewController *home =
        [DashboardViewController new];

    home.tabBarItem =
        [[UITabBarItem alloc]
            initWithTitle:@"Home"
            image:[UIImage systemImageNamed:@"house.fill"]
            tag:0];

    NSArray<NSString *> *titles = @[
        @"Explore",
        @"Modules",
        @"Diagnostics",
        @"Settings"
    ];

    NSArray<NSString *> *subtitles = @[
        @"Browse locations available to cha0s.",
        @"Manage available toolkit modules.",
        @"Check device capabilities.",
        @"Customize your cha0s experience."
    ];

    NSArray<NSString *> *symbols = @[
        @"folder.fill",
        @"square.stack.3d.up.fill",
        @"waveform.path.ecg",
        @"gearshape.fill"
    ];

    NSMutableArray<UIViewController *> *controllers =
        [NSMutableArray array];

    UINavigationController *homeNavigation =
        [[UINavigationController alloc]
            initWithRootViewController:home];

    [self configureNavigationBar:homeNavigation.navigationBar];

    [controllers addObject:homeNavigation];

    for (NSUInteger index = 0;
         index < titles.count;
         index++) {

        NSString *title = titles[index];

        SectionViewController *section =
            [[SectionViewController alloc]
                initWithSection:title
                subtitle:subtitles[index]
                symbol:symbols[index]];

        section.tabBarItem =
            [[UITabBarItem alloc]
                initWithTitle:title
                image:[UIImage systemImageNamed:symbols[index]]
                tag:index + 1];

        UINavigationController *navigation =
            [[UINavigationController alloc]
                initWithRootViewController:section];

        [self configureNavigationBar:navigation.navigationBar];

        [controllers addObject:navigation];
    }

    self.viewControllers = controllers;
}

- (void)configureNavigationBar:(UINavigationBar *)navigationBar {
    navigationBar.tintColor = Theme.accent;
    navigationBar.barTintColor = UIColor.whiteColor;
    navigationBar.translucent = NO;

    if (@available(iOS 13.0, *)) {
        UINavigationBarAppearance *appearance =
            [UINavigationBarAppearance new];

        [appearance configureWithOpaqueBackground];

        appearance.backgroundColor = UIColor.whiteColor;
        appearance.titleTextAttributes =
            @{NSForegroundColorAttributeName: Theme.text};

        appearance.largeTitleTextAttributes =
            @{NSForegroundColorAttributeName: Theme.text};

        appearance.shadowColor =
            [UIColor colorWithWhite:0.0 alpha:0.06];

        navigationBar.standardAppearance = appearance;
        navigationBar.scrollEdgeAppearance = appearance;
        navigationBar.compactAppearance = appearance;
    }
}

@end
