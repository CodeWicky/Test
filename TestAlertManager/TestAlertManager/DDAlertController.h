//
//  DWAlertController.h
//  TestAlertManager
//
//  Created by Wicky on 2019/6/22.
//  Copyright © 2019 Wicky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DWTransition.h"

NS_ASSUME_NONNULL_BEGIN

@interface DDAlertController : UIViewController<DWTransitionProtocol>

@property (nonatomic ,strong) UIColor * backgroundColor;

@property (nonatomic ,assign) BOOL cancelableOnClickBackground;

@property (nonatomic ,strong) UIView * contentView;

-(void)show;

-(void)showInViewController:(UIViewController *)vc;

-(void)configWithCurrentViewController:(UIViewController *)currentVC;

-(void)dismiss;

@end

NS_ASSUME_NONNULL_END
