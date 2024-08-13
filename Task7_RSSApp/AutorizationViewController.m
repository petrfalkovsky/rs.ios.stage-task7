//
//  AutorizationViewController.m
//  Task7_RSSApp
//
//  Created by Anton Kushnerov on 4.07.21.
//

#import "AutorizationViewController.h"

@interface AutorizationViewController () <UITextFieldDelegate, UITextViewDelegate>

// IBOutlets
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;                   // Заголовок экрана
@property (weak, nonatomic) IBOutlet UITextField *loginTextfield;           // Поле для ввода логина
@property (weak, nonatomic) IBOutlet UITextField *passwordTextfield;        // Поле для ввода пароля
@property (weak, nonatomic) IBOutlet UIButton *authorizeButton;             // Кнопка авторизации
@property (weak, nonatomic) IBOutlet UIView *secureView;                    // Вид для ввода кода безопасности
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;                  // Метка для отображения результата ввода кода
@property (weak, nonatomic) IBOutlet UIButton *button1;                     // Кнопка для ввода первой цифры кода
@property (weak, nonatomic) IBOutlet UIButton *button2;                     // Кнопка для ввода второй цифры кода
@property (weak, nonatomic) IBOutlet UIButton *button3;                     // Кнопка для ввода третьей цифры кода
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;     // Ограничение для верхнего отступа
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;  // Ограничение для нижнего отступа

// Properties
@property (strong, nonatomic) NSString *username;                           // Логин пользователя
@property (strong, nonatomic) NSString *password;                           // Пароль пользователя
//@property (strong, nonatomic) NSMutableArray<NSNumber *> *pincodeArray;     // Массив для хранения введенного кода

@end

@interface AutorizationViewController (KeyboardHandling)

// Private methods related to keyboard handling
- (void)subscribeOnKeyboardEvents;                                                   // Подписка на события клавиатуры
- (void)updateTopConstraintWith:(CGFloat)constant andBottom:(CGFloat)bottomConstant; // Обновление ограничений для клавиатуры
- (void)hideWhenTappedAround;                                           // Скрыть клавиатуру при касании вне полей ввода

@end

@implementation AutorizationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self subscribeOnKeyboardEvents];                                   // Подписка на события клавиатуры
    [self hideWhenTappedAround];                                        // Скрытие клавиатуры при касании вне полей ввода
    
    self.loginTextfield.delegate = self;                                // Установка делегата для текстового поля логина
    self.passwordTextfield.delegate = self;                             // Установка делегата для текстового поля пароля
    
    self.pincodeArray = [NSMutableArray new];                           // Инициализация массива для кода безопасности
    
    [self configureTextField:self.loginTextfield];                      // Настройка текстового поля логина
    [self configureTextField:self.passwordTextfield];                   // Настройка текстового поля пароля
    [self setState:@"appear" forTextfield:self.loginTextfield];         // Настройка состояния для текстового поля логина
    [self setState:@"appear" forTextfield:self.passwordTextfield];      // Настройка состояния для текстового поля пароля
    
    [self configureAuthorizeButton];                                    // Настройка кнопки авторизации
    
    self.authorizeButton.titleEdgeInsets = UIEdgeInsetsMake(10, 20, 10, 20); // Настройка отступов для кнопки авторизации
    
    [self configureDigitButton:_button1];                               // Настройка кнопки цифры 1
    [self configureDigitButton:_button2];                               // Настройка кнопки цифры 2
    [self configureDigitButton:_button3];                               // Настройка кнопки цифры 3
    
    [self.secureView.layer setBorderWidth:2];
    [self.secureView.layer setBorderColor:[UIColor clearColor].CGColor];
    [self.secureView.layer setCornerRadius:10];
}

#pragma mark - Actions

/**
 * Обрабатывает начало редактирования поля логина.
 */
- (IBAction)loginEditingDidBegin:(id)sender {
    [self setState:@"appear" forTextfield:self.loginTextfield];
}

/**
 * Обрабатывает нажатие на кнопку авторизации.
 */
- (IBAction)authorizeButtonTapped:(id)sender {
    NSString *correctLogin = @"username";
    NSString *correctPassword = @"password";
    BOOL isCorrect = ([self.loginTextfield.text isEqualToString:correctLogin] &&
                      [self.passwordTextfield.text isEqualToString:correctPassword]);
    
    [self hideWhenTappedAround];
    
    [self setState:([self.loginTextfield.text isEqualToString:correctLogin]) ? @"correct" : @"error"
      forTextfield:self.loginTextfield];
    
    [self setState:([self.passwordTextfield.text isEqualToString:correctPassword]) ? @"correct" : @"error"
      forTextfield:self.passwordTextfield];
    
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

/**
 * Обрабатывает нажатие на кнопку с цифрой.
 */
- (IBAction)digitButtonTapped:(UIButton *)sender {
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    NSNumber *senderValue = [formatter numberFromString:sender.titleLabel.text];
    [self.pincodeArray addObject:senderValue];
    
    if (self.pincodeArray.count == 1) {
        self.resultLabel.text = @" ";
    }
    
    self.resultLabel.text = [self.resultLabel.text stringByAppendingFormat:@"%d ", senderValue.intValue];
    
    if (self.pincodeArray.count == 3) {
        UIColor *incorrectColor = [UIColor colorNamed:@"Venetian Red"];
        UIColor *correctColor = [UIColor colorNamed:@"Turquoise Green"];
        
        if ([self.pincodeArray isEqualToArray:@[@1, @3, @2]]) {
            [self.secureView.layer setBorderColor:correctColor.CGColor];
            [self showAlert];
        } else {
            [self.secureView.layer setBorderColor:incorrectColor.CGColor];
            self.resultLabel.text = @"_";
            [self.pincodeArray removeAllObjects];
        }
    } else {
        [self.secureView.layer setBorderColor:[UIColor clearColor].CGColor];
    }
}

#pragma mark - Private Methods

/**
 * Показывает алерт с сообщением об успешной авторизации.
 */
- (void)showAlert {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"Welcome"
                                                                     message:@"You are successfully authorized!"
                                                              preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *refreshAction = [UIAlertAction actionWithTitle:@"Refresh"
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
    
    [alertVC addAction:refreshAction];
    [self presentViewController:alertVC animated:YES completion:nil];
}

/**
 * Настраивает внешний вид текстового поля.
 */
- (void)configureTextField:(UITextField *)textfield {
    [textfield.layer setCornerRadius:5];
    [textfield.layer setBorderWidth:1.5];
}

/**
 * Устанавливает состояние для текстового поля.
 * @param state Состояние для установки. Возможные значения: "appear", "correct", "error".
 * @param textfield Текстовое поле, для которого устанавливается состояние.
 */
- (void)setState:(NSString *)state forTextfield:(UITextField *)textfield {
    UIColor *appearColor = [UIColor colorNamed:@"Black Coral"];
    UIColor *correctColor = [UIColor colorNamed:@"Turquoise Green"];
    UIColor *errorColor = [UIColor colorNamed:@"Venetian Red"];
    
    if ([state isEqualToString:@"appear"]) {
        [textfield setEnabled:YES];
        [textfield.layer setBorderColor:appearColor.CGColor];
        [textfield setAlpha:1];
    } else if ([state isEqualToString:@"correct"]) {
        [textfield.layer setBorderColor:correctColor.CGColor];
    } else if ([state isEqualToString:@"error"]) {
        [textfield.layer setBorderColor:errorColor.CGColor];
    }
}

/**
 * Настраивает внешний вид кнопки авторизации.
 */
- (void)configureAuthorizeButton {
    UIColor *borderColor = [UIColor colorNamed:@"Little Boy Blue"];
    UIImage *personImage = [UIImage imageNamed:@"Person"];
    UIImage *personFillImage = [UIImage imageNamed:@"Person Fill"];
    
    [self.authorizeButton.layer setBorderColor:borderColor.CGColor];
    [self.authorizeButton.layer setBorderWidth:2];
    [self.authorizeButton.layer setCornerRadius:10];
    self.authorizeButton.clipsToBounds = YES;
    
    [self.authorizeButton setImage:personImage forState:UIControlStateNormal];
    [self.authorizeButton setImage:personFillImage forState:UIControlStateHighlighted];
    [self.authorizeButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 5)];
}

/**
 * Настраивает внешний вид кнопки цифры.
 * @param button Кнопка для настройки.
 */
- (void)configureDigitButton:(UIButton *)button {
    UIColor *borderColor = [UIColor colorNamed:@"Little Boy Blue"];
    [button.layer setBorderWidth:1.5];
    [button.layer setBorderColor:borderColor.CGColor];
    [button.layer setCornerRadius:25];
}

#pragma mark - Keyboard Handling

/**
 * Подписывается на события отображения и скрытия клавиатуры.
 */
- (void)subscribeOnKeyboardEvents {
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(keyboardWillShow:)
                                               name:UIKeyboardWillShowNotification
                                             object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(keyboardWillHide:)
                                               name:UIKeyboardWillHideNotification
                                             object:nil];
}

/**
 * Добавляет жест для скрытия клавиатуры при касании вне полей ввода.
 */
- (void)hideWhenTappedAround {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                  action:@selector(hideKeyboard)];
    [self.view addGestureRecognizer:tapGesture];
}

/**
 * Скрывает клавиатуру.
 */
- (void)hideKeyboard {
    [self.view endEditing:YES];
}

/**
 * Обрабатывает событие отображения клавиатуры.
 * @param notification Уведомление с информацией о клавиатуре.
 */
- (void)keyboardWillShow:(NSNotification *)notification {
    CGRect keyboardFrame = [(NSValue *)notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyboardHeight = keyboardFrame.size.height - self.view.safeAreaInsets.bottom;
    
    [self updateTopConstraintWith:5.0 andBottom:keyboardHeight + 5.0];
}

/**
 * Обрабатывает событие скрытия клавиатуры.
 * @param notification Уведомление с информацией о клавиатуре.
 */
- (void)keyboardWillHide:(NSNotification *)notification {
    [self updateTopConstraintWith:200.0 andBottom:0.0];
}

/**
 * Обновляет верхнее и нижнее ограничение для учета высоты клавиатуры.
 * @param constant Новое значение для верхнего ограничения.
 * @param bottomConstant Новое значение для нижнего ограничения.
 */
- (void)updateTopConstraintWith:(CGFloat)constant andBottom:(CGFloat)bottomConstant {
    self.topConstraint.constant = constant;
    self.bottomConstraint.constant = bottomConstant;
    
    [UIView animateWithDuration:0.2 animations:^{
        [self.view layoutIfNeeded];
    }];
}

@end
