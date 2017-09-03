//
//  DrawerController.h
//  Drawer
//
//  Created by 李立 on 2017/8/24.
//  Copyright © 2017年 李立. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DrawerController;

/**
 在子控制器中，如果需要打开或关闭，需要获取到DrawerController的实例
 */
@protocol DrawerControllerChild <NSObject>
/** 抽屉代理 */
@property (weak , nonatomic) DrawerController *drawer;

@end

/**
 抽屉在滑动的时候的代理方法
 */
@protocol DrawerControllerPresenting <NSObject>

@optional

/**
 抽屉将要打开

 @param drawerController 抽屉控制器
 */
- (void)drawerControllerWillOpen:(DrawerController *)drawerController;

/**
 抽屉已经打开
 
 @param drawerController 抽屉控制器
 */
- (void)drawerControllerDidOpen:(DrawerController *)drawerController;

/**
 抽屉将要关闭
 
 @param drawerController 抽屉控制器
 */
- (void)drawerControllerWillClose:(DrawerController *)drawerController;
/**
 抽已经关闭
 
 @param drawerController 抽屉控制器
 */
- (void)drawerControllerDidClose:(DrawerController *)drawerController;

@end


/**
 抽屉滑动状态的枚举

 - DrawerControllerStateClosed: 抽屉关闭
 - DrawerControllerStateOpening: 抽屉打开中
 - DrawerControllerStateOpen: 抽屉打开
 - DrawerControllerStateClosing: 抽屉关闭中
 */
typedef NS_ENUM(NSUInteger, DrawerControllerState)
{
    DrawerControllerStateClosed = 0,
    DrawerControllerStateOpening,
    DrawerControllerStateOpen,
    DrawerControllerStateClosing
};

@interface DrawerController : UIViewController
/** 左边的抽屉 */
@property (strong , nonatomic) UIViewController <DrawerControllerChild, DrawerControllerPresenting>*leftViewController;
/** 抽屉划出的距离，默认偏移屏幕宽度的3/4 */
@property (assign , nonatomic) CGFloat offset;
/** 抽屉的状态 */
@property (assign , nonatomic , readonly) DrawerControllerState state;

/**
 初始化方法

 @param rootViewController 展示在屏幕中间主要的控制器
 @return 返回当前抽屉控制器的实例
 */
- (instancetype)initWithRootViewController:(UIViewController <DrawerControllerChild, DrawerControllerPresenting>*)rootViewController;

/**
 打开抽屉
 */
- (void)open;

/**
 关闭抽屉
 */
- (void)close;

@end



