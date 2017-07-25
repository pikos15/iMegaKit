//
//  IMKPickDriverCell.m
//  iMegaKit
//
//  Created by Konstantin Pikhterev on 22.07.17.
//  Copyright © 2017 MegaKit. All rights reserved.
//

#import "IMKPickDriverCell.h"

#import "Driver+CoreDataClass.h"
#import "Driver+CoreDataProperties.h"

@interface IMKPickDriverCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation IMKPickDriverCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}
//PK 296 - Создание ячейки для водителя
+ (NSString *)cellIdentifier {
    return @"IMKPickDriverCell";
}

- (void)configureCellWithObject:(Driver *)driver {
    
    self.nameLabel.text = driver.firstName;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

@end
