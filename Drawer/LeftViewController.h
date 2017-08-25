//
//  LeftViewController.h
//  Drawer
//
//  Created by 李立 on 2017/8/24.
//  Copyright © 2017年 李立. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DrawerController.h"

@interface LeftViewController : UIViewController<DrawerControllerChild, DrawerControllerPresenting>
@property (weak , nonatomic) DrawerController *drawer;


@end
