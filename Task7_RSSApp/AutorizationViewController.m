//
//  AutorizationViewController.m
//  Task7_RSSApp
//
//  Created by Anton Kushnerov on 4.07.21.
//

#import "AutorizationViewController.h"

@interface AutorizationViewController () <UITextFieldDelegate, UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *loginTextfield;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextfield;
@property (weak, nonatomic) IBOutlet UIButton *authorizeButton;
@property (weak, nonatomic) IBOutlet UIView *secureView;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@property (weak, nonatomic) IBOutlet UIButton *button1;
@property (weak, nonatomic) IBOutlet UIButton *button2;
@property (weak, nonatomic) IBOutlet UIButton *button3;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *password;

@end

@interface AutorizationViewController (KeyboardHandling)
- (void)subscribeOnKeyboardEvents;
- (void)updateTopConstraintWith:(CGFloat) constant andBottom:(CGFloat) bottomConstant;
- (void)hideWhenTappedAround;
@end

@implementation AutorizationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self subscribeOnKeyboardEvents];
    [self hideWhenTappedAround];
    
    self.loginTextfield.delegate = self;
    self.passwordTextfield.delegate = self;
    
    self.pincodeArray = [NSMutableArray new];
    
    [self configureTextField:self.loginTextfield];
    [self configureTextField:self.passwordTextfield];
    [self setState:@"appear" forTextfield:self.loginTextfield];
    [self setState:@"appear" forTextfield:self.passwordTextfield];
    
    [self configureAuthorizeButton];
    
    self.authorizeButton.titleEdgeInsets = UIEdgeInsetsMake(10, 20, 10, 20);
    
    [self configureDIgitButton:_button1];
    [self configureDIgitButton:_button2];
    [self configureDIgitButton:_button3];
    
    [self.secureView.layer setBorderWidth:2];
    [self.secureView.layer setBorderColor:[UIColor clearColor].CGColor];
    [self.secureView.layer setCornerRadius:10];
}


- (IBAction)loginEditingDidBegin:(id)sender {
    [self setState:@"appear" forTextfield:self.loginTextfield];
}

- (IBAction)authorizeButtonTapped:(id)sender {
    NSString *correctLogin = @"username";
    NSString *correctPassword = @"password";
    BOOL isCorrect = ([self.loginTextfield.text isEqualToString:correctLogin] && [self.passwordTextfield.text isEqualToString:correctPassword]);
    
    [self hideWhenTappedAround];
//    if ([self.loginTextfield.text isEqualToString:correctLogin]) {
        [self setState:@"correct" forTextfield:self.loginTextfield];
//    } 
//    else {
//        [self setState:@"error" forTextfield:self.loginTextfield];
//    }
    
    if ([self.passwordTextfield.text isEqualToString:correctPassword]) {
        [self setState:@"correct" forTextfield:self.passwordTextfield];
    } else {
        [self setState:@"error" forTextfield:self.passwordTextfield];
    }
    
    if (isCorrect) {
        [self.loginTextfield setEnabled:NO];
        [self.passwordTextfield setEnabled:NO];
        [self.authorizeButton setEnabled:NO];
        [self.secureView setHidden:NO];
        [self.loginTextfield setAlpha:0.5];
        [self.passwordTextfield setAlpha:0.5];
        [self.authorizeButton setAlpha:0.5];
    }
}

- (IBAction)digitButtonTapped:(UIButton *)sender {

    NSNumberFormatter *formatter = [NSNumberFormatter new];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    NSNumber* senderValue = [formatter numberFromString:sender.titleLabel.text];
    [self.pincodeArray addObject: senderValue];
    
    if (self.pincodeArray.count == 1) {
        self.resultLabel.text = @" ";
    }
    
    [self.resultLabel setText:[self.resultLabel.text stringByAppendingFormat: @"%d ", senderValue.intValue]];
    
    if (self.pincodeArray.count == 3) {
        UIColor *incorrect = [UIColor colorNamed:@"Venetian Red"];
        UIColor *correct = [UIColor colorNamed:@"Turquoise Green"];
        
        if ([self.pincodeArray isEqualToArray:@[@1, @3, @2]]) {
            [self.secureView.layer setBorderColor:correct.CGColor];
            [self showAlert];
        } else {
            [self.secureView.layer setBorderColor:incorrect.CGColor];
            self.resultLabel.text = @"_";
            [self.pincodeArray removeAllObjects];
        }
    } else {
        [self.secureView.layer setBorderColor:[UIColor clearColor].CGColor];
    }
    
}



- (void)showAlert {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"Welcome"
                                                                     message:@"You are successfuly authorized!" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *refresh = [UIAlertAction actionWithTitle:@"Refresh"
                                                      style:UIAlertActionStyleDestructive
                                                    handler:^(UIAlertAction * _Nonnull action) {
        [self.secureView setHidden:YES];
        [self.secureView.layer setBorderColor:[UIColor clearColor].CGColor];
        
        [self.authorizeButton setEnabled:YES];
        [self.authorizeButton setAlpha:1];
        
        [self setState:@"appear" forTextfield:self.loginTextfield];
        self.loginTextfield.text = @"";
        
        [self setState:@"appear" forTextfield:self.passwordTextfield];
        self.passwordTextfield.text = @"";
        
        self.resultLabel.text = @"_";
        
        [self.pincodeArray removeAllObjects];
    }];
    
    [alertVC addAction:refresh];
    [self presentViewController:alertVC animated:YES completion:nil];
}

- (void)configureTextField:(UITextField *)textfield {
    [textfield.layer setCornerRadius:5];
    [textfield.layer setBorderWidth:1.5];
}

- (void)setState:(NSString *)state forTextfield:(UITextField *)textfield {
    UIColor *appear = [UIColor colorNamed:@"Black Coral"];
    UIColor *correct = [UIColor colorNamed:@"Turquoise Green"];
    UIColor *error = [UIColor colorNamed:@"Venetian Red"];
    
    if ([state isEqualToString:@"appear"]) {
        [textfield setEnabled:YES];
        [textfield.layer setBorderColor:appear.CGColor];
        [textfield setAlpha:1];
    } else if ([state isEqualToString:@"correct"]) {
        [textfield.layer setBorderColor:correct.CGColor];
    } else if ([state isEqualToString:@"error"]) {
        [textfield.layer setBorderColor:error.CGColor];
    }
}

- (void)configureAuthorizeButton {
    UIColor *color = [UIColor colorNamed:@"Little Boy Blue"];
    UIImage *person = [UIImage imageNamed:@"Person"];
    UIImage *personFill = [UIImage imageNamed:@"Person Fill"];
    
    [self.authorizeButton.layer setBorderColor:color.CGColor];
    [self.authorizeButton.layer setBorderWidth:2];
    [self.authorizeButton.layer setCornerRadius:10];
    self.authorizeButton.clipsToBounds = TRUE;
    
    [self.authorizeButton setImage:person forState:UIControlStateNormal];
    [self.authorizeButton setImage:personFill forState:UIControlStateHighlighted];
    [self.authorizeButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 5)];
}

- (void)highLightAuthorizeButton:(BOOL)highlighted {
    [self.authorizeButton setHighlighted:highlighted];
    UIColor *color = [UIColor colorNamed:@"Little Boy Blue"];
    
    if (highlighted) {
        self.authorizeButton.backgroundColor = [color colorWithAlphaComponent:0.2];
    } else {
        self.authorizeButton.backgroundColor = [UIColor whiteColor];
    }
}

- (void)configureDIgitButton:(UIButton *) button {
    UIColor *color = [UIColor colorNamed:@"Little Boy Blue"];
    [button.layer setBorderWidth:1.5];
    [button.layer setBorderColor:color.CGColor];
    [button.layer setCornerRadius:25];
}




- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:true];
    return true;
}




@end


@implementation AutorizationViewController (KeyboardHandling)

- (void)subscribeOnKeyboardEvents {
    // Keyboard will show
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(keyboardWillShow:)
                                               name:UIKeyboardWillShowNotification
                                             object:nil];
    // Keyboard will hide
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(keyboardWillHide:)
                                               name:UIKeyboardWillHideNotification
                                             object:nil];
}

- (void)hideWhenTappedAround {
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(hide)];
    [self.view addGestureRecognizer:gesture];
}

- (void)hide {
    [self.view endEditing:true];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    CGRect rect = [(NSValue *)notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    [self updateTopConstraintWith:5.0 andBottom:rect.size.height - self.view.safeAreaInsets.bottom + 5.0];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    [self updateTopConstraintWith:200.0 andBottom:0.0];
}

- (void)updateTopConstraintWith:(CGFloat) constant andBottom:(CGFloat) bottomConstant {
    // Change your constraint constants
    self.topConstraint.constant = constant;
    self.bottomConstraint.constant = bottomConstant;
    [UIView animateWithDuration:0.2 animations:^{
        [self.view layoutIfNeeded];
    }];
}

@end


