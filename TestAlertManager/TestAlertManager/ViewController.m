//
//  ViewController.m
//  TestAlertManager
//
//  Created by Wicky on 2019/6/21.
//  Copyright © 2019 Wicky. All rights reserved.
//

#import "ViewController.h"
#import "AViewController.h"

#import "DWTransition.h"

#import <objc/runtime.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor purpleColor];
    UIView * red = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    red.backgroundColor = [UIColor redColor];
    [self.view addSubview:red];
    
    
    NSLog(@"%@",[self getAllProperties:[UITabBarController class]]);
    NSLog(@"%@",self.tabBarController.dw_tabTransitionView);

//    red.center = self.view.center;
}

- (NSArray *)getAllProperties:(Class)clazz



{
    
    u_int count;
    
    objc_property_t *properties  =class_copyPropertyList(clazz, &count);
    
    NSMutableArray *propertiesArray = [NSMutableArray arrayWithCapacity:count];
    
    for (int i = 0; i<count; i++)
        
    {
        
        const char* propertyName =property_getName(properties[i]);
        
        [propertiesArray addObject: [NSString stringWithUTF8String: propertyName]];
        
    }
    
    free(properties);
    
    return propertiesArray;
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
//    [self.navigationController.navigationBar setBackgroundImage: forBarMetrics:(UIBarMetricsDefault)];
}



-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    AViewController * new = [AViewController new];
    new.pushAnimationType = DWTransitionTransparentPushType;
    [self.navigationController pushViewController:new animated:YES];
}


@end
