//
//  CoinViewController.m
//  CoinDrop
//
//  Created by Programmer Four on 15/7/22.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "CoinViewController.h"
#import "CoinView.h"
#import <AudioToolbox/AudioToolbox.h>

@interface CoinViewController ()<CoinViewDelegate>

@end

@implementation CoinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)getCoin:(id)sender {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    CoinView *coinView = [[CoinView alloc] initWithFrame:window.bounds];
    coinView.delegate = self;
    coinView.backgroundColor = [UIColor clearColor];
    [window addSubview:coinView];
    [coinView showCoinView];
}

#pragma mark CoinViewDelegate
- (void)timeToPlayVoice
{
    NSString *audioFile=[[NSBundle mainBundle] pathForResource:@"bgm_coin_01" ofType:@"mp3"];
    NSURL *fileUrl=[NSURL fileURLWithPath:audioFile];
    //1.获得系统声音ID
    SystemSoundID soundID=0;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(fileUrl), &soundID);
    //如果需要在播放完之后执行某些操作，可以调用如下方法注册一个播放完成回调函数
    AudioServicesAddSystemSoundCompletion(soundID, NULL, NULL, NULL, NULL);
    //2.播放音频
    AudioServicesPlaySystemSound(soundID);//播放音效
}

- (void)coinViewAnimationDidStop:(CoinView *)coinView
{
    [coinView removeFromSuperview];
    coinView = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
