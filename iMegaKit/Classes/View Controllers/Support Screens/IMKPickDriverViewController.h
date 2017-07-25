//
//  IMKPickDriverViewController.h
//  iMegaKit
//
//  Created by Константин on 21.07.17.
//  Copyright © 2017 MegaKit. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "IMKBaseViewController.h"

@class Driver;

@protocol IBAPickDriverDelegate

- (void)driverFromPickDriverController:(Driver *)driver;

@end

@interface IMKPickDriverViewController : IMKBaseViewController

@property (weak, nonatomic) id <IBAPickDriverDelegate> delegate;
@property (nonatomic) NSInteger driverId;

@end
