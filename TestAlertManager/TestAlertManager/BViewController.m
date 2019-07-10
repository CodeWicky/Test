//
//  BViewController.m
//  TestAlertManager
//
//  Created by Wicky on 2019/6/21.
//  Copyright © 2019 Wicky. All rights reserved.
//

#import "BViewController.h"
#import "CViewController.h"
#import "DDAlertController.h"

@interface BViewController ()

@end

@implementation BViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    UIView * yellow = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    yellow.backgroundColor = [UIColor yellowColor];
    yellow.center = CGPointMake(self.view.center.x, self.view.center.y + 100);
    [self.view addSubview:yellow];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    UIViewController * fromVC = [self.transitionCoordinator viewControllerForKey:(UITransitionContextFromViewControllerKey)];
    if ([fromVC isKindOfClass:NSClassFromString(@"DDAlertController")]) {
        animated = NO;
    }
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [self.navigationController.navigationBar setBackgroundImage:[self createImageWithColor:[UIColor colorWithWhite:1 alpha:0.7]] forBarMetrics:(UIBarMetricsDefault)];
}

-(UIImage*)createImageWithColor:(UIColor*)color
{
    CGRect rect=CGRectMake(0.0f,0.0f,1.0f,1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context=UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,[color CGColor]);
    CGContextFillRect(context,rect);
    UIImage *theImage=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    DDAlertController * alert = [DDAlertController new];
    alert.backgroundColor = [UIColor colorWithWhite:1 alpha:0.3];
    UIView * content = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
    content.backgroundColor = [UIColor whiteColor];
    alert.contentView = content;
    [alert showInViewController:self];
    return;
    CViewController * new =[CViewController new];
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
