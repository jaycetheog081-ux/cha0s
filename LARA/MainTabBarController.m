#import "MainTabBarController.h"
#import "DashboardViewController.h"
#import "SectionViewController.h"
#import "Theme.h"

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = Theme.background;

    self.tabBar.translucent = NO;
    self.tabBar.backgroundColor = Theme.panel;
    self.tabBar.barTintColor = Theme.panel;
    self.tabBar.tintColor = Theme.text;
    self.tabBar.unselectedItemTintColor = Theme.text;

    if (@available(iOS 13.0, *)) {
        UITabBarAppearance *appearance = [UITabBarAppearance new];
        [appearance configureWithOpaqueBackground];

        appearance.backgroundColor = Theme.panel;

        NSDictionary *textAttributes = @{
            NSForegroundColorAttributeName: Theme.text
        };

        NSArray<UITabBarItemAppearance *> *layouts = @[
            appearance.stackedLayoutAppearance,
            appearance.inlineLayoutAppearance,
            appearance.compactInlineLayoutAppearance
        ];

        for (UITabBarItemAppearance *itemAppearance in layouts) {
            itemAppearance.normal.iconColor = Theme.text;
            itemAppearance.selected.iconColor = Theme.text;

            itemAppearance.normal.titleTextAttributes = textAttributes;
            itemAppearance.selected.titleTextAttributes = textAttributes;
        }

        self.tabBar.standardAppearance = appearance;

        if (@available(iOS 15.0, *)) {
            self.tabBar.scrollEdgeAppearance = appearance;
        }
    }

    DashboardViewController *home = [DashboardViewController new];

    home.tabBarItem = [[UITabBarItem alloc]
        initWithTitle:@"Home"
        image:[UIImage systemImageNamed:@"circle.grid.2x2.fill"]
        tag:0];

    NSArray *titles = @[
        @"Explore",
        @"Modules",
        @"Diagnostics",
        @"Settings"
    ];

    NSArray *subtitles = @[
        @"Browse locations available to cha0s.",
        @"Review research module status.",
        @"Review local capability checks.",
        @"Project information and appearance settings."
    ];

    NSArray *icons = @[
        @"folder",
        @"square.stack.3d.up",
        @"waveform.path.ecg",
        @"gearshape"
    ];

    NSMutableArray *controllers = [NSMutableArray array];

    [controllers addObject:
        [[UINavigationController alloc] initWithRootViewController:home]];

    for (NSUInteger i = 0; i < titles.count; i++) {
        SectionViewController *controller =
            [[SectionViewController alloc]
                initWithSection:titles[i]
                subtitle:subtitles[i]
                symbol:icons[i]];

        controller.tabBarItem = [[UITabBarItem alloc]
            initWithTitle:titles[i]
            image:[UIImage systemImageNamed:icons[i]]
            tag:i + 1];

        [controllers addObject:
            [[UINavigationController alloc]
                initWithRootViewController:controller]];
    }

    self.viewControllers = controllers;
}

@end
