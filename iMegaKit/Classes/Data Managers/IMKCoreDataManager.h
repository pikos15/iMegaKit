//
//  IMKCoreDataManager.h
//  iMegaKit
//
//  Created by Konstantin Pikhterev on 23.07.17.
//  Copyright © 2017 MegaKit. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <CoreData/CoreData.h>

typedef void (^IMKCoreDataManagerCompletion)(BOOL success, id _Nullable result, NSError * _Nullable error);

@class Car;

@interface IMKCoreDataManager : NSObject

#pragma mark - Singleton -

+(IMKCoreDataManager *_Nullable) sharedManager;

#pragma mark - Core Data stack -

@property (readonly, strong) NSPersistentContainer * _Nullable persistentContainer;

- (void)saveContext;

#pragma mark - Add data to CoreData -

- (void)addCarWithParams:(NSDictionary *_Nullable)params
              completion:(nullable IMKCoreDataManagerCompletion)completion;

- (void)addDriverWithParams:(NSDictionary *_Nullable)params
              completion:(nullable IMKCoreDataManagerCompletion)completion;

#pragma mark - Edit data in CoreData -

- (void)editCar:(Car *_Nullable)theCar withParams:(NSDictionary *_Nullable)params
     completion:(nullable IMKCoreDataManagerCompletion)completion;

#pragma mark - Delete data in CoreData -

- (void)deleteCar:(Car *_Nullable)theCar completion:(nullable IMKCoreDataManagerCompletion)completion;

#pragma mark - Get data from CoreData -

- (void)fetchRequestWithEntityName:(NSString *_Nullable)name
                            params:(NSDictionary *_Nullable)params
                        completion:(nullable IMKCoreDataManagerCompletion)completion;

@end
