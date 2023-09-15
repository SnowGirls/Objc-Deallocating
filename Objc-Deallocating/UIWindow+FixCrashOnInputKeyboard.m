
#import "UIWindow+FixCrashOnInputKeyboard.h"
#import <objc/runtime.h>


@implementation UIWindow (FixCrashOnInputKeyboard)


+ (void)load
{
    // float os = [UIDevice currentDevice].systemVersion.floatValue;
    // if (os >= 16.0 && os < 17.0) {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = objc_getClass("UIWindow");
        SEL originalSelector = @selector(sendEvent:);
        SEL swizzledSelector = @selector(sendEventEx:);
        
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        method_exchangeImplementations(originalMethod, swizzledMethod);
    });
        
    // }
}

- (void)sendEventEx:(UIEvent *)event {
    if ([UIWindow isSendEventToDealloctingObject:event]) {
        return;
    }
    [self sendEventEx: event];
}

#pragma mark - check if sending Event to deallocating object
+ (BOOL) isSendEventToDealloctingObject:(UIEvent *)event {
    if (event.type == UIEventTypeTouches) {
        for (UITouch *touch in event.allTouches) {
            NSString *windowName = NSStringFromClass([touch.window class]);
            if ([windowName isEqualToString:@"UIRemoteKeyboardWindow"]) {
                UIView* view = touch.view;
                UIResponder *arg2 = view.nextResponder;
                NSString* responderClassName = NSStringFromClass([arg2 class]);
                if ([responderClassName isEqualToString:@"_UIRemoteInputViewController"]) {
                    bool isDeallocating = false;

                    // Use 'performSelector' when u are develop a App-Store App.
            #pragma clang diagnostic push
            #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                    SEL sel = NSSelectorFromString(@"_isDeallocating");
                    isDeallocating = [arg2 respondsToSelector:sel] && [arg2 performSelector:sel];
            #pragma clang diagnostic pop

                    if (isDeallocating) {
                        NSLog(@"UIWindow - BingGo a deallocating object ...");
                        return true;
                    }
                }
            }
        }
    }
    return false;
}

@end
