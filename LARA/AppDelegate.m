#import "AppDelegate.h"
#import "MainTabBarController.h"
#import "Theme.h"
@implementation AppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    self.window.backgroundColor = Theme.background;
    self.window.rootViewController = [MainTabBarController new];
    [self.window makeKeyAndVisible];
    return YES;
}
@end
