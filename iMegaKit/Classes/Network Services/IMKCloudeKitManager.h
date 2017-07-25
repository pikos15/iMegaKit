//
//  IMKCloudeKitManager.h
//  iMegaKit
//
//  Created by Konstantin Pikhterev on 23.07.17.
//  Copyright © 2017 MegaKit. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Car+CoreDataClass.h"
#import "Car+CoreDataProperties.h"
#import "Driver+CoreDataClass.h"
#import "Driver+CoreDataProperties.h"

@class UIImage;
@class CKRecord;

typedef void (^IMKCloudeKitManagerCompletion)(BOOL success, NSString *_Nullable result, NSError * _Nullable error);

@interface IMKCloudeKitManager : NSObject

#pragma mark - CloudKit -

+ (void)saveRecordToCloudWithCar:(Car *_Nullable)car
                        imageCar:(NSURL *_Nullable)imageURL
                       andDriver:(Driver *_Nullable)driver
                      completion:(nullable IMKCloudeKitManagerCompletion)completion;

+ (void)updateRecordInCloudWithCar:(Car *_Nullable)car
                        imageCar:(NSURL *_Nullable)imageURL
                       andDriver:(Driver *_Nullable)driver
                      completion:(nullable IMKCloudeKitManagerCompletion)completion;

+ (void)deleteRecordInCloudWithCar:(NSString *_Nullable)recordUUID
                        completion:(nullable IMKCloudeKitManagerCompletion)completion;

@end
