#import <Foundation/Foundation.h>
@interface DeviceInfo : NSObject
+ (NSString *)machine; + (NSString *)systemVersion; + (NSString *)systemBuild;
@end
