
#import "ViewController.h"
#import "WeakTestObj.h"
#include <objc/runtime.h>

#import "ObjcUtil.h"

bool _objc_rootIsDeallocating(id _Nonnull obj);


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Buttons
    UIButton* buttonCrash = [UIButton buttonWithType:UIButtonTypeSystem];
    buttonCrash.frame = CGRectMake(0, 100, 380, 50);
    [buttonCrash setTitle:@"Click Me Crash on objc_initWeak method" forState:UIControlStateNormal];
    [buttonCrash setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [buttonCrash addTarget:self action:@selector(eventCrashOnStoreWeak:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonCrash];
    
    UIButton* buttonDismiss = [UIButton buttonWithType:UIButtonTypeSystem];
    buttonDismiss.frame = CGRectMake(0, 150, 180, 50);
    [buttonDismiss setTitle:@"Dismiss keyboard" forState:UIControlStateNormal];
    [buttonDismiss setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [buttonDismiss addTarget:self action:@selector(eventDismissKeyboard:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonDismiss];

    // TextFields
    UITextField* textField = [[UITextField alloc] init];
    textField.frame = CGRectMake(8, 200, 300, 50);
    [textField setBorderStyle:UITextBorderStyleLine];
    [self.view addSubview:textField];
    /**
            if y is 320, not 200, will not crash ...... fucking apple ...
             so the crash relative to to textfield's y position ......
     **/
    
    // Labels
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(8, 380, 350, 250)];
    label.numberOfLines = 8;
    label.text = @" 1. Input some words using a un-official keyboard/input method, then dimiss the keyboard. \n 2. Double tap the textfield for showing up the un-official keyboard, crash will appear. \n 3. Note the UITextField y position should on the top half of the screen.";
    [self.view addSubview:label];
}

#pragma mark - Event

- (void)eventCrashOnStoreWeak:(id)button {
    WeakTestObj* obj = [[WeakTestObj alloc] init];
    obj = NULL;
    NSLog(@"~~~~~ Reappear Crash Done ~~~~~");
}

- (void)eventDismissKeyboard:(id)button {
    [self.view endEditing:YES];
}

@end


#pragma mark - Category UITouch

@interface UITouch (FixCrashOnInputKeyboard)

@end

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

