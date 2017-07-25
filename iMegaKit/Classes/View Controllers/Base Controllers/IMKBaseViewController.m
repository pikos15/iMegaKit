//
//  IMKBaseViewController.m
//  iMegaKit
//
//  Created by Konstantin Pikhterev on 24.07.17.
//  Copyright © 2017 MegaKit. All rights reserved.
//

#import "IMKBaseViewController.h"

@interface IMKBaseViewController ()

@end

@implementation IMKBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

#pragma mark - Allerts -
//PK 296 - Базовый контроллер с часто используемыми методами
- (void)showAlertWithTitle:(NSString *)title
                   message:(NSString *)message
               buttonTitle:(NSString *)buttonTitle {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:[NSString stringWithFormat:@"\n%@", message]
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:buttonTitle
                                              style:UIAlertActionStyleDefault
                                            handler:nil]];
    
    [self presentViewController:alert
                       animated:YES
                     completion:nil];
}

#pragma mark - View Controllers Presentation -

- (void)presentViewController:(UIViewController *)viewController {
    [self presentViewController:viewController
                       animated:NO
                     completion:nil];
}

@end
