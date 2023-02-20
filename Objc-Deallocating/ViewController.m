
#import "ViewController.h"
#import "WeakTestObj.h"

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
    buttonDismiss.frame = CGRectMake(0, 200, 180, 50);
    [buttonDismiss setTitle:@"Dismiss keyboard" forState:UIControlStateNormal];
    [buttonDismiss setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [buttonDismiss addTarget:self action:@selector(eventDismissKeyboard:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonDismiss];

    // TextFields
    UITextField* textField = [[UITextField alloc] init];
    textField.frame = CGRectMake(8, 150, 300, 50);
    [textField setBorderStyle:UITextBorderStyleLine];
    [self.view addSubview:textField];
    /**
            if y is 320, not 150, will not crash ...... fucking apple ...
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
