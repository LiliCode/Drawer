//
//  LeftViewController.m
//  Drawer
//
//  Created by 李立 on 2017/8/24.
//  Copyright © 2017年 李立. All rights reserved.
//

#import "LeftViewController.h"

@interface LeftViewController ()

@end

@implementation LeftViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor redColor];
}


#pragma mark - DrawerControllerPresenting

- (void)drawerControllerWillOpen:(DrawerController *)drawerController
{
    NSLog(@"抽屉将要打开");
}

- (void)drawerControllerDidOpen:(DrawerController *)drawerController
{
    NSLog(@"抽屉已经打开");
}

- (void)drawerControllerWillClose:(DrawerController *)drawerController
{
    NSLog(@"抽屉将要关闭");
}

- (void)drawerControllerDidClose:(DrawerController *)drawerController
{
    NSLog(@"抽屉已经关闭");
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}



@end
