//
//  IMKAddCarViewController.h
//  iMegaKit
//
//  Created by Konstantin Pikhterev on 20.07.17.
//  Copyright © 2017 MegaKit. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "IMKBaseViewController.h"

@class Car;

@interface IMKAddCarViewController : IMKBaseViewController

@property (strong, nonatomic) Car *car;

@end
