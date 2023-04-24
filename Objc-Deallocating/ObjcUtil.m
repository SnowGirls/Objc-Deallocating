
#import "ObjcUtil.h"

@implementation ObjcUtil

// call the origin method in the method list

+ (bool)invokeOriginalMethod:(id)target selector:(SEL)selector completion:(void (^)(Class clazz, IMP impl))completion {
    bool isBingGo = false;
    Class clazz = [target class];
    while (!isBingGo && clazz != nil) {
        isBingGo = [ObjcUtil invokeOriginalMethod:target selector:selector class:clazz completion:completion];
        clazz = [clazz superclass];
    }
    return isBingGo;
}

+ (bool)invokeOriginalMethod:(id)target selector:(SEL)selector class:(Class)clazz completion:(void (^)(Class clazz, IMP impl))completion {
    bool isBingGo = false;
    Class metaClazz = objc_getMetaClass(class_getName(clazz));
    
    // Get the instance method list in class
    uint instCount;
    Method *instMethodList = class_copyMethodList(clazz, &instCount);
    for (int i = 0; i < instCount; i++) {
        NSLog(@"[Category] instance selector : %d %@", i, NSStringFromSelector(method_getName(instMethodList[i])));
    }
    
    // Get the class method list in meta class
    uint metaCount;
    Method *metaMethodList = class_copyMethodList(metaClazz, &metaCount);
    for (int i = 0; i < metaCount; i++) {
        NSLog(@"[Category] class selector : %d %@", i, NSStringFromSelector(method_getName(metaMethodList[i])));
    }
    
    NSLog(@"[Category] -------------------------------> finding on class: %@ [%d], metaClass: %@ [%d]", clazz, instCount, metaClazz, metaCount);
    
    // Call original instance method. Note here take the last same name method as the original method
    for ( int i = instCount - 1 ; i >= 0; i--) {
        Method method = instMethodList[i];
        SEL name = method_getName(method);
        IMP implementation = method_getImplementation(method);
        if (name == selector) {
            isBingGo = true;
            NSLog(@"[Category] -------------------------------> Founded instance method on: %@", clazz);
            completion(clazz, implementation);
            // ((void (*)(id, SEL))implementation)(target, name); // id (*IMP)(id, SEL, ...)
            break;
        }
    }
    free(instMethodList);
    
    // Call original class method. Note here take the last same name method as the original method
    for ( int i = metaCount - 1 ; i >= 0; i--) {
        Method method = metaMethodList[i];
        SEL name = method_getName(method);
        IMP implementation = method_getImplementation(method);
        if (name == selector) {
            isBingGo = true;
            NSLog(@"[Category] -------------------------------> Founded class method on: %@", metaClazz);
            completion(metaClazz, implementation);
            // ((void (*)(id, SEL))implementation)(target, name); // id (*IMP)(id, SEL, ...)
            break;
        }
    }
    free(metaMethodList);
    return isBingGo;
}


@end



@implementation ObjcSeeker


- (instancetype)init {
    self = [super init];
    if (self) {
        self.isSeekBackward = TRUE;
        self.seekSkipCount = 0;
        self.seekType = ObjcSeekerTypeClass | ObjcSeekerTypeInstance;
    }
    return self;
}

- (void)seekOriginalMethod:(id)target selector:(SEL)selector {
    Class clazz = [target class];
    while (clazz != nil) {
        self.impl = [self seekOriginalMethod:target selector:selector class:clazz];
        if (self.impl != nil) {
            break;
        }
        clazz = [clazz superclass];
    }
}

- (IMP)seekOriginalMethod:(id)target selector:(SEL)selector class:(Class)clazz {
    if (self.seekType & ObjcSeekerTypeInstance) {
        // Get the instance method list in class
        uint instCount;
        Method *instMethodList = class_copyMethodList(clazz, &instCount);
        for (int i = 0; i < instCount; i++) {
            NSLog(@"[Category] instance selector : %d %@", i, NSStringFromSelector(method_getName(instMethodList[i])));
        }
        NSLog(@"[Category] -------------------------------> finding on class: %@ [%d]", clazz, instCount);
        if (self.isSeekBackward) {
            int skip = 0;
            for ( int i = instCount - 1 ; i >= 0; i--) {
                IMP implementation = [self checkSelector:selector method:instMethodList[i]];
                if (implementation != nil) {
                    if (++skip <= self.seekSkipCount) continue;
                    return implementation;
                }
            }
        } else {
            int skip = 0;
            for ( int i = 0 ; i < instCount; i++) {
                IMP implementation = [self checkSelector:selector method:instMethodList[i]];
                if (implementation != nil) {
                    if (++skip <= self.seekSkipCount) continue;
                    return implementation;
                }
            }
        }
        free(instMethodList);
    }
    
    if (self.seekType & ObjcSeekerTypeClass) {
        Class metaClazz = objc_getMetaClass(class_getName(clazz));
        // Get the class method list in meta class
        uint metaCount;
        Method *metaMethodList = class_copyMethodList(metaClazz, &metaCount);
        for (int i = 0; i < metaCount; i++) {
            NSLog(@"[Category] class selector : %d %@", i, NSStringFromSelector(method_getName(metaMethodList[i])));
        }
        NSLog(@"[Category] -------------------------------> finding on metaClass: %@ [%d]", metaClazz, metaCount);
        if (self.isSeekBackward) {
            int skip = 0;
            for ( int i = metaCount - 1 ; i >= 0; i--) {
                IMP implementation = [self checkSelector:selector method:metaMethodList[i]];
                if (implementation != nil) {
                    if (++skip <= self.seekSkipCount) continue;
                    return implementation;
                }
            }
        } else {
            int skip = 0;
            for ( int i = 0; i < metaCount; i++) {
                IMP implementation = [self checkSelector:selector method:metaMethodList[i]];
                if (implementation != nil) {
                    if (++skip <= self.seekSkipCount) continue;
                    return implementation;
                }
            }
        }
        free(metaMethodList);
    }
    return nil;
}

-(IMP) checkSelector:(SEL)selector method:(Method) method {
    SEL name = method_getName(method);
    IMP implementation = method_getImplementation(method);
    if (name == selector) {
        return implementation;
    }
    return nil;
}


#pragma mark - Static util methods

+(IMP) seekInstanceNextOirignalImpl:(id)target selector:(SEL)selector {
    ObjcSeeker *seeker = [[ObjcSeeker alloc] init];
    seeker.seekSkipCount = 1;
    seeker.isSeekBackward = FALSE;
    seeker.seekType = ObjcSeekerTypeInstance;
    [seeker seekOriginalMethod:target selector:selector];
    return seeker.impl;
}

@end
