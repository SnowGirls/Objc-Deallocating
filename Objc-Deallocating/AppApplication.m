#import "AppApplication.h"
#import "UIWindow+FixCrashOnInputKeyboard.h"

@implementation AppApplication

- (void)sendEvent:(UIEvent *)event {
    // if ([UIWindow isSendEventToDealloctingObject:event]) return;
    [super sendEvent: event];
}

@end


