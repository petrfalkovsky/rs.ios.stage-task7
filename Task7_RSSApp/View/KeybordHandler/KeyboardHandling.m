//
//  KeyboardHandling.m
//  Task7_RSSApp
//
//  Created by 123 on 13.08.2024.
//

#import "KeyboardHandling.h"

@implementation UIViewController (KeyboardHandling)

// Подписка на события появления и скрытия клавиатуры
- (void)subscribeOnKeyboardEvents {
    // Подписка на уведомление о появлении клавиатуры
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(keyboardWillShow:)
                                               name:UIKeyboardWillShowNotification
                                             object:nil];
    // Подписка на уведомление о скрытии клавиатуры
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(keyboardWillHide:)
                                               name:UIKeyboardWillHideNotification
                                             object:nil];
}

// Скрытие клавиатуры при касании вне текстового поля
- (void)hideWhenTappedAround {
    // Создание распознавателя жестов для касания
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(hideKeyboard)];
    // Добавление распознавателя жестов на вид контроллера
    [self.view addGestureRecognizer:tapGesture];
}

// Скрытие клавиатуры
- (void)hideKeyboard {
    // Завершение редактирования всех текстовых полей
    [self.view endEditing:YES];
}

// Обработка появления клавиатуры
- (void)keyboardWillShow:(NSNotification *)notification {
    // Получение рамки клавиатуры из уведомления
    CGRect keyboardFrame = [(NSValue *)notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    // Расчет высоты клавиатуры с учетом безопасной области
    CGFloat keyboardHeight = keyboardFrame.size.height - self.view.safeAreaInsets.bottom;
    // Обновление ограничения (constraints) для учета высоты клавиатуры
    [self updateTopConstraintWith:5.0 andBottom:keyboardHeight + 5.0];
}

// Обработка скрытия клавиатуры
- (void)keyboardWillHide:(NSNotification *)notification {
    // Восстановление начального ограничения (constraints) для вида
    [self updateTopConstraintWith:200.0 andBottom:0.0];
}

// Метод для обновления ограничений (constraints) вида
// Этот метод следует переопределить в вашем контроллере для настройки ограничений
- (void)updateTopConstraintWith:(CGFloat)constant andBottom:(CGFloat)bottomConstant {
    // Переопределите этот метод в вашем контроллере для обновления ограничений
}

@end
