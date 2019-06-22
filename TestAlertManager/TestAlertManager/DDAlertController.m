//
//  DWAlertController.m
//  TestAlertManager
//
//  Created by Wicky on 2019/6/22.
//  Copyright © 2019 Wicky. All rights reserved.
//

#import "DDAlertController.h"

@interface DDAlertController ()

@property (nonatomic ,strong) UIView * bgContainer;

@property (nonatomic ,strong) UIImageView * snapNavigationBar;

@property (nonatomic ,assign) BOOL sourceHiddenNavigation;

@property (nonatomic ,strong) UIViewController * currentVC;

@end

@implementation DDAlertController
@synthesize pushAnimationType = _pushAnimationType;
@synthesize popAnimationType = _popAnimationType;
@synthesize animationFlag = _animationFlag;

#pragma mark --- interface method ---
-(void)show {
    [self showInViewController:self.currentVC];
}

-(void)showInViewController:(UIViewController *)vc {
    if (vc.navigationController) {
        self.currentVC = vc;
        [vc.navigationController pushViewController:self animated:YES];
    }
}

-(void)configWithCurrentViewController:(UIViewController *)currentVC {
    if (currentVC.navigationController) {
        self.currentVC = currentVC;
    } else if ([currentVC isKindOfClass:[UINavigationController class]]) {
        self.currentVC = ((UINavigationController *)currentVC).topViewController;
    }
}

-(void)dismiss {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark --- tool method ---
-(void)setupUI {
    [self.view addSubview:self.bgContainer];
}

-(UIImage *)snapWithView:(UIView *)view {
    CGFloat scale = [UIScreen mainScreen].scale;
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    [view.layer renderInContext:context];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark --- life cycle ---
- (void)viewDidLoad {
    [super viewDidLoad];
    self.sourceHiddenNavigation = self.navigationController.navigationBarHidden;
    [self setupUI];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.currentVC.navigationController setNavigationBarHidden:self.sourceHiddenNavigation];
}

#pragma mark --- override ---
-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if (!CGRectEqualToRect(self.bgContainer.frame, self.view.bounds)) {
        self.bgContainer.frame = self.view.bounds;
    }
}

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

-(void)dealloc {
    NSLog(@"dealloc");
}

#pragma mark --- setter/getter ---
-(UIView *)bgContainer {
    if (!_bgContainer) {
        _bgContainer = [[UIView alloc] init];
    }
    return _bgContainer;
}

-(UIImageView *)snapNavigationBar {
    if (!_snapNavigationBar) {
        _snapNavigationBar = [[UIImageView alloc] init];
    }
    return _snapNavigationBar;
}

-(void)setBackgroundColor:(UIColor *)backgroundColor {
    self.bgContainer.backgroundColor = backgroundColor;
}

-(DWTransitionType)pushAnimationType {
    return DWTransitionTransparentPushType | DWTransitionAnimationFadeInType;
}

-(DWTransitionType)popAnimationType {
    return DWTransitionTransparentPopType | DWTransitionAnimationFadeInType;
}

@end
