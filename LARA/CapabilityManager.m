#import "CapabilityManager.h"
#include <unistd.h>
@implementation CapabilityManager
+ (NSDictionary<NSString *,NSString *> *)status {
 NSString *docs=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES).firstObject?:@"";
 NSString *probe=[docs stringByAppendingPathComponent:@".cha0s-check"];
 BOOL writeOK=docs.length && [@"ok" writeToFile:probe atomically:YES encoding:NSUTF8StringEncoding error:nil];
 if(writeOK) [[NSFileManager defaultManager] removeItemAtPath:probe error:nil];
 return @{@"App sandbox":docs.length?@"Expected app container":@"Unknown",@"Documents write":writeOK?@"Available":@"Unavailable",@"Process UID":[NSString stringWithFormat:@"%d",getuid()],@"Elevated access":@"Not verified",@"Exploit status":@"No exploit executed"};
}
@end
