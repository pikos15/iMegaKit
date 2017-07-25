//
//  IMKPickColorCell.h
//  iMegaKit
//
//  Created by Konstantin Pikhterev on 22.07.17.
//  Copyright © 2017 MegaKit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IMKPickColorCell : UICollectionViewCell

+ (NSString *)cellIdentifier;

- (void)configureCellWithObject:(UIColor *)color;

@end
