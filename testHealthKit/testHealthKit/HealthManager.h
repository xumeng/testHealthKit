//
//  HealthManager.h
//  testHealthKit
//
//  Created by Amon on 2017/3/17.
//  Copyright © 2017年 GodPlace. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <HealthKit/HealthKit.h>

@interface HealthManager : NSObject

@property (nonatomic, strong) HKHealthStore *healthStore;

+ (id)shareInstance;

- (void)authorizeHealthKit:(void(^)(BOOL success, NSError *error))complation;

- (void)getStepCount:(void(^)(double value, NSError *error))completion;

@end
