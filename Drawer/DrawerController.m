//
//  DrawerController.m
//  Drawer
//
//  Created by 李立 on 2017/8/24.
//  Copyright © 2017年 李立. All rights reserved.
//

#import "DrawerController.h"


static const NSTimeInterval kDrawerControllerAnimationDuration = 0.5;
static const CGFloat kDrawerControllerOpeningAnimationSpringDamping = 0.7f;
static const CGFloat kDrawerControllerOpeningAnimationSpringInitialVelocity = 0.1f;
static const CGFloat kDrawerControllerClosingAnimationSpringDamping = 1.0f;
static const CGFloat kDrawerControllerClosingAnimationSpringInitialVelocity = 0.5f;
static const CGFloat kDrawerControllerDimmingColorAlpha = 0.5f;


@interface DrawerController ()
/** 遮罩视图 */
@property (strong , nonatomic) UIView *dimmingView;
/** 抽屉的状态 */
@property (assign , nonatomic) DrawerControllerState drawerState;

@end

@implementation DrawerController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 设置点击手势，点击抽屉关闭
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(close)];
    [self.dimmingView addGestureRecognizer:tap];
}

- (UIView *)dimmingView
{
    if (!_dimmingView)
    {
        // 配置遮罩
        _dimmingView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _dimmingView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0];// 初始化成透明
    }
    
    return _dimmingView;
}

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController
{
    if (self = [super init])
    {
        // 添加子控制器
        [self addChildViewController:rootViewController];
        // 添加rootViewController的view到当前控制器
        [self.view addSubview:rootViewController.view];
        // 设置frame
        rootViewController.view.frame = self.view.bounds;
        // 子控制器移动到父控制器完成
        [rootViewController didMoveToParentViewController:self];
        
        // 设置偏移
        self.offset = [UIScreen mainScreen].bounds.size.width * (3.0f/4.0f);
        // 状态-默认关闭
        self.drawerState = DrawerControllerStateClosed;
    }
    
    return self;
}

/**
 添加左边的视图到dimmingView
 */
- (void)addLeftViewToDimming
{
    // 设置frame
    CGRect rect = self.dimmingView.bounds;
    rect.size.width = -self.offset; // 最开始完全在屏幕最左边的
    self.leftViewController.view.frame = rect;
    // 添加leftViewController的view到当前控制器
    [self.dimmingView addSubview:self.leftViewController.view];
    // 子视图移动到控制器完成
    [self.leftViewController didMoveToParentViewController:self];
}

/**
 从dimmingView 上面删除抽屉视图
 */
- (void)removeLeftViewFromDimming
{
    // 移除
    [self.leftViewController.view removeFromSuperview];
}

/**
 拖动抽屉

 @param location 拖动的位置
 */
- (void)moveLeftView:(CGPoint)location velocity:(CGPoint)velocity
{
    CGPoint center = self.leftViewController.view.center;
    center.x += velocity.x;
    self.leftViewController.view.center = center;
}

- (void)setLeftViewController:(UIViewController <DrawerControllerChild, DrawerControllerPresenting>*)leftViewController
{
    _leftViewController = leftViewController;
    
    // 添加到当前控制器中
    [self addChildViewController:leftViewController];
    
    // 添加边沿滑动
    UIScreenEdgePanGestureRecognizer *screenEdge = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(leftSecrrenEdge:)];
    screenEdge.edges = UIRectEdgeLeft;
    // 想当前视图添加左边延滑动的手势
    [self.view addGestureRecognizer:screenEdge];
}

- (void)leftSecrrenEdge:(UIScreenEdgePanGestureRecognizer *)sender
{
    CGPoint location = [sender locationInView:self.view];
    CGPoint velocity = [sender velocityInView:self.view];
    
    switch (sender.state)
    {
        case UIGestureRecognizerStateBegan:
            NSLog(@"开始滑动");
            [self prepareDrawerController:sender.edges];
            break;
        case UIGestureRecognizerStateChanged:
        {
            NSLog(@"正在滑动");
            if (location.x <= self.offset)
            {
                // 滑动中
                // 可滑动范围
                self.dimmingView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:location.x / self.offset * kDrawerControllerDimmingColorAlpha];
                // 移动
                [self moveLeftView:location velocity:velocity];
            }
            else
            {
                NSLog(@"location.x = 不可滑动");
                self.drawerState = DrawerControllerStateOpen;
            }
        }  break;
        case UIGestureRecognizerStateEnded:
            NSLog(@"停止滑动");
            break;
        case UIGestureRecognizerStateCancelled:
            NSLog(@"取消滑动");
            break;
            
        default: break;
    }
}

/**
 准备抽屉控制器

 @param edge 滑动方向
 */
- (void)prepareDrawerController:(UIRectEdge)edge
{
    // 抽屉将要出现
    UIViewController <DrawerControllerPresenting, DrawerControllerChild>*rootVC = self.childViewControllers.firstObject;
    if ([rootVC respondsToSelector:@selector(drawerControllerWillOpen:)])
    {
        [rootVC drawerControllerWillOpen:self];
    }
    
    if ([self.leftViewController respondsToSelector:@selector(drawerControllerWillOpen:)])
    {
        [self.leftViewController drawerControllerWillOpen:self];
    }
    
    [self.view addSubview:self.dimmingView];
    [self.view bringSubviewToFront:self.dimmingView];   // 显示在视图的最上层
    
    // 显示抽屉
    [self addLeftViewToDimming];
    // 设置状态
    self.drawerState = DrawerControllerStateOpening;
}

- (void)open
{
    NSLog(@"抽屉打开");
}

- (void)close
{
    NSLog(@"抽屉关闭");
    [self.dimmingView removeFromSuperview];
}


- (DrawerControllerState)state
{
    return self.drawerState;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}


@end
