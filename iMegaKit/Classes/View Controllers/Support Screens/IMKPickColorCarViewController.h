//
//  IMKPickColorCarViewController.h
//  iMegaKit
//
//  Created by Konstantin Pikhterev on 22.07.17.
//  Copyright © 2017 MegaKit. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol IMKPickColorCarDelegate

- (void)colorFromPickColorCarController:(UIColor *)color;

@end

@interface IMKPickColorCarViewController : UIViewController

@property (weak, nonatomic) id <IMKPickColorCarDelegate> delegate;
@property (strong, nonatomic) UIColor *selectedColor;

@end
