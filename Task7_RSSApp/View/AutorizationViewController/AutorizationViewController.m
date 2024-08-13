//
//  AutorizationViewController.m
//  Task7_RSSApp
//
//  Created by Anton Kushnerov on 4.07.21.
//

#import "AutorizationViewController.h"
#import "KeyboardHandling.h"
#import "UIConfiguration.h"

@interface AutorizationViewController () <UITextFieldDelegate>

// UI Elements
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;  // Заголовок экрана
@property (weak, nonatomic) IBOutlet UITextField *loginTextfield;  // Поле ввода логина
@property (weak, nonatomic) IBOutlet UITextField *passwordTextfield;  // Поле ввода пароля
@property (weak, nonatomic) IBOutlet UIButton *authorizeButton;  // Кнопка авторизации
@property (weak, nonatomic) IBOutlet UIView *secureView;  // Вид для отображения после успешной авторизации
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;  // Метка для отображения результатов ввода пин-кода
@property (weak, nonatomic) IBOutlet UIButton *button1;  // Кнопка для ввода цифры 1
@property (weak, nonatomic) IBOutlet UIButton *button2;  // Кнопка для ввода цифры 2
@property (weak, nonatomic) IBOutlet UIButton *button3;  // Кнопка для ввода цифры 3
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;  // Верхнее ограничение для управления видимостью клавиатуры
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;  // Нижнее ограничение для управления видимостью клавиатуры

// Данные пользователя
@property (strong, nonatomic) NSString *username;  // Логин пользователя
@property (strong, nonatomic) NSString *password;  // Пароль пользователя

// Массив для хранения введенного пин-кода
@property (strong, nonatomic) NSMutableArray<NSNumber *> *pincodeArray;

@end

@implementation AutorizationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Настройка UI и подписка на события клавиатуры
    [self setupUI];
    [self subscribeOnKeyboardEvents];
    [self hideWhenTappedAround];
}

#pragma mark - Actions

/**
 * Обрабатка начала редактирования логина
 */
- (IBAction)loginEditingDidBegin:(id)sender {
    [self setState:@"appear" forTextfield:self.loginTextfield];
}

/**
 * Обрабатывает нажатие на кнопку авторизации.
 */
- (IBAction)authorizeButtonTapped:(id)sender {
    [self handleAuthorization];
}

/**
 * Обрабатывает нажатие  кнопки с цифрой
 */
- (IBAction)digitButtonTapped:(UIButton *)sender {
    [self handleDigitButtonTap:sender];
}

#pragma mark - Private Methods

// Настройка UI элементов
- (void)setupUI {
    [UIConfiguration configureTextField:self.loginTextfield];
    [UIConfiguration configureTextField:self.passwordTextfield];
    [UIConfiguration configureAuthorizeButton:self.authorizeButton];
    [UIConfiguration configureDigitButton:self.button1];
    [UIConfiguration configureDigitButton:self.button2];
    [UIConfiguration configureDigitButton:self.button3];
    
    // Настройка внешнего вида secureView
    self.secureView.layer.borderWidth = 2;
    self.secureView.layer.borderColor = [UIColor clearColor].CGColor;
    self.secureView.layer.cornerRadius = 10;
    
    // Инициализация массива для пин-кода
    self.pincodeArray = [NSMutableArray new];
}

// Обработка авторизации
- (void)handleAuthorization {
    // Правильные логин и пароль
    NSString *correctLogin = @"username";
    NSString *correctPassword = @"password";
    
    // Проверка правильности логина и пароля
    BOOL isCorrect = ([self.loginTextfield.text isEqualToString:correctLogin] &&
                      [self.passwordTextfield.text isEqualToString:correctPassword]);
    
    // Скрытие клавиатуры при нажатии на пустое место
    [self hideWhenTappedAround];
    
    // Настройка состояния полей ввода
    [self setState:([self.loginTextfield.text isEqualToString:correctLogin]) ? @"correct" : @"error"
      forTextfield:self.loginTextfield];
    
    [self setState:([self.passwordTextfield.text isEqualToString:correctPassword]) ? @"correct" : @"error"
      forTextfield:self.passwordTextfield];
    
    // Если логин и пароль верные, скрываем поля ввода и показываем secureView
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
- (void)handleDigitButtonTap:(UIButton *)sender {
    // Форматирование текста кнопки как числа
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    NSNumber *senderValue = [formatter numberFromString:sender.titleLabel.text];
    
    // Добавление введенной цифры в массив пин-кода
    [self.pincodeArray addObject:senderValue];
    
    // Очистка результата, если введен первый символ
    if (self.pincodeArray.count == 1) {
        self.resultLabel.text = @" ";
    }
    
    // Обновление отображаемого результата
    self.resultLabel.text = [self.resultLabel.text stringByAppendingFormat:@"%d ", senderValue.intValue];
    
    // Проверка пин-кода
    if (self.pincodeArray.count == 3) {
        UIColor *incorrectColor = [UIColor colorNamed:@"Venetian Red"];
        UIColor *correctColor = [UIColor colorNamed:@"Turquoise Green"];
        
        // Проверка правильности пин-кода
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

// Отображение уведомления
- (void)showAlert {
    // Создание и настройка контроллера алерта
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"Welcome"
                                                                     message:@"You are successfully authorized!"
                                                              preferredStyle:UIAlertControllerStyleAlert];
    
    // Добавление действия для сброса авторизации
    UIAlertAction *refreshAction = [UIAlertAction actionWithTitle:@"Refresh"
                                                            style:UIAlertActionStyleDestructive
                                                          handler:^(UIAlertAction * _Nonnull action) {
        // Сброс состояния UI после авторизации
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

// Установка состояния для текстового поля
- (void)setState:(NSString *)state forTextfield:(UITextField *)textfield {
    UIColor *appearColor = [UIColor colorNamed:@"Black Coral"];
    UIColor *correctColor = [UIColor colorNamed:@"Turquoise Green"];
    UIColor *errorColor = [UIColor colorNamed:@"Venetian Red"];
    
    // Настройка состояния текстового поля
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

@end
