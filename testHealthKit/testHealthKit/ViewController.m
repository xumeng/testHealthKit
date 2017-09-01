//
//  ViewController.m
//  testHealthKit
//
//  Created by Amon on 2017/3/17.
//  Copyright © 2017年 GodPlace. All rights reserved.
//

#import "ViewController.h"
#import "HealthManager.h"

@interface ViewController ()

@end

@implementation ViewController
{
    UILabel *stepLabel;
    UILabel *distanceLabel;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self initUI];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initUI
{
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(50, 100, 100, 40);
    [btn1 setTitle:@"计步" forState:UIControlStateNormal];
    btn1.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:btn1];
    [btn1 addTarget:self action:@selector(onClickBtn1) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame = CGRectMake(50, 160, 100, 40);
    [btn2 setTitle:@"距离" forState:UIControlStateNormal];
    btn2.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:btn2];
    [btn2 addTarget:self action:@selector(onClickBtn2) forControlEvents:UIControlEventTouchUpInside];
    
    stepLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 220, 200, 40)];
    stepLabel.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:stepLabel];
    
    distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 280, 200, 40)];
    distanceLabel.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:distanceLabel];
}

- (void)onClickBtn1
{
    HealthManager *manage = [HealthManager shareInstance];
    [manage authorizeHealthKit:^(BOOL success, NSError *error) {
        
        if (success) {
            NSLog(@"success");
            [manage getStepCount:^(double value, NSError *error) {
                NSLog(@"1count-->%.0f", value);
                NSLog(@"1error-->%@", error.localizedDescription);
                dispatch_async(dispatch_get_main_queue(), ^{
                    stepLabel.text = [NSString stringWithFormat:@"步数：%.0f步", value];
                });
                
            }];
        }
        else {
            NSLog(@"fail");
        }
    }];
}

- (void)onClickBtn2
{
//    HealthManager *manage = [HealthManager shareInstance];
//    [manage authorizeHealthKit:^(BOOL success, NSError *error) {
//        
//        if (success) {
//            NSLog(@"success");
//            [manage getDistance:^(double value, NSError *error) {
//                NSLog(@"2count-->%.2f", value);
//                NSLog(@"2error-->%@", error.localizedDescription);
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    distanceLabel.text = [NSString stringWithFormat:@"公里数：%.2f公里", value];
//                });
//                
//            }];
//        }
//        else {
//            NSLog(@"fail");
//        }
//    }];
}

@end
