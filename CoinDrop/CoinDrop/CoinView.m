//
//  CoinView.m
//  CoinDrop
//
//  Created by Programmer Four on 15/7/21.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "CoinView.h"
#import "UIViewExt.h"
#define CoinNum 20
#define MaskAlpha 0.4

@interface CoinView ()<UICollisionBehaviorDelegate>

@property (nonatomic) BOOL finishFlag;

@property (nonatomic, strong) UIView *maskBg;
@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) NSArray *left;
@property (nonatomic, strong) UIDynamicAnimator *leftAnimator;

@property (nonatomic, strong) NSArray *middle;
@property (nonatomic, strong) UIDynamicAnimator *middleAnimator;

@property (nonatomic, strong) NSArray *right;
@property (nonatomic, strong) UIDynamicAnimator *rightAnimator;

@property (nonatomic, strong) NSArray *randomArray;
@property (nonatomic, strong) UIDynamicAnimator *randomAnimator;
@property (nonatomic, strong) UILabel *addSincerityLabel;
@end

@implementation CoinView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.finishFlag = NO;
        [self configureMaskView];
        [self configureCoins];
        [self configureAddSincerityLabel];
    }
    return self;
}

- (void)configureMaskView
{
    self.maskBg = [[UIView alloc] initWithFrame:self.bounds];
    self.maskBg.backgroundColor = [UIColor blackColor];
    self.maskBg.alpha = 0;
    [self addSubview:self.maskBg];
    
    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(-100, -200, self.width + 200, self.height + 200)];
    self.contentView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.contentView];
}

- (void)configureCoins
{
    NSMutableArray *left = [[NSMutableArray alloc] init];
    NSMutableArray *middle = [[NSMutableArray alloc] init];
    NSMutableArray *right = [[NSMutableArray alloc] init];
    NSMutableArray *randoms = [[NSMutableArray alloc] init];
    
    CGRect centerRect = CGRectMake(self.maskBg.center.x - 70, -MAXFLOAT, 150, MAXFLOAT);
    for (int i = 0; i < 20; i++) {
        UIImageView *coin = [[UIImageView alloc] initWithFrame:CGRectMake(120 + [self getRandomValue] * 40, [self getRandomValue] * 20, 20, 20)];
        coin.image = [UIImage imageNamed:@"sincerityCoin"];
        [self.contentView addSubview:coin];
        
        if ([self getRandomValue] % 3 == 0 && randoms.count < 6) {
            //跳出8个以下的随机imageView来做点不同的动画
            [randoms addObject:coin];
        }
        else {
            CGPoint coinCenter = [self.contentView convertPoint:coin.center toView:self];
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

- (void)configureAddSincerityLabel
{
    self.addSincerityLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    self.addSincerityLabel.textColor = [UIColor yellowColor];
    self.addSincerityLabel.backgroundColor = [UIColor clearColor];
    self.addSincerityLabel.text = @"+1000";
    self.addSincerityLabel.layer.opacity = 0;
    self.addSincerityLabel.center = CGPointMake(self.center.x + 50, self.height - 200);
    [self addSubview:self.addSincerityLabel];
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
    UIDynamicAnimator *animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.contentView];
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
    
    if (!self.finishFlag) {
        self.finishFlag = YES;
        // 播放音效
        if ([self.delegate respondsToSelector:@selector(timeToPlayVoice)]) {
            [self.delegate timeToPlayVoice];
        }
        // 显示增加的值
        [self showLabel];
        // 处理掉界面
        [self performSelector:@selector(destoryCoinView) withObject:nil afterDelay:1.5];
    }
    
    [self performSelector:@selector(changeB:) withObject:behavior afterDelay:1];
        // 给银币增加推力
    [self addPushBehavior];
    
}

- (void)addPushBehavior
{
    [self.leftAnimator addBehavior:[self pushWithItems:self.left andAngle:M_PI - M_PI_4]];
    [self.rightAnimator addBehavior:[self pushWithItems:self.right andAngle:M_PI_4]];
}

- (void)showLabel
{
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, self.addSincerityLabel.center.x
                      , self.addSincerityLabel.center.y);
    CGPathAddArcToPoint(path, NULL, self.addSincerityLabel.center.x, self.addSincerityLabel.center.x, 200, 100, 500);
    
    CAKeyframeAnimation *position = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    position.path = path;
    CGPathRelease(path);
    
    CABasicAnimation *opacity = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacity.fromValue = @0;
    opacity.toValue = @1;
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.duration = 1;
    group.animations = @[opacity, position];
    
    [self.addSincerityLabel.layer addAnimation:group forKey:@"composite"];
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

- (void)showCoinView
{
    [UIView animateWithDuration:0.25 animations:^{
        self.maskBg.alpha = MaskAlpha;
    } completion:^(BOOL finished) {
        [self configureLeftAnimator];
        [self configureMiddleAnimator];
        [self configureRightAnimator];
        [self configureRandomAnimator];
    }];
}

- (void)destoryCoinView
{
    [self clearAllAnimation];
    [UIView animateWithDuration:0.25 animations:^{
        self.maskBg.alpha = 0;
    } completion:^(BOOL finished) {
        if ([self.delegate respondsToSelector:@selector(coinViewAnimationDidStop:)]) {
            [self.delegate coinViewAnimationDidStop:self];
        }
    }];
}

@end
