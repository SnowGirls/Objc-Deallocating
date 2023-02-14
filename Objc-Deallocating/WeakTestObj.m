
#import "WeakTestObj.h"

@implementation WeakTestObj

- (void)dealloc {
//    __strong typeof(self) strongSelf = self;
    __weak typeof(self) weakSelf = self;
}

@end
