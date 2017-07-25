
//
//  IMKPickDriverCell.h
//  iMegaKit
//
//  Created by Konstantin Pikhterev on 22.07.17.
//  Copyright © 2017 MegaKit. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Driver;

@interface IMKPickDriverCell : UITableViewCell

+ (NSString *)cellIdentifier;
- (void)configureCellWithObject:(Driver *)driver;

@end
