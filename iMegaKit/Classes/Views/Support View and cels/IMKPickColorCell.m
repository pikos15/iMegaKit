//
//  IMKPickColorCell.m
//  iMegaKit
//
//  Created by Konstantin Pikhterev on 22.07.17.
//  Copyright © 2017 MegaKit. All rights reserved.
//

#import "IMKPickColorCell.h"

#import "IMKInfoHelper.h"

@interface IMKPickColorCell ()

@property (weak, nonatomic) IBOutlet UIView *colorView;

@end

@implementation IMKPickColorCell
//PK 296 - Создание ячейки для цвета
+ (NSString *)cellIdentifier {
    return @"IMKPickColorCell";
}

- (void)configureCellWithObject:(UIColor *)color {
    
    [self.colorView setBackgroundColor:color];
    [IMKInfoHelper addRoundBorderToView:self.colorView
                       withCornerRadius:20.0f
                            borderWidth:1.0f
                            borderColor:[UIColor lightGrayColor]];

}

@end
