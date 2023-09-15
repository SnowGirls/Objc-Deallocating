
#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "AppApplication.h"

int main(int argc, char * argv[]) {
    NSString * appDelegateClassName;
    NSString * appApplicationClassName;
    @autoreleasepool {
        // Setup code that might create autoreleased objects goes here.
        appDelegateClassName = NSStringFromClass([AppDelegate class]);
        appApplicationClassName = NSStringFromClass([AppApplication class]);
    }
    return UIApplicationMain(argc, argv, appApplicationClassName, appDelegateClassName);
}
