//
//  BaseViewController.h
//  NewTestAlertManager
//
//  Created by Wicky on 2019/7/12.
//  Copyright © 2019 Wicky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DWTransition/DWTransition.h"
#import <UIViewController+DWNavigationTransition.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseViewController : UIViewController<DWTransitionProtocol>

-(UIImage*)createImageWithColor:(UIColor*)color;

@end

NS_ASSUME_NONNULL_END
