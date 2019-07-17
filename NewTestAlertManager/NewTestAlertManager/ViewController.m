//
//  ViewController.m
//  NewTestAlertManager
//
//  Created by Wicky on 2019/7/12.
//  Copyright © 2019 Wicky. All rights reserved.
//

#import "ViewController.h"
#import "AViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor cyanColor];
    UIView * red = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    red.backgroundColor = [UIColor redColor];
    [self.view addSubview:red];
    red.center = self.view.center;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    AViewController * vc = [AViewController new];
    vc.dw_pushAnimationType = DWTransitionTransparentPushType;
    vc.dw_popAnimationType = DWTransitionTransparentPopType;
    [self.navigationController pushViewController:vc animated:YES];
}


@end
