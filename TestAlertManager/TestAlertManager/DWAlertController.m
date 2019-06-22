//
//  DWAlertController.m
//  TestAlertManager
//
//  Created by Wicky on 2019/6/22.
//  Copyright © 2019 Wicky. All rights reserved.
//

#import "DWAlertController.h"

@interface DWAlertController ()

@property (nonatomic ,assign) BOOL sourceHiddenNavigation;

@property (nonatomic ,strong) UIViewController * currentVC;

@end

@implementation DWAlertController
@synthesize pushAnimationType = _pushAnimationType;
@synthesize popAnimationType = _popAnimationType;
@synthesize animationFlag = _animationFlag;

#pragma mark --- interface method ---
-(void)show {
    if (self.currentVC.navigationController) {
        [self showInViewController:self.currentVC];
    } else if ([self.currentVC isKindOfClass:[UINavigationController class]]) {
        [self showInViewController:((UINavigationController *)self.currentVC).topViewController];
    }
}

-(void)showInViewController:(UIViewController *)vc {
    if (vc.navigationController) {
        [vc.navigationController pushViewController:self animated:YES];
    }
}

-(void)configWithCurrentViewController:(UIViewController *)currentVC {
    self.currentVC = currentVC;
}

-(void)dismiss {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark --- life cycle ---
- (void)viewDidLoad {
    [super viewDidLoad];
    self.sourceHiddenNavigation = self.navigationController.navigationBarHidden;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.navigationController setNavigationBarHidden:self.sourceHiddenNavigation];
}

#pragma mark --- override ---
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.cancelableOnClickBackground && [self.navigationController.topViewController isEqual:self]) {
        CGPoint pointInContent = [[touches anyObject] locationInView:self.contentView];
        if (CGRectContainsPoint(self.contentView.frame, pointInContent)) {
            return;
        }
        [self dismiss];
    }
}

-(instancetype)init {
    if (self = [super init]) {
        _cancelableOnClickBackground = YES;
    }
    return self;
}

#pragma mark --- setter/getter ---
-(void)setBackgroundColor:(UIColor *)backgroundColor {
    self.view.backgroundColor = backgroundColor;
}

-(DWTransitionType)pushAnimationType {
    return DWTransitionTransparentPushType | DWTransitionAnimationFadeInType;
}

-(DWTransitionType)popAnimationType {
    return DWTransitionTransparentPopType | DWTransitionAnimationFadeInType;
}

@end
