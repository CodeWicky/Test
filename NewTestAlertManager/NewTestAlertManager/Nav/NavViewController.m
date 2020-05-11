//
//  NavViewController.m
//  NewTestAlertManager
//
//  Created by Wicky on 2019/7/12.
//  Copyright © 2019 Wicky. All rights reserved.
//

#import "NavViewController.h"
#import "DWTransition.h"
#import "DWTransitionPopInteraction.h"

@interface NavViewController ()<UINavigationControllerDelegate> 

@property (nonatomic ,strong) NSMutableArray * viewControllersBeforePop;

@property (nonatomic ,strong) DWTransitionPopInteraction * popInteraction;

@end

@implementation NavViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    self.modalPresentationStyle = UIModalPresentationCustom;
    self.popInteraction = [DWTransitionPopInteraction interactionWithNavigationController:self];
}

-(id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    if (operation == UINavigationControllerOperationPush) {
        if ([toVC conformsToProtocol:@protocol(DWTransitionProtocol)] && [toVC respondsToSelector:@selector(dw_pushAnimationType)]) {
            DWTransitionType animationType = ((id <DWTransitionProtocol>)toVC).dw_pushAnimationType & DWTransitionAnimationTypeMask;
            DWTransitionType transitionType = ((id <DWTransitionProtocol>)toVC).dw_pushAnimationType & DWTransitionTypeMask;
            if (transitionType == DWTransitionDefaultType) {
                transitionType = DWTransitionPushType;
            } else if (transitionType == DWTransitionTransparentPopType) {
                transitionType = DWTransitionTransparentPopType;
            } else if (transitionType == DWTransitionPopType) {
                transitionType = DWTransitionPushType;
            } else if (transitionType == DWTransitionDismissType) {
                transitionType = DWTransitionPresentType;
            }
            
            return [DWTransition transitionWithType:transitionType | animationType duration:0.25 customTransition:nil];
        } else {
            return nil;
        }
    } else if (operation == UINavigationControllerOperationPop) {
        
        ///这里需要注意，由于存在多个vc共同pop的情况，如果在pop的路径上有任意一个是transparent模式的话，都应该是transparent，而不是普通pop。这里当前的解决方案是，如果fromVC与toVC是相邻的VC则代表不是同时操作多个，直接以fromVC的动画形式隐藏掉。如果不是相邻的，则询问整个链路中，是否有比较靠前的animationFlag，如果有，则按照其动画形式隐藏掉，如果没有，则按照toVC的下一个vc的动画形式去掉。
        NSInteger toIndex = [self.viewControllersBeforePop indexOfObject:toVC];
        if (toIndex == NSNotFound || toIndex >= (self.viewControllersBeforePop.count - 1)) {
            return nil;
        }
        ///寻找最大查询点，若果找不到，则找至栈末尾
        NSInteger fromIndex = [self.viewControllersBeforePop indexOfObject:fromVC];
        if (fromIndex == NSNotFound || fromIndex > (self.viewControllersBeforePop.count - 1)) {
            fromIndex = self.viewControllersBeforePop.count - 1;
        }
        
        if (fromIndex == (toIndex + 1)) {
            self.viewControllersBeforePop = nil;
            if ([fromVC conformsToProtocol:@protocol(DWTransitionProtocol)] && [fromVC respondsToSelector:@selector(dw_popAnimationType)]) {
                return [self popTransitionForVC:(UIViewController <DWTransitionProtocol>*)fromVC];
            } else {
                return nil;
            }
        } else {
            ///从toVC开始的下一个开始遍历，直到fromVC，寻找animationFlag为yes的控制器
            NSInteger start = toIndex + 1;
            while (start <= fromIndex) {
                UIViewController * tmp = self.viewControllersBeforePop[start];
                if ([tmp conformsToProtocol:@protocol(DWTransitionProtocol)] && [tmp respondsToSelector:@selector(dw_popAnimationType)] && [tmp respondsToSelector:@selector(dw_animationFlag)]) {
                    ///找到了优先使用的动画模式
                    if (((id <DWTransitionProtocol>)tmp).dw_animationFlag == YES) {
                        self.viewControllersBeforePop = nil;
                        return [self popTransitionForVC:(UIViewController<DWTransitionProtocol> *)tmp];
                    }
                }
                ++start;
            }
            ///到这里没return出去，说明没有，则看toVC的下一个vc。
            UIViewController * nextVC = self.viewControllersBeforePop[toIndex + 1];
            self.viewControllersBeforePop = nil;
            if ([nextVC conformsToProtocol:@protocol(DWTransitionProtocol)] && [nextVC respondsToSelector:@selector(dw_popAnimationType)]) {
                return [self popTransitionForVC:(UIViewController <DWTransitionProtocol>*)nextVC];
            } else {
                return nil;
            }
        }
    }
    return nil;
}

-(id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController {
    ///配合DWTransition使用
    if ([animationController isKindOfClass:[DWTransition class]]) {
        ///当本次返回是由侧滑返回触发时才进行定制
        if (self.popInteraction.popInteractionGestureRecognizer.state == UIGestureRecognizerStateBegan) {
            DWTransition * trans = (DWTransition *)animationController;
            DWTransitionType type = trans.transitionType & DWTransitionTypeMask;
            ///当当前动画过程是消失是才触发
            if (type == DWTransitionPopType || type == DWTransitionTransparentPopType || type == DWTransitionDismissType) {
                return self.popInteraction;
            }
            return nil;
        }
        return nil;
    }
    return nil;
}

-(DWTransition *)popTransitionForVC:(UIViewController <DWTransitionProtocol>*)vc {
    ///如果未设置PopType，则取PushType作为默认值
    DWTransitionType animationType = vc.dw_popAnimationType & DWTransitionAnimationTypeMask;
    if (animationType == DWTransitionDefaultType) {
        animationType = vc.dw_pushAnimationType & DWTransitionAnimationTypeMask;
    }
    DWTransitionType transitionType = vc.dw_popAnimationType & DWTransitionTypeMask;
    if (transitionType == DWTransitionDefaultType) {
        transitionType = vc.dw_pushAnimationType & DWTransitionTypeMask;
    }
    if (transitionType == DWTransitionDefaultType) {
        transitionType = DWTransitionPopType;
    } else if (transitionType == DWTransitionTransparentPushType) {
        transitionType = DWTransitionTransparentPopType;
    } else if (transitionType == DWTransitionPushType) {
        transitionType = DWTransitionPopType;
    } else if (transitionType == DWTransitionPresentType) {
        transitionType = DWTransitionDismissType;
    }
    return [DWTransition transitionWithType:transitionType | animationType duration:0.25 customTransition:nil];
}

///重写pop方法，记录临时数组，给pop动画使用
-(UIViewController *)popViewControllerAnimated:(BOOL)animated {
    self.viewControllersBeforePop = [self.viewControllers mutableCopy];
    return [super popViewControllerAnimated:animated];
}

-(NSArray<UIViewController *> *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    self.viewControllersBeforePop = [self.viewControllers mutableCopy];
    return [super popToViewController:viewController animated:animated];
}

-(NSArray<UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated {
    self.viewControllersBeforePop = [self.viewControllers mutableCopy];
    return [super popToRootViewControllerAnimated:animated];
}

-(void)setPopInteractionEnabled:(BOOL)popInteractionEnabled {
    self.popInteraction.popInteractionGestureRecognizer.enabled = popInteractionEnabled;
}

-(BOOL)popInteractionEnabled {
    return self.popInteraction.popInteractionGestureRecognizer.enabled;
}

@end
