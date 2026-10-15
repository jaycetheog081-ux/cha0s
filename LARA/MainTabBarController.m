#import "MainTabBarController.h"
#import "DashboardViewController.h"
#import "SectionViewController.h"
#import "ModuleViewController.h"
#import "Theme.h"

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = Theme.background;

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

    NSMutableArray<UIViewController *> *controllers =
        [NSMutableArray array];

    DashboardViewController *home =
        [DashboardViewController new];

    home.tabBarItem =
        [[UITabBarItem alloc]
            initWithTitle:@"Home"
            image:[UIImage systemImageNamed:@"house.fill"]
            tag:0];

    UINavigationController *homeNavigation =
        [[UINavigationController alloc]
            initWithRootViewController:home];

    [self configureNavigationBar:homeNavigation.navigationBar];
    [controllers addObject:homeNavigation];

    NSArray<NSString *> *titles = @[
        @"Explore",
        @"Modules",
        @"Diagnostics",
        @"Settings"
    ];

    NSArray<NSString *> *subtitles = @[
        @"Browse locations available to cha0s.",
        @"Manage and test available toolkit modules.",
        @"Check device capabilities.",
        @"Customize your cha0s experience."
    ];

    NSArray<NSString *> *symbols = @[
        @"folder.fill",
        @"square.stack.3d.up.fill",
        @"waveform.path.ecg",
        @"gearshape.fill"
    ];

    for (NSUInteger index = 0;
         index < titles.count;
         index++) {

        UIViewController *contentController = nil;

        if ([titles[index] isEqualToString:@"Modules"]) {
            contentController = [ModuleViewController new];
        } else {
            contentController =
                [[SectionViewController alloc]
                    initWithSection:titles[index]
                    subtitle:subtitles[index]
                    symbol:symbols[index]];
        }

        contentController.tabBarItem =
            [[UITabBarItem alloc]
                initWithTitle:titles[index]
                image:[UIImage systemImageNamed:symbols[index]]
                tag:index + 1];

        UINavigationController *navigation =
            [[UINavigationController alloc]
                initWithRootViewController:contentController];

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
