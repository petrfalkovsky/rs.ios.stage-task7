//
//  UIConfiguration.m
//  Task7_RSSApp
//
//  Created by 123 on 13.08.2024.
//

#import "UIConfiguration.h"

@implementation UIConfiguration

// Настройка текстового поля
+ (void)configureTextField:(UITextField *)textfield {
    // Установка радиуса закругления углов текстового поля
    [textfield.layer setCornerRadius:5];
    // Установка ширины границы текстового поля
    [textfield.layer setBorderWidth:1.5];
}

// Настройка кнопки авторизации
+ (void)configureAuthorizeButton:(UIButton *)button {
    // Цвет границы кнопки
    UIColor *borderColor = [UIColor colorNamed:@"Little Boy Blue"];
    // Изображения для кнопки в разных состояниях
    UIImage *personImage = [UIImage imageNamed:@"Person"];
    UIImage *personFillImage = [UIImage imageNamed:@"Person Fill"];
    
    // Установка цвета и ширины границы кнопки
    [button.layer setBorderColor:borderColor.CGColor];
    [button.layer setBorderWidth:2];
    // Установка радиуса закругления углов кнопки
    [button.layer setCornerRadius:10];
    // Обрезка содержимого кнопки по ее границам
    button.clipsToBounds = YES;
    
    // Установка изображения для кнопки в нормальном состоянии
    [button setImage:personImage forState:UIControlStateNormal];
    // Установка изображения для кнопки в состоянии выделения
    [button setImage:personFillImage forState:UIControlStateHighlighted];
    // Установка отступов изображения внутри кнопки
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 5)];
}

// Настройка кнопки с цифрой
+ (void)configureDigitButton:(UIButton *)button {
    // Цвет границы кнопки
    UIColor *borderColor = [UIColor colorNamed:@"Little Boy Blue"];
    // Установка ширины границы кнопки
    [button.layer setBorderWidth:1.5];
    // Установка цвета границы кнопки
    [button.layer setBorderColor:borderColor.CGColor];
    // Установка радиуса закругления углов кнопки
    [button.layer setCornerRadius:25];
}

@end
