//
//  IMKListCarTableViewCell.m
//  iMegaKit
//
//  Created by Konstantin Pikhterev on 24.07.17.
//  Copyright © 2017 MegaKit. All rights reserved.
//

#import "IMKListCarTableViewCell.h"

#import "IMKInfoHelper.h"

#import "Car+CoreDataClass.h"
#import "Car+CoreDataProperties.h"
#import "Driver+CoreDataClass.h"
#import "Driver+CoreDataProperties.h"

@interface IMKListCarTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageViewCar;
@property (weak, nonatomic) IBOutlet UILabel *modelLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *driverLabel;
@property (weak, nonatomic) IBOutlet UIView *colorView;

@end

@implementation IMKListCarTableViewCell
//PK 296 - Создание ячейки для авто
+ (NSString *)cellIdentifier {
    
    return @"IMKListCarTableViewCell";
}

- (void)configureCellWithObject:(Car *)car {
    
    self.imageViewCar.image = [UIImage imageWithData:car.image];
    self.modelLabel.text = car.model;
    self.numberLabel.text = car.number;
    self.driverLabel.text = car.owner.firstName;
    
    self.colorView.backgroundColor = (UIColor *)[NSKeyedUnarchiver unarchiveObjectWithData:(NSData *)car.color];
    [IMKInfoHelper addRoundBorderToView:self.colorView
                       withCornerRadius:10.0f
                            borderWidth:1.0f
                            borderColor:[UIColor lightGrayColor]];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
