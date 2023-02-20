
#include <objc/runtime.h>

#import "ObjcUtil.h"

#import "UITouch+FixCrashOnInputKeyboard.h"


bool _objc_rootIsDeallocating(id _Nonnull obj);


@implementation UITouch (FixCrashOnInputKeyboard)


static BOOL (*originalImpl)(id, SEL, UIResponder*, UIResponder*, UIEvent* ) = nil;


- (BOOL)_wantsForwardingFromResponder:(UIResponder *)arg1 toNextResponder:(UIResponder *)arg2 withEvent:(UIEvent *)arg3 {
    NSString* responderClassName = NSStringFromClass([arg2 class]);
    if ([responderClassName isEqualToString:@"_UIRemoteInputViewController"]) {
        if (_objc_rootIsDeallocating(arg2)) {
            NSLog(@"BingGo a deallocating object ...");
            return true;
        }
    }

    BOOL retVal = FALSE;
    if (originalImpl == nil) {
        ObjcSeeker *seeker = [[ObjcSeeker alloc] init];
        seeker.seekSkipCount = 1;
        seeker.isSeekBackward = FALSE;
        seeker.seekType = ObjcSeekerTypeInstance;
        [seeker seekOriginalMethod:self selector:_cmd];
        originalImpl = (BOOL (*)(id, SEL, UIResponder*, UIResponder*, UIEvent* ))seeker.impl;
    }

    if (originalImpl != nil) {
        retVal = originalImpl(self, _cmd, arg1, arg2, arg3);
    }
    return retVal;
}


@end


#pragma mark - Categories For Checking

//@interface NSSet (CheckingIssue)
//
//@end
//
//@implementation NSSet (CheckingIssue)
//
//- (void)enumerateObjectsUsingBlock:(void (NS_NOESCAPE ^)(id obj, BOOL *stop))block {
//    NSArray* array = [self allObjects];
//    NSLog(@"enumerate enumerateObjectsUsingBlock: %ld, %@", [self count], array);
//
//    [ObjcUtil invokeOriginalMethod:self selector:_cmd completion:^(Class clazz, IMP _Nonnull impl) {
//        ((void (*)(id, SEL, void (NS_NOESCAPE ^)(id obj, BOOL *stop)  ))impl)(self, _cmd, ^(id obj, BOOL *stop){
//            NSLog(@"enumerating obj: %@", obj);
//            block(obj, stop);
//        });
//    }];
//}
//
//- (void)enumerateObjectsWithOptions:(NSEnumerationOptions)opts usingBlock:(void (^ NS_NOESCAPE)(id _Nonnull obj, BOOL * _Nonnull stop))block {
//    NSLog(@"enumerate enumerateObjectsWithOptions: %ld", [self count]);
//    [ObjcUtil invokeOriginalMethod:self selector:_cmd completion:^(Class clazz, IMP _Nonnull impl) {
//        ((void (*)(id, SEL, NSEnumerationOptions, void (^ NS_NOESCAPE)(id _Nonnull obj, BOOL * _Nonnull stop) ))impl)(self, _cmd, opts, block);
//    }];
//}
//
//@end
