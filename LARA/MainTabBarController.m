#import "MainTabBarController.h"
#import "DashboardViewController.h"
#import "SectionViewController.h"
#import "TweaksViewController.h"
#import "Theme.h"

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.viewControllers = @[
        [self navigationControllerWithRoot:
            [[DashboardViewController alloc] init]
                                   title:@"Home"
                                   image:@"house"],

        [self navigationControllerWithRoot:
            [[SectionViewController alloc]
                initWithSection:@"Explore"
                        subtitle:@"Discover available capabilities."
                          symbol:@"safari"]
                                   title:@"Explore"
                                   image:@"square.grid.2x2"],

        [self navigationControllerWithRoot:
            [[SectionViewController alloc]
                initWithSection:@"Modules"
                        subtitle:@"Explore available modules."
                          symbol:@"square.stack.3d.up"]
                                   title:@"Modules"
                                   image:@"square.stack.3d.up"],

        [self navigationControllerWithRoot:
            [[SectionViewController alloc]
                initWithSection:@"Diagnostics"
                        subtitle:@"Review device information and diagnostics."
                          symbol:@"stethoscope"]
                                   title:@"Diagnostics"
                                   image:@"waveform.path"],

        [self navigationControllerWithRoot:
            [[TweaksViewController alloc] init]
                                   title:@"Tweaks"
                                   image:@"slider.horizontal.3"]
    ];

    self.tabBar.tintColor = Theme.accent;
    self.tabBar.backgroundColor = Theme.panel;
}

- (UINavigationController *)navigationControllerWithRoot:
    (UIViewController *)root
                                                    title:(NSString *)title
                                                    image:(NSString *)image {

    UINavigationController *navigationController =
        [[UINavigationController alloc] initWithRootViewController:root];

    root.tabBarItem = [[UITabBarItem alloc]
        initWithTitle:title
                image:[UIImage systemImageNamed:image]
                  tag:0];

    navigationController.navigationBar.tintColor = Theme.accent;

    return navigationController;
}

@end
