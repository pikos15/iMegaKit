//
//  IMKPickDriverViewController.m
//  iMegaKit
//
//  Created by Константин on 21.07.17.
//  Copyright © 2017 MegaKit. All rights reserved.
//

#import "IMKPickDriverViewController.h"

#import "IMKPickDriverCell.h"
#import "IMKInfoHelper.h"
#import "Driver+CoreDataClass.h"
#import "Driver+CoreDataProperties.h"

#import "IMKCoreDataManager.h"

@interface IMKPickDriverViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *dataArray;

@end

@implementation IMKPickDriverViewController

#pragma mark - Lifecycle -
//PK 296 - Открываем модально контроллер выбора водителя
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationOverFullScreen;
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationOverFullScreen;
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([IMKPickDriverCell class]) bundle:nil]
         forCellReuseIdentifier:[IMKPickDriverCell cellIdentifier]];
    //PK 296 - добавили tap для удобного закрытия контроллера
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissViewController:)];
    [self.view addGestureRecognizer:tap];
    [tap setCancelsTouchesInView:NO];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //PK 296 - Получаем массив водителей
    [self getData];
}

- (void)dismissViewController:(UIGestureRecognizer *)gestureRecognizer {
    CGPoint touchPoint = [gestureRecognizer locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:touchPoint];
    if (!indexPath) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - DataManager -

- (void)getData {
    
    [[IMKCoreDataManager sharedManager]
     fetchRequestWithEntityName:@"Driver"
     params:nil
     completion:^(BOOL success, id  _Nullable result, NSError * _Nullable error) {
         if (success) {
             self.dataArray = result;
             [self.tableView reloadData];
         }
     }];
}

#pragma mark - UITableView DataSource -
//PK 296 - Логика tableView стандартная
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    IMKPickDriverCell *cell = [tableView dequeueReusableCellWithIdentifier:[IMKPickDriverCell cellIdentifier] forIndexPath:indexPath];
    Driver *driver = [self.dataArray objectAtIndex:indexPath.row];
    
    [cell configureCellWithObject:driver];
    
    return cell;
}

#pragma mark - UITableView Delegate -

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Driver *driver = [self.dataArray objectAtIndex:indexPath.row];
    
    IMKPickDriverCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    cell.selected = YES;
    
    [self.delegate driverFromPickDriverController:driver];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
