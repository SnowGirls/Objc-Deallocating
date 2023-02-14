
#import <Foundation/Foundation.h>

#import <objc/runtime.h>

NS_ASSUME_NONNULL_BEGIN

@interface ObjcUtil : NSObject

// call the origin method in the method list
+ (bool)invokeOriginalMethod:(id)target selector:(SEL)selector completion:(void (^)(Class clazz, IMP impl))completion ;

+ (bool)invokeOriginalMethod:(id)target selector:(SEL)selector class:(Class)clazz completion:(void (^)(Class clazz, IMP impl))completion;

@end


typedef NS_OPTIONS(NSUInteger, ObjcSeekerType) {
    ObjcSeekerTypeClass  = 1 <<  0,
    ObjcSeekerTypeInstance = 1 <<  1,
};



@interface ObjcSeeker : NSObject

@property(assign) ObjcSeekerType seekType;

@property(assign) BOOL isSeekBackward;

@property(assign) int seekSkipCount;
@property(assign) IMP impl;

- (void)seekOriginalMethod:(id)target selector:(SEL)selector ;

@end

NS_ASSUME_NONNULL_END
