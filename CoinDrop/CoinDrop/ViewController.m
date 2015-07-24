//
//  ViewController.m
//  CoinDrop
//
//  Created by Programmer Four on 15/7/21.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "ViewController.h"
#import "CoinView.h"
#import "UILabel+MSFlickerNumber.h"

@interface ViewController ()<UICollisionBehaviorDelegate>
//@property (nonatomic, strong) NSArray *coins;

@property (weak, nonatomic) IBOutlet UIButton *btn;
//@property (nonatomic, strong) UIDynamicAnimator *animator;

@property (nonatomic, strong) UIView *greenView;

@property (nonatomic, strong) NSArray *left;
@property (nonatomic, strong) UIDynamicAnimator *leftAnimator;

@property (nonatomic, strong) NSArray *middle;
@property (nonatomic, strong) UIDynamicAnimator *middleAnimator;

@property (nonatomic, strong) NSArray *right;
@property (nonatomic, strong) UIDynamicAnimator *rightAnimator;

@property (nonatomic, strong) NSArray *randomArray;
@property (nonatomic, strong) UIDynamicAnimator *randomAnimator;


//@property (nonatomic, strong) CoinView *coinView;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (nonatomic) NSInteger num;
@end

@implementation ViewController

//- (CoinView *)coinView
//{
//    if (!_coinView) {
//        UIWindow *window = [UIApplication sharedApplication].keyWindow;
//        _coinView = [[CoinView alloc] initWithFrame:window.bounds];
//        _coinView.backgroundColor = [UIColor clearColor];
//        [window addSubview:_coinView];
//    }
//    return _coinView;
//}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(showLabel) userInfo:nil repeats:YES];
    [self.numberLabel numberChangeWithAnimationDuration:1 fromValue:8000 toValue:1000];
}

- (void)showLabel
{
    self.num = self.num + [self getRandomValue] * 50;
    self.numberLabel.text = [NSString stringWithFormat:@"%ld", self.num];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(-100, -200, self.view.bounds.size.width + 200, self.view.bounds.size.height + 200)];
    view.backgroundColor = [UIColor clearColor];
    [self.view addSubview:view];
    self.greenView = view;
    
    [self.view bringSubviewToFront:self.btn];
    
    NSMutableArray *left = [[NSMutableArray alloc] init];
    NSMutableArray *middle = [[NSMutableArray alloc] init];
    NSMutableArray *right = [[NSMutableArray alloc] init];
    NSMutableArray *randoms = [[NSMutableArray alloc] init];
    
    CGRect centerRect = CGRectMake(self.greenView.center.x - 70, -MAXFLOAT, 150, MAXFLOAT);
    NSLog(@"centerRect:%@", NSStringFromCGRect(centerRect));
    for (int i = 0; i < 20; i++) {
        UIImageView *coin = [[UIImageView alloc] initWithFrame:CGRectMake(120 + [self getRandomValue] * 40, [self getRandomValue] * 20, 20, 20)];
        coin.image = [UIImage imageNamed:@"sincerityCoin"];
        [view addSubview:coin];
        
        if ([self getRandomValue] % 3 == 0 && randoms.count < 8) {
            //跳出8个以下的随机imageView来做点不同的动画
            [randoms addObject:coin];
        }
        else {
            CGPoint coinCenter = [self.greenView convertPoint:coin.center toView:self.view];
            NSLog(@"coinCenter:%@, coin.center:%@", NSStringFromCGPoint(coinCenter),NSStringFromCGPoint(coin.center));
            if (CGRectContainsPoint(centerRect, coinCenter)) {
                [middle addObject:coin];
            }
            else if (centerRect.origin.x > coinCenter.x) {
                [left addObject:coin];
            }
            else if (centerRect.origin.x < coinCenter.x) {
                [right addObject:coin];
            }
        }
    }
    self.left = [left copy];
    self.middle = [middle copy];
    self.right = [right copy];
    self.randomArray = [randoms copy];
}

- (IBAction)dropCoin:(id)sender {
    [self configureLeftAnimator];
    [self configureMiddleAnimator];
    [self configureRightAnimator];
    [self configureRandomAnimator];
    
}

- (void)configureLeftAnimator
{
    self.leftAnimator = [self dynamicAnimator];
    [self.leftAnimator addBehavior:[self defautDynamicItemBehviorWithItems:self.left]];
    [self.leftAnimator addBehavior:[self collisionBehaviorWithItems:self.left]];
    [self.leftAnimator addBehavior:[self defaultGravityBehaviorWithItems:self.left]];
}

- (void)configureMiddleAnimator
{
    self.middleAnimator = [self dynamicAnimator];
    [self.middleAnimator addBehavior:[self defautDynamicItemBehviorWithItems:self.middle]];
    [self.middleAnimator addBehavior:[self collisionBehaviorWithItems:self.middle]];
    [self.middleAnimator addBehavior:[self defaultGravityBehaviorWithItems:self.middle]];

}

- (void)configureRightAnimator
{
    self.rightAnimator = [self dynamicAnimator];
    [self.rightAnimator addBehavior:[self defautDynamicItemBehviorWithItems:self.right]];
    [self.rightAnimator addBehavior:[self collisionBehaviorWithItems:self.right]];
    [self.rightAnimator addBehavior:[self defaultGravityBehaviorWithItems:self.right]];
}

- (void)configureRandomAnimator
{
    self.randomAnimator = [self dynamicAnimator];
    [self.randomAnimator addBehavior:[self dynamicItemBehviorWithElasticity:0.5 andDensity:2 andItems:self.randomArray]];
    [self.randomAnimator addBehavior:[self collisionBehaviorWithItems:self.randomArray]];
    [self.randomAnimator addBehavior:[self gravityBehaviorWithItems:self.randomArray andMagnitude:2]];
}

// 创建一个DynamicAnimator管理
- (UIDynamicAnimator *)dynamicAnimator
{
    // 创建animator
    UIDynamicAnimator *animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.greenView];
    return animator;
}

/**
 *  默认的ITEM行为 left middle right 都用这个
 */
- (UIDynamicItemBehavior *)defautDynamicItemBehviorWithItems:(NSArray *)items
{
    return [self dynamicItemBehviorWithElasticity:0.5 andDensity:12 andItems:items];
}

- (UIDynamicItemBehavior *)dynamicItemBehviorWithElasticity:(CGFloat)elasticity
                                                 andDensity:(CGFloat)density
                                                   andItems:(NSArray *)items
{
    // 创建behaviorItem
    UIDynamicItemBehavior *itemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:items];
    itemBehavior.allowsRotation = YES;
    itemBehavior.elasticity = elasticity;
    itemBehavior.density = density;
    return itemBehavior;
}

// 撞击动画
- (UICollisionBehavior *)collisionBehaviorWithItems:(NSArray *)items
{
    UICollisionBehavior *collision = [[UICollisionBehavior alloc] initWithItems:items];
    collision.translatesReferenceBoundsIntoBoundary = YES;
    collision.collisionDelegate = self;
    collision.collisionMode = UICollisionBehaviorModeBoundaries;
    return collision;
}

/**
 *  默认的重力行为 left middle right 都用这个
 */
- (UIGravityBehavior *)defaultGravityBehaviorWithItems:(NSArray *)items
{
    return [self gravityBehaviorWithItems:items andMagnitude:2];
}

// 重力
- (UIGravityBehavior *)gravityBehaviorWithItems:(NSArray *)items
                                   andMagnitude:(CGFloat)magnitude
{
    UIGravityBehavior *gravity = [[UIGravityBehavior alloc] initWithItems:items];
    gravity.magnitude = magnitude;
    return gravity;
}

// 推的动画
- (UIPushBehavior *)pushWithItems:(NSArray *)items andAngle:(CGFloat)angle
{
    UIPushBehavior *push = [[UIPushBehavior alloc] initWithItems:items
                                                            mode:UIPushBehaviorModeInstantaneous];
    push.angle = angle;
    push.magnitude = 0.1;
    return push;
}

- (NSInteger)getRandomValue
{
    return arc4random() % 10;
}

- (void)collisionBehavior:(UICollisionBehavior*)behavior endedContactForItem:(id <UIDynamicItem>)item withBoundaryIdentifier:(id <NSCopying>)identifier
{
    [self performSelector:@selector(changeB:) withObject:behavior afterDelay:1];
    [self.leftAnimator addBehavior:[self pushWithItems:self.left andAngle:M_PI - M_PI_4]];
    [self.rightAnimator addBehavior:[self pushWithItems:self.right andAngle:M_PI_4]];
}

- (void)changeB:(UICollisionBehavior *)behavior
{
     behavior.translatesReferenceBoundsIntoBoundary = NO;
}

- (void)clearAllAnimation
{
    [self.leftAnimator removeAllBehaviors];
    self.leftAnimator = nil;
    [self.rightAnimator removeAllBehaviors];
    self.rightAnimator = nil;
    [self.middleAnimator removeAllBehaviors];
    self.middleAnimator = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
