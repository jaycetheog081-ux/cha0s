#import <Foundation/Foundation.h>

@interface BadQueryModule : NSObject

+ (BOOL)isSupported;
+ (NSString *)compatibilityStatus;
+ (NSString *)runSelfTest;

@end
