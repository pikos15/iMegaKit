//
//  IMKInfoHelper.m
//  iMegaKit
//
//  Created by Konstantin Pikhterev on 22.07.17.
//  Copyright © 2017 MegaKit. All rights reserved.
//

#import "IMKInfoHelper.h"

#import <UIKit/UIKit.h>

static const CGFloat IMKIncrement = 0.05f;

@implementation IMKInfoHelper
//PK 296 - Служебный класс - обычно их несколько, тут только один из-за дефицита времени
//Добавление границ для вьюшек
+ (void)addRoundBorderToView:(UIView *)view
            withCornerRadius:(float)cornerRadius
                 borderWidth:(float)borderWidth
                 borderColor:(UIColor *)borderColor {
    
    view.layer.cornerRadius = cornerRadius;
    view.layer.borderWidth = borderWidth;
    view.layer.borderColor = borderColor.CGColor;
}
//PK 296 - Добавление тени для Color menu
+ (void)addLeftSideShadow:(UIView *)view {
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(5, -5, 5, 5);
    CGRect shadowPathExcludingLeft = UIEdgeInsetsInsetRect(view.bounds, contentInsets);
    
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:shadowPathExcludingLeft];
    view.layer.masksToBounds = NO;
    view.layer.shadowColor = [UIColor blackColor].CGColor;
    view.layer.shadowOffset = CGSizeMake(0.0f, 5.0f);
    view.layer.shadowOpacity = 0.5f;
    view.layer.shadowPath = shadowPath.CGPath;
    view.layer.shadowRadius = 5.0;
}
//PK 296 - Получение массива цветов
+ (NSArray *)colorsArray {
    
    NSMutableArray *colors = [NSMutableArray array];
    
    for (float hue = 0.0; hue < 1.0; hue += IMKIncrement) {
        UIColor *color = [UIColor colorWithHue:hue
                                    saturation:1.0
                                    brightness:1.0
                                         alpha:1.0];
        [colors addObject:color];
    }
    return [colors copy];
}

@end
