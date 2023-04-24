
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIWindow (FixCrashOnInputKeyboard)

+ (BOOL) isSendEventToDealloctingObject:(UIEvent *)event ;

@end

NS_ASSUME_NONNULL_END
