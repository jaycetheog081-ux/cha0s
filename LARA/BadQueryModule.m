#import "BadQueryModule.h"
#import <sys/sysctl.h>
#import "bad_query.h"

@implementation BadQueryModule

+ (NSString *)systemBuild {
    char build[128] = {0};
    size_t size = sizeof(build);

    if (sysctlbyname("kern.osversion", build, &size, NULL, 0) != 0) {
        return @"";
    }

    return [NSString stringWithUTF8String:build] ?: @"";
}

+ (BOOL)isSupported {
    NSOperatingSystemVersion version =
        NSProcessInfo.processInfo.operatingSystemVersion;

    if (version.majorVersion == 26) {
        return YES;
    }

    // The upstream project documents iOS 27.0 beta 4.
    return version.majorVersion == 27 &&
           [[self systemBuild] isEqualToString:@"24A5390f"];
}

+ (NSString *)compatibilityStatus {
    NSOperatingSystemVersion version =
        NSProcessInfo.processInfo.operatingSystemVersion;

    if (version.majorVersion == 27 &&
        [[self systemBuild] isEqualToString:@"24A5390f"]) {
        return @"Supported beta build detected.";
    }

    if (version.majorVersion == 26) {
        return @"Potentially supported. Exact build compatibility must be verified.";
    }

    return @"Unsupported build. The module was not executed.";
}

+ (NSString *)runSelfTest {
    if (![self isSupported]) {
        return [self compatibilityStatus];
    }

    NSString *temporaryDirectory =
        NSTemporaryDirectory().stringByStandardizingPath;

    if (temporaryDirectory.length == 0) {
        return @"Self-test failed: temporary directory unavailable.";
    }

    // Restrict this initial integration test to the app's own directory.
    int64_t handle = bad_query(
        (char *)temporaryDirectory.UTF8String,
        false,
        NULL,
        false
    );

    if (handle < 0) {
        return [NSString stringWithFormat:
            @"Self-test failed. Module error: %lld",
            (long long)handle];
    }

    bad_query_release(handle);

    return @"Self-test passed for the app's temporary directory.";
}

@end
