#import "AppDelegate.h"
#import "MainTabBarController.h"
#import "Theme.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    NSString *mode = [[NSUserDefaults standardUserDefaults]
                      stringForKey:@"cha0sAppearanceMode"];

    if ([mode isEqualToString:@"light"]) {
        application.windows.firstObject.overrideUserInterfaceStyle =
            UIUserInterfaceStyleLight;
    } else if ([mode isEqualToString:@"dark"]) {
        application.windows.firstObject.overrideUserInterfaceStyle =
            UIUserInterfaceStyleDark;
    }

    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];

    if ([mode isEqualToString:@"light"]) {
        self.window.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
    } else if ([mode isEqualToString:@"dark"]) {
        self.window.overrideUserInterfaceStyle = UIUserInterfaceStyleDark;
    } else {
        self.window.overrideUserInterfaceStyle = UIUserInterfaceStyleUnspecified;
    }

    self.window.backgroundColor = Theme.background;
    self.window.rootViewController = [MainTabBarController new];

    [self.window makeKeyAndVisible];

    return YES;
}

@end
