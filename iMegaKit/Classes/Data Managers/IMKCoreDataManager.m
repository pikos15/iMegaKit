//
//  IMKCoreDataManager.m
//  iMegaKit
//
//  Created by Konstantin Pikhterev on 23.07.17.
//  Copyright © 2017 MegaKit. All rights reserved.
//

#import "IMKCoreDataManager.h"

#import "Car+CoreDataClass.h"
#import "Car+CoreDataProperties.h"
#import "Driver+CoreDataClass.h"
#import "Driver+CoreDataProperties.h"

@interface IMKCoreDataManager()

@property (nonatomic) NSManagedObjectContext * _Nullable context;
@property (strong, nonatomic) NSError *error;

@end

@implementation IMKCoreDataManager

#pragma mark - Singleton -
//PK 296 - Создание либо получение ссылки на единственный экземпляр синглтона
+(IMKCoreDataManager *) sharedManager{
    
    static IMKCoreDataManager *manager = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken,^{
        manager = [[IMKCoreDataManager alloc] init];
    });
    
    return manager;
}

#pragma mark - init self
//PK 296 - Инициализация синглтона
- (instancetype)init{
    
    self = [super init];
    if (self) {
        
        self.context = self.persistentContainer.viewContext;
    }
    return self;
}

#pragma mark - Add data to CoreData-
//PK 296 - Добавление Car в SQLite
- (void)addCarWithParams:(NSDictionary *_Nullable)params
              completion:(nullable IMKCoreDataManagerCompletion)completion {

    Car *newEntity = [[Car alloc] initWithContext:self.context];
    newEntity.model = [params valueForKey:@"model"];
    newEntity.number = [params valueForKey:@"number"];
    newEntity.owner = [params valueForKey:@"owner"];
    newEntity.image = [params valueForKey:@"imageData"];
    newEntity.color = [params valueForKey:@"colorData"];
    newEntity.recordUUID = [[[NSUUID alloc] init] UUIDString];
    
    [self saveContext];
    
    if (self.error) {
        completion(NO, nil, self.error);
    } else {
        completion(YES, newEntity, nil);
    }
}
//PK 296 - Добавление Driver в SQLite
- (void)addDriverWithParams:(NSDictionary *_Nullable)params
                 completion:(nullable IMKCoreDataManagerCompletion)completion {

    Driver *newEntity = [[Driver alloc] initWithContext:self.context];
    newEntity.firstName = [params valueForKey:@"firstName"];
    newEntity.recordUUID = [[[NSUUID alloc] init] UUIDString];
    
    [self saveContext];
    
    if (self.error) {
        completion(NO, nil, self.error);
    } else {
        completion(YES, newEntity, nil);
    }
}

#pragma mark - Get data from CoreData -
//PK 296 - Простой запрос для получения массива сущностей из SQLite
- (void)fetchRequestWithEntityName:(NSString *_Nullable)name
                            params:(NSDictionary *_Nullable)params
                        completion:(nullable IMKCoreDataManagerCompletion)completion {
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:name];
    NSMutableArray *array = [NSMutableArray array];
    
    NSError *error = nil;
    if ([name isEqualToString:@"Car"]) {
        NSArray <Car *> *carsArray = [self.context executeFetchRequest:request error:&error];
        for (Car *car in carsArray) {
            [array addObject:car];
        }
    }
    if ([name isEqualToString:@"Driver"]) {
        NSArray <Driver *> *driversArray = [self.context executeFetchRequest:request error:&error];
        for (Driver *driver in driversArray) {
            [array addObject:driver];
        }
    }
    
    if (array.count > 0 && !error) {
        completion(YES, [array copy], nil);
    } else {
        completion(NO, nil, error);
    }
}

#pragma mark - Edit data in CoreData -
//PK 296 - Изменение Car в SQLite
- (void)editCar:(Car *_Nullable)theCar withParams:(NSDictionary *_Nullable)params
     completion:(nullable IMKCoreDataManagerCompletion)completion {

    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Car"];
 
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"model == BMW"];
//    request.predicate = predicate;
    
    NSArray <Car *> *cars = [self.context executeFetchRequest:request error:nil];
    //PK 296 - Проверка равенства Car по ссылке, но как вариант также можно сравнивать по recordUUID
    for (Car *car in cars) {
        if (car == theCar) {
            theCar.model = [params valueForKey:@"model"];
            theCar.number = [params valueForKey:@"number"];
            theCar.owner = [params valueForKey:@"owner"];
            theCar.image = [params valueForKey:@"imageData"];
            theCar.color = [params valueForKey:@"colorData"];
        }
    }

    [self saveContext];
    
    if (self.error) {
        completion(NO, nil, self.error);
    } else {
        completion(YES, theCar, nil);
    }
}

#pragma mark - Delete data in CoreData -
//PK 296 - Удаление Car из SQLite
- (void)deleteCar:(Car *_Nullable)theCar completion:(nullable IMKCoreDataManagerCompletion)completion{

    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Car"];
    NSArray <Car *> *cars = [self.context executeFetchRequest:request error:nil];
    
    for (Car *car in cars) {
        if (car == theCar) {
            [self.context deleteObject:theCar];
        }
    }
    
    [self saveContext];
    
    if (self.error) {
        completion(NO, nil, self.error);
    } else {
        completion(YES, theCar, nil);
    }
}

#pragma mark - Core Data stack -

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"iMegaKit"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

- (void)saveContext {
    
    NSError *error = nil;
    if ([self.context hasChanges] && ![self.context save:&error]) {
        
        self.error = error;
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}


@end
