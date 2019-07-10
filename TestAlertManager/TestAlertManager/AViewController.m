//
//  AViewController.m
//  TestAlertManager
//
//  Created by Wicky on 2019/6/21.
//  Copyright © 2019 Wicky. All rights reserved.
//

#import "AViewController.h"
#import "BViewController.h"

@interface AViewController ()

@end

@implementation AViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    self.view.backgroundColor = [UIColor redColor];
    UIView * green = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    green.backgroundColor = [UIColor greenColor];
    green.center = CGPointMake(self.view.center.x, self.view.center.y - 100);
    [self.view addSubview:green];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    BViewController * new = [BViewController new];
    new.pushAnimationType = DWTransitionTransparentPushType;
    [self.navigationController pushViewController:new animated:YES];
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
