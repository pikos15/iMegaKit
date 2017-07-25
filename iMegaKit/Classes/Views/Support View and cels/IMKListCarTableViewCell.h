//
//  IMKListCarTableViewCell.h
//  iMegaKit
//
//  Created by Konstantin Pikhterev on 24.07.17.
//  Copyright © 2017 MegaKit. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Car;

@interface IMKListCarTableViewCell : UITableViewCell

+ (NSString *)cellIdentifier;
- (void)configureCellWithObject:(Car *)car;

@end
