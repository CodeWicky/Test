//
//  BaseViewController.h
//  TestAlertManager
//
//  Created by Wicky on 2019/6/21.
//  Copyright © 2019 Wicky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DWTransition.h"

NS_ASSUME_NONNULL_BEGIN

@interface BaseViewController : UIViewController<DWTransitionProtocol>

-(UIImage*)createImageWithColor:(UIColor*)color;

@end

NS_ASSUME_NONNULL_END
