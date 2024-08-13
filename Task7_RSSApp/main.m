//
//  main.m
//  Task7_RSSApp
//
//  Created by Anton Kushnerov on 4.07.21.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

/**
 * Основная функция, которая запускает приложение.
 * @param argc Количество аргументов командной строки.
 * @param argv Массив строк, представляющий аргументы командной строки.
 * @return Возвращает код завершения приложения.
 */
int main(int argc, char * argv[]) {
    NSString *appDelegateClassName;
    @autoreleasepool {
        // Настройка кода, который может создать объекты, автоматически освобождаемые позже.
        appDelegateClassName = NSStringFromClass([AppDelegate class]);
    }
    // Запуск основного цикла приложения, создание и настройка UIApplication и делегата приложения.
    return UIApplicationMain(argc, argv, nil, appDelegateClassName);
}
