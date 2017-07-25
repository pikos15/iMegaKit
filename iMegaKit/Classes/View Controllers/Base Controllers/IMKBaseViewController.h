//
//  IMKBaseViewController.h
//  iMegaKit
//
//  Created by Konstantin Pikhterev on 24.07.17.
//  Copyright © 2017 MegaKit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IMKBaseViewController : UIViewController

- (void)showAlertWithTitle:(NSString *)title
                   message:(NSString *)message
               buttonTitle:(NSString *)buttonTitle;

- (void)presentViewController:(UIViewController *)viewController;

@end
