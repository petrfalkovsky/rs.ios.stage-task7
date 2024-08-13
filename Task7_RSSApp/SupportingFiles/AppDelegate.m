//
//  AppDelegate.m
//  Task7_RSSApp
//
//  Created by Anton Kushnerov on 4.07.21.
//

#import "AppDelegate.h"
#import "AutorizationViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

/**
 * Метод, который вызывается, когда приложение завершает запуск.
 * @param application Объект UIApplication, представляющий текущее приложение.
 * @param launchOptions Словарь с информацией о причине запуска приложения.
 * @return Возвращает YES, если запуск завершился успешно; иначе NO.
 */
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Создание окна приложения с размерами экрана устройства.
    UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    // Инициализация главного контроллера вида с использованием XIB-файла.
    AutorizationViewController *rootViewController = [[AutorizationViewController alloc] initWithNibName:@"AutorizationViewController" bundle:nil];
    
    // Установка главного контроллера вида окна.
    [window setRootViewController:rootViewController];
    
    // Присвоение созданного окна свойству window и отображение его на экране.
    self.window = window;
    [self.window makeKeyAndVisible];
    
    // Возвращение YES для обозначения успешного завершения запуска.
    return YES;
}

@end
