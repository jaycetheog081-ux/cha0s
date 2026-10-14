#import "DeviceInfo.h"
#import <UIKit/UIKit.h>
#include <sys/sysctl.h>
@implementation DeviceInfo
+ (NSString *)machine { size_t n=0; sysctlbyname("hw.machine",NULL,&n,NULL,0); if(!n)return @"Unknown"; char *b=calloc(1,n); if(!b)return @"Unknown"; sysctlbyname("hw.machine",b,&n,NULL,0); NSString *s=[NSString stringWithUTF8String:b]?:@"Unknown"; free(b); return s; }
+ (NSString *)systemVersion { return UIDevice.currentDevice.systemVersion?:@"Unknown"; }
+ (NSString *)systemBuild { NSDictionary *d=[NSDictionary dictionaryWithContentsOfFile:@"/System/Library/CoreServices/SystemVersion.plist"]; return d[@"ProductBuildVersion"]?:@"Not exposed"; }
@end
