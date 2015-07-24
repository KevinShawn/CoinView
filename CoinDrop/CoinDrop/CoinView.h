//
//  CoinView.h
//  CoinDrop
//
//  Created by Programmer Four on 15/7/21.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CoinView;
@protocol CoinViewDelegate <NSObject>

@optional
- (void)coinViewAnimationDidStop:(CoinView *)coinView;
- (void)timeToPlayVoice;

@end

@interface CoinView : UIView

@property (nonatomic, weak) id<CoinViewDelegate>delegate;
@property (nonatomic) long sincerityValue;
- (void)showCoinView;

@end
