//
//  IMKInfoHelper.h
//  iMegaKit
//
//  Created by Konstantin Pikhterev on 22.07.17.
//  Copyright © 2017 MegaKit. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UIView;
@class UIColor;

@interface IMKInfoHelper : NSObject

+ (void)addRoundBorderToView:(UIView *)view
            withCornerRadius:(float)cornerRadius
                 borderWidth:(float)borderWidth
                 borderColor:(UIColor *)borderColor;

+ (void)addLeftSideShadow:(UIView *)view;
+ (NSArray *)colorsArray;

@end
