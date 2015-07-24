//
//  UILabel+MSFlickerNumber.m
//  CoinDrop
//
//  Created by Programmer Four on 15/7/23.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "UILabel+MSFlickerNumber.h"

@implementation UILabel (MSFlickerNumber)

- (void)numberChangeWithAnimationDuration:(NSTimeInterval)duration
                                fromValue:(NSInteger)from
                                  toValue:(NSInteger)to;
{
    BOOL add = (from - to > 0)?NO:YES;
    self.text = [NSString stringWithFormat:@"%ld", from];
    NSTimeInterval frequent = duration / labs(to - from);
    [NSTimer scheduledTimerWithTimeInterval:frequent
                                     target:self
                                   selector:@selector(labelAnimate:)
                                   userInfo:@[@(to), @(add)]
                                    repeats:YES];
}

- (void)labelAnimate:(NSTimer *)timer
{
    NSArray *array = timer.userInfo;
    NSInteger fromValue = [self.text integerValue];
    NSInteger toValue = [[array firstObject] integerValue];
    BOOL add = [[array lastObject] boolValue];
    if (add) {
        fromValue++;
        self.text = [NSString stringWithFormat:@"%ld", fromValue];
    }
    else {
        fromValue--;
        self.text = [NSString stringWithFormat:@"%ld", fromValue];
    }
    if (fromValue == toValue) {
        [timer invalidate];
        timer = nil;
    }
}

@end
