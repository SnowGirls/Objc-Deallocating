
#import "TestCrash4WeakObj.h"

@implementation TestCrash4WeakObj

- (void)dealloc {
//    __strong typeof(self) strongSelf = self;
    __weak typeof(self) weakSelf = self;
}

@end
