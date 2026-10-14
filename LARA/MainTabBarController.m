#import "MainTabBarController.h"
#import "DashboardViewController.h"
#import "SectionViewController.h"
#import "Theme.h"
@implementation MainTabBarController
- (void)viewDidLoad { [super viewDidLoad]; self.view.backgroundColor=Theme.background; self.tabBar.barTintColor=Theme.panel; self.tabBar.backgroundColor=Theme.panel; self.tabBar.tintColor=Theme.accent; self.tabBar.unselectedItemTintColor=Theme.muted;
 DashboardViewController *home=[DashboardViewController new]; home.tabBarItem=[[UITabBarItem alloc]initWithTitle:@"Home" image:[UIImage systemImageNamed:@"circle.grid.2x2.fill"] tag:0];
 NSArray *titles=@[@"Explore",@"Modules",@"Diagnostics",@"Settings"]; NSArray *subs=@[@"Browse locations available to cha0s.",@"Review research module status.",@"Review local capability checks.",@"Project information and privacy."]; NSArray *icons=@[@"folder",@"square.stack.3d.up",@"waveform.path.ecg",@"gearshape"];
 NSMutableArray *controllers=[NSMutableArray array]; [controllers addObject:[[UINavigationController alloc]initWithRootViewController:home]];
 for(NSUInteger i=0;i<titles.count;i++){ SectionViewController *vc=[[SectionViewController alloc]initWithSection:titles[i] subtitle:subs[i] symbol:icons[i]]; vc.tabBarItem=[[UITabBarItem alloc]initWithTitle:titles[i] image:[UIImage systemImageNamed:icons[i]] tag:i+1]; [controllers addObject:[[UINavigationController alloc]initWithRootViewController:vc]]; }
 self.viewControllers=controllers;
}
@end
