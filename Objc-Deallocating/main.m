
#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "SelfApplication.h"

int main(int argc, char * argv[]) {
    NSString * appDelegateClassName;
    NSString * appApplicationClassName;
    @autoreleasepool {
        // Setup code that might create autoreleased objects goes here.
        appDelegateClassName = NSStringFromClass([AppDelegate class]);
        appApplicationClassName = NSStringFromClass([SelfApplication class]);
    }
    return UIApplicationMain(argc, argv, appApplicationClassName, appDelegateClassName);
}
