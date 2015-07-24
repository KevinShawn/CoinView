//
//  UILabel+MSFlickerNumber.h
//  CoinDrop
//
//  Created by Programmer Four on 15/7/23.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (MSFlickerNumber)

- (void)numberChangeWithAnimationDuration:(NSTimeInterval)duration
                                fromValue:(NSInteger)from
                                  toValue:(NSInteger)to;

@end
