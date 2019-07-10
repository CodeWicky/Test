//
//  DWAlertController.m
//  TestAlertManager
//
//  Created by Wicky on 2019/6/22.
//  Copyright © 2019 Wicky. All rights reserved.
//

#import "DDAlertController.h"

#import "CViewController.h"

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
    [self hideAnimationWithCompletion:^{
        [self.navigationController popViewControllerAnimated:YES];
        [self.currentVC.navigationController setNavigationBarHidden:self.sourceHiddenNavigation];
    }];
}

#pragma mark --- tool method ---
-(void)setupUI {
    if (!self.sourceHiddenNavigation) {
        UINavigationBar * bar = self.currentVC.navigationController.navigationBar;
        CGRect frame = bar.frame;
        ///额外加0.5，因为有分割线
        frame.size.height = CGRectGetMaxY(frame) + 0.5;
        frame.origin.y = 0;
        UIImage * navImage = [self snapWithView:self.currentVC.navigationController.view];
        navImage = [self cropImage:navImage inRect:frame];
        self.snapNavigationBar.image = navImage;
        self.snapNavigationBar.frame = frame;
        [self.view addSubview:self.snapNavigationBar];
    }
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

-(UIImage*)cropImage:(UIImage*)image inRect:(CGRect)rect {
    if (rect.origin.x > image.size.width || rect.origin.y > image.size.height) {
        return nil;
    } else if (rect.size.width < 0 || rect.size.height < 0) {
        return nil;
    }
    if (rect.origin.x < 0) {
        rect.origin.x = 0;
    }
    if (rect.origin.y < 0) {
        rect.origin.y = 0;
    }
    if (CGRectGetMaxX(rect) > image.size.width) {
        rect.size.width = image.size.width - rect.origin.x;
    }
    if (CGRectGetMaxY(rect) > image.size.height) {
        rect.size.height = image.size.height - rect.origin.y;
    }
    rect = CGRectApplyAffineTransform(rect, CGAffineTransformMakeScale(image.scale, image.scale));
    CGImageRef imagePartRef = CGImageCreateWithImageInRect(image.CGImage,rect);
    UIImage * cropImage = [UIImage imageWithCGImage:imagePartRef];
    CGImageRelease(imagePartRef);
    return cropImage;
}

-(void)showAnimationWithCompletion:(dispatch_block_t)completion {
    [UIView animateWithDuration:0.25 animations:^{
        self.bgContainer.alpha = 1;
    } completion:^(BOOL finished) {
        if (completion) {
            completion();
        }
    }];
}

-(void)hideAnimationWithCompletion:(dispatch_block_t)completion {
    [UIView animateWithDuration:0.25 animations:^{
        self.bgContainer.alpha = 0;
    } completion:^(BOOL finished) {
        if (completion) {
            completion();
        }
    }];
}

#pragma mark --- life cycle ---
- (void)viewDidLoad {
    [super viewDidLoad];
//    self.sourceHiddenNavigation = self.navigationController.navigationBarHidden;
    [self setupUI];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self.navigationController.navigationBar setBackgroundImage:[self createImageWithColor:[UIColor colorWithRed:0 green:1 blue:0 alpha:0.]] forBarMetrics:(UIBarMetricsDefault)];
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:(UIBarMetricsDefault)];
//    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
////    [self.navigationItem setHidesBackButton:YES animated:animated];
//    [self.navigationController setNavigationBarHidden:YES animated:NO];
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

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self showAnimationWithCompletion:nil];
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
//    [self.currentVC.navigationController setNavigationBarHidden:self.sourceHiddenNavigation animated:animated];
}

#pragma mark --- override ---
-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if (!CGRectEqualToRect(self.bgContainer.frame, self.view.bounds)) {
        self.bgContainer.frame = self.view.bounds;
    }
    
    if (self.contentView) {
        [self.view addSubview:self.contentView];
        if (!CGPointEqualToPoint(self.contentView.center, self.view.center)) {
            self.contentView.center = self.view.center;
        }
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.cancelableOnClickBackground && [self.navigationController.topViewController isEqual:self]) {
        CGPoint pointInContent = [[touches anyObject] locationInView:self.contentView];
        if (CGRectContainsPoint(self.contentView.bounds, pointInContent)) {
            CViewController * new = [CViewController new];
            [self.navigationController pushViewController:new animated:YES];
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
        _bgContainer.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    }
    return _bgContainer;
}

-(void)setContentView:(UIView *)contentView {
    _contentView = contentView;
    if (contentView) {
        [self.bgContainer addSubview:contentView];
    }
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

-(UIColor *)backgroundColor {
    return self.bgContainer.backgroundColor;
}

-(DWTransitionType)pushAnimationType {
    return DWTransitionTransparentPushType | DWTransitionAnimationNoneType;
}

-(DWTransitionType)popAnimationType {
    return DWTransitionTransparentPopType | DWTransitionAnimationNoneType;
}

@end
