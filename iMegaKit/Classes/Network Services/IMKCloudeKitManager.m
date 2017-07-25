//
//  IMKCloudeKitManager.m
//  iMegaKit
//
//  Created by Konstantin Pikhterev on 23.07.17.
//  Copyright © 2017 MegaKit. All rights reserved.
//

#import "IMKCloudeKitManager.h"

@import CloudKit;

@implementation IMKCloudeKitManager

#pragma mark - CloudKit -
//PK 296 - Добавление Car & Driver в CloudKit
+ (void)saveRecordToCloudWithCar:(Car *)car
                        imageCar:(NSURL *)imageURL
                       andDriver:(Driver *)driver
                      completion:(nullable IMKCloudeKitManagerCompletion)completion {
    
    CKContainer *defaultContainer = [CKContainer defaultContainer];
    CKDatabase *publicDatabase = [defaultContainer publicCloudDatabase];
    
    CKRecordID *driverRecordID = [[CKRecordID alloc] initWithRecordName:driver.recordUUID];
    [publicDatabase fetchRecordWithID:driverRecordID completionHandler:^(CKRecord *postRecrodDriver, NSError *error) {
        if(error) {
            NSLog(@"%@", error);
            
            CKRecord *postRecrodDriver = [[CKRecord alloc] initWithRecordType:@"Driver" recordID:driverRecordID];
            [postRecrodDriver setValue:driver.firstName forKey:@"firstName"];
            
            CKRecordID *carRecordID = [[CKRecordID alloc] initWithRecordName:car.recordUUID];
            CKRecord *postRecrodCar = [[CKRecord alloc] initWithRecordType:@"Car" recordID:carRecordID];
            [postRecrodCar setValue:car.model forKey:@"model"];
            [postRecrodCar setValue:car.number forKey:@"number"];
            [postRecrodCar setValue:car.color forKey:@"color"];
            
            CKAsset* myImageAsset = nil;
            myImageAsset = [[CKAsset alloc] initWithFileURL:imageURL];
            
            [postRecrodCar setObject: myImageAsset forKey:@"image"];
            
            CKReference *ownerReference = [[CKReference alloc] initWithRecord:postRecrodDriver action:CKReferenceActionNone];
            [postRecrodCar setValue:ownerReference forKey:@"owner"];
            
            CKReference *autoReference = [[CKReference alloc] initWithRecord:postRecrodCar action:CKReferenceActionNone];
            [postRecrodDriver setValue:autoReference forKey:@"auto"];
            
            CKDatabase *publicDatabase = [[CKContainer defaultContainer] publicCloudDatabase];
            
            [publicDatabase saveRecord:postRecrodDriver completionHandler:^(CKRecord *recordDriver, NSError *errorDriver) {
                if(errorDriver) {
                    NSLog(@"%@", errorDriver);
                    completion(NO, nil, errorDriver);
                } else {
                    NSLog(@"Saved driver successfully");
                    
                }
            }];
            
            [publicDatabase saveRecord:postRecrodCar completionHandler:^(CKRecord *recordCar, NSError *errorCar) {
                if(errorCar) {
                    NSLog(@"%@", errorCar);
                    completion(NO, nil, errorCar);
                } else {
                    NSLog(@"Saved car successfully");
                }
            }];
            
            completion(YES, @"Saved Car & Driver successfully", nil);
        } else {
            
            CKRecordID *carRecordID = [[CKRecordID alloc] initWithRecordName:car.recordUUID];
            CKRecord *postRecrodCar = [[CKRecord alloc] initWithRecordType:@"Car" recordID:carRecordID];
            [postRecrodCar setValue:car.model forKey:@"model"];
            [postRecrodCar setValue:car.number forKey:@"number"];
            [postRecrodCar setValue:car.color forKey:@"color"];
            
            CKAsset* myImageAsset = nil;
            myImageAsset = [[CKAsset alloc] initWithFileURL:imageURL];
            
            [postRecrodCar setObject: myImageAsset forKey:@"image"];
            
            CKReference *ownerReference = [[CKReference alloc] initWithRecord:postRecrodDriver action:CKReferenceActionNone];
            [postRecrodCar setValue:ownerReference forKey:@"owner"];
            
            CKReference *autoReference = [[CKReference alloc] initWithRecord:postRecrodCar action:CKReferenceActionNone];
            [postRecrodDriver setValue:autoReference forKey:@"auto"];
            
            CKDatabase *publicDatabase = [[CKContainer defaultContainer] publicCloudDatabase];
            
            [publicDatabase saveRecord:postRecrodDriver completionHandler:^(CKRecord *recordDriver, NSError *errorDriver) {
                if(errorDriver) {
                    NSLog(@"%@", errorDriver);
                    completion(NO, nil, errorDriver);
                } else {
                    NSLog(@"Saved driver successfully");
                    
                }
            }];
            
            [publicDatabase saveRecord:postRecrodCar completionHandler:^(CKRecord *recordCar, NSError *errorCar) {
                if(errorCar) {
                    NSLog(@"%@", errorCar);
                    completion(NO, nil, errorCar);
                } else {
                    NSLog(@"Saved car successfully");
                }
            }];
            
            completion(YES, @"Saved Car & Driver successfully", nil);
        
        }
    }
     
  ];
}
//PK 296 - Изменение Car & Driver в CloudKit
+ (void)updateRecordInCloudWithCar:(Car *_Nullable)car
                          imageCar:(NSURL *_Nullable)imageURL
                         andDriver:(Driver *_Nullable)driver
                        completion:(nullable IMKCloudeKitManagerCompletion)completion {
    
    CKContainer *defaultContainer = [CKContainer defaultContainer];
    CKDatabase *publicDatabase = [defaultContainer publicCloudDatabase];
    
    CKRecordID *driverRecordID = [[CKRecordID alloc] initWithRecordName:driver.recordUUID];
    [publicDatabase fetchRecordWithID:driverRecordID completionHandler:^(CKRecord *postRecrodDriver, NSError *error) {
        if(error) {
            NSLog(@"%@", error);
            
            CKRecordID *driverRecordID = [[CKRecordID alloc] initWithRecordName:driver.recordUUID];
            CKRecord *postRecrodDriver = [[CKRecord alloc] initWithRecordType:@"Driver" recordID:driverRecordID];
            [postRecrodDriver setValue:driver.firstName forKey:@"firstName"];
            
            CKRecordID *carRecordID = [[CKRecordID alloc] initWithRecordName:car.recordUUID];
            [publicDatabase fetchRecordWithID:carRecordID completionHandler:^(CKRecord *postRecrodCar, NSError *error) {
                if(error) {
                    NSLog(@"%@", error);
                } else {
                    [postRecrodCar setValue:car.model forKey:@"model"];
                    [postRecrodCar setValue:car.number forKey:@"number"];
                    [postRecrodCar setValue:car.color forKey:@"color"];
                    
                    CKAsset* myImageAsset = nil;
                    myImageAsset = [[CKAsset alloc] initWithFileURL:imageURL];
                    
                    [postRecrodCar setObject: myImageAsset forKey:@"image"];
                    
                    CKReference *ownerReference = [[CKReference alloc] initWithRecord:postRecrodDriver action:CKReferenceActionNone];
                    [postRecrodCar setValue:ownerReference forKey:@"owner"];
                    
                    CKReference *autoReference = [[CKReference alloc] initWithRecord:postRecrodCar action:CKReferenceActionNone];
                    [postRecrodDriver setValue:autoReference forKey:@"auto"];
                    
                    [publicDatabase saveRecord:postRecrodDriver completionHandler:^(CKRecord *recordDriver, NSError *errorDriver) {
                        if(errorDriver) {
                            NSLog(@"%@", errorDriver);
                            completion(NO, nil, errorDriver);
                        } else {
                            NSLog(@"Updated driver successfully");
                        }
                    }];
                    
                    [publicDatabase saveRecord:postRecrodCar completionHandler:^(CKRecord *recordCar, NSError *errorCar) {
                        if(errorCar) {
                            NSLog(@"%@", errorCar);
                            completion(NO, nil, errorCar);
                        } else {
                            NSLog(@"Updated car successfully");
                        }
                    }];
                    completion(YES, @"Updated Car & Driver successfully", nil);
                }
            }];
        } else {
            [postRecrodDriver setValue:driver.firstName forKey:@"firstName"];
            
            CKRecordID *carRecordID = [[CKRecordID alloc] initWithRecordName:car.recordUUID];
            [publicDatabase fetchRecordWithID:carRecordID completionHandler:^(CKRecord *postRecrodCar, NSError *error) {
                if(error) {
                    NSLog(@"%@", error);
                } else {
                    [postRecrodCar setValue:car.model forKey:@"model"];
                    [postRecrodCar setValue:car.number forKey:@"number"];
                    [postRecrodCar setValue:car.color forKey:@"color"];
                    
                    CKAsset* myImageAsset = nil;
                    myImageAsset = [[CKAsset alloc] initWithFileURL:imageURL];
                    
                    [postRecrodCar setObject: myImageAsset forKey:@"image"];
                    
                    CKReference *ownerReference = [[CKReference alloc] initWithRecord:postRecrodDriver action:CKReferenceActionNone];
                    [postRecrodCar setValue:ownerReference forKey:@"owner"];
                    
                    CKReference *autoReference = [[CKReference alloc] initWithRecord:postRecrodCar action:CKReferenceActionNone];
                    [postRecrodDriver setValue:autoReference forKey:@"auto"];
                    
                    [publicDatabase saveRecord:postRecrodDriver completionHandler:^(CKRecord *recordDriver, NSError *errorDriver) {
                        if(errorDriver) {
                            NSLog(@"%@", errorDriver);
                            completion(NO, nil, errorDriver);
                        } else {
                            NSLog(@"Updated driver successfully");
                        }
                    }];
                    
                    [publicDatabase saveRecord:postRecrodCar completionHandler:^(CKRecord *recordCar, NSError *errorCar) {
                        if(errorCar) {
                            NSLog(@"%@", errorCar);
                            completion(NO, nil, errorCar);
                        } else {
                            NSLog(@"Updated car successfully");
                        }
                    }];
                    completion(YES, @"Updated Car & Driver successfully", nil);
                }
            }];
        }
    }];
}
//PK 296 - Удаление Car в CloudKit
+ (void)deleteRecordInCloudWithCar:(NSString *_Nullable)recordUUID
                        completion:(nullable IMKCloudeKitManagerCompletion)completion {
    
    CKContainer *defaultContainer = [CKContainer defaultContainer];
    CKDatabase *publicDatabase = [defaultContainer publicCloudDatabase];
    CKRecordID *recordID = [[CKRecordID alloc] initWithRecordName:recordUUID];
    [publicDatabase deleteRecordWithID:recordID completionHandler:^(CKRecordID *recordID, NSError *error) {
        if(error) {
            NSLog(@"%@", error);
            completion(NO, nil, error);
        } else {
            NSLog(@"Deleted record successfully");
        }
    }];
    
    completion(YES, @"Deleted Car successfully", nil);
}

@end
