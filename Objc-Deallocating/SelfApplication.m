#import "SelfApplication.h"
#import "UIWindow+FixCrashOnInputKeyboard.h"

@implementation SelfApplication

- (void)sendEvent:(UIEvent *)event {
    // if ([UIWindow isSendEventToDealloctingObject:event]) return;
    [super sendEvent: event];
}

@end


