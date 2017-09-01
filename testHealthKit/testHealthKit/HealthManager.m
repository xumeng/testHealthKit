//
//  HealthManager.m
//  testHealthKit
//
//  Created by Amon on 2017/3/17.
//  Copyright © 2017年 GodPlace. All rights reserved.
//

#import "HealthManager.h"

@implementation HealthManager

- (void)authorizeHealthKit:(void(^)(BOOL success, NSError *error))complation
{
    if (![HKHealthStore isHealthDataAvailable]) {
        NSError *error = [NSError errorWithDomain:@"com.amonxu"
                                             code:2
                                         userInfo:nil];
        if (complation) {
            complation(false, error);
        }
        return;
    }
    
    if (!self.healthStore) {
        self.healthStore = [[HKHealthStore alloc] init];
    }
    
        NSSet *writeDataTypes = [self dataTypesToWrite];
        NSSet *readDataTypes = [self dataTypesRead];
        
        [self.healthStore requestAuthorizationToShareTypes:writeDataTypes readTypes:readDataTypes completion:^(BOOL success, NSError * _Nullable error) {
            if (complation) {
                NSLog(@"error>>>%@", error.localizedDescription);
                complation(success, error);
            }
        }];
    
}

/*!
 *  @brief  写权限
 *  @return 集合
 */
- (NSSet *)dataTypesToWrite
{
//    HKQuantityType *heightType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeight];
//    HKQuantityType *weightType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass];
//    HKQuantityType *temperatureType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyTemperature];
//    HKQuantityType *activeEnergyType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierActiveEnergyBurned];
    
    return [NSSet new];
}

/*!
 *  @brief  读权限
 *  @return 集合
 */
- (NSSet *)dataTypesRead
{
//    HKQuantityType *heightType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeight];
//    HKQuantityType *weightType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass];
//    HKQuantityType *temperatureType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyTemperature];
//    HKCharacteristicType *birthdayType = [HKObjectType characteristicTypeForIdentifier:HKCharacteristicTypeIdentifierDateOfBirth];
//    HKCharacteristicType *sexType = [HKObjectType characteristicTypeForIdentifier:HKCharacteristicTypeIdentifierBiologicalSex];
    HKQuantityType *stepCountType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    HKQuantityType *distance = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceWalkingRunning];
//    HKQuantityType *activeEnergyType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierActiveEnergyBurned];
    
    return [NSSet setWithObjects:stepCountType, distance,nil];
}

//获取步数
- (void)getStepCount:(void(^)(double value, NSError *error))completion
{
    HKQuantityType *stepType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    NSSortDescriptor *timeSortDescriptor = [[NSSortDescriptor alloc] initWithKey:HKSampleSortIdentifierEndDate ascending:NO];
    
    // Since we are interested in retrieving the user's latest sample, we sort the samples in descending order, and set the limit to 1. We are not filtering the data, and so the predicate is set to nil.
    HKSampleQuery *query = [[HKSampleQuery alloc] initWithSampleType:stepType predicate:[HealthManager predicateForSamplesToday] limit:HKObjectQueryNoLimit sortDescriptors:@[timeSortDescriptor] resultsHandler:^(HKSampleQuery *query, NSArray *results, NSError *error) {
        if(error)
        {
            completion(0,error);
        }
        else
        {
            NSInteger totleSteps = 0;
            for(HKQuantitySample *quantitySample in results)
            {
                HKQuantity *quantity = quantitySample.quantity;
                HKUnit *heightUnit = [HKUnit countUnit];
                double usersHeight = [quantity doubleValueForUnit:heightUnit];
                NSLog(@"????%f", usersHeight);
                totleSteps += usersHeight;
            }
            NSLog(@"当天行走步数 = %ld",(long)totleSteps);
            completion(totleSteps,error);
        }
    }];
    
    [self.healthStore executeQuery:query];
}

/*!
 *  @brief  当天时间段
 *
 *  @return 时间段
 */
+ (NSPredicate *)predicateForSamplesToday {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *now = [NSDate date];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:now];
    [components setHour:0];
    [components setMinute:0];
    [components setSecond: 0];
    
    NSDate *startDate = [calendar dateFromComponents:components];
    NSDate *endDate = [calendar dateByAddingUnit:NSCalendarUnitDay value:1 toDate:startDate options:0];
    NSPredicate *predicate = [HKQuery predicateForSamplesWithStartDate:startDate endDate:endDate options:HKQueryOptionNone];
    return predicate;
}



+ (id)shareInstance
{
    static id manager ;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[[self class] alloc] init];
    });
    return manager;
}

@end
