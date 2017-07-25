//
//  ListCarViewController.m
//  iMegaKit
//
//  Created by Konstantin Pikhterev on 20.07.17.
//  Copyright © 2017 MegaKit. All rights reserved.
//

#import "ListCarViewController.h"

#import "IMKAddCarViewController.h"

#import "IMKCoreDataManager.h"
#import "IMKCloudeKitManager.h"

#import "IMKListCarTableViewCell.h"

#import "Car+CoreDataClass.h"
#import "Car+CoreDataProperties.h"
#import "Driver+CoreDataClass.h"
#import "Driver+CoreDataProperties.h"

@interface ListCarViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSArray *dataArray;

@property (strong, nonatomic) NSString *deletedCarRecordUUID;

@end

@implementation ListCarViewController

#pragma mark - LifeCicle -

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //PK 296 - Перед отображением получаем массив Car из SQLite
    [self fetchCars];
    [self.tableView reloadData];
}

- (void)fetchCars {
    
    [[IMKCoreDataManager sharedManager]
     fetchRequestWithEntityName:@"Car"
     params:nil
     completion:^(BOOL success, id  _Nullable result, NSError * _Nullable error) {
         if (success) {
             self.dataArray = result;
         }
     }];
}
//PK 296 - Стандартные методы создания и вывода tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    IMKListCarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[IMKListCarTableViewCell cellIdentifier] forIndexPath:indexPath];
    
    Car *car = self.dataArray[indexPath.row];
    [cell configureCellWithObject:car];
    
    return cell;
}
//PK 296 - Выбираем ячейку с авто для детального рассмотрения или редактирования
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Car *car = self.dataArray[indexPath.row];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    IMKAddCarViewController *presentViewController = [storyboard instantiateViewControllerWithIdentifier:@"IMKAddCarViewController"];
    presentViewController.car = car;
    [self.navigationController pushViewController:presentViewController animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}
//PK 296 - Удаляем авто из SQLite & CloudKit
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Car *car = self.dataArray[indexPath.row];
        self.deletedCarRecordUUID = car.recordUUID;
        [[IMKCoreDataManager sharedManager] deleteCar:car completion:^(BOOL success, id  _Nullable result, NSError * _Nullable error) {
            
            if (success) {
                
                [self fetchCars];
                [self.tableView reloadData];
                
                [IMKCloudeKitManager deleteRecordInCloudWithCar:self.deletedCarRecordUUID completion:^(BOOL success, NSString * _Nullable result, NSError * _Nullable error) {
                    
                    if (success) {
                        NSLog(@"%@",result);
                    }
                    else {
                        NSString *errorMessage = [error localizedDescription];
                        [self showAlertWithTitle:@"Ошибка удаления в CloudKit" message:errorMessage buttonTitle:@"OK"];
                    }
                }];
            }
            else {
                NSString *errorMessage = [error localizedDescription];
                [self showAlertWithTitle:@"Ошибка удаления Car" message:errorMessage buttonTitle:@"OK"];
            }
        }];
    }
}

@end
