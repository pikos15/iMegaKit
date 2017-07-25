//
//  IMKPickColorCarViewController.m
//  iMegaKit
//
//  Created by Konstantin Pikhterev on 22.07.17.
//  Copyright © 2017 MegaKit. All rights reserved.
//

#import "IMKPickColorCarViewController.h"

#import "IMKInfoHelper.h"
#import "IMKPickColorCell.h"

static const CGFloat IMKMenuHideConstraint = -65.0f;
static const CGFloat IMKMenuShowConstraint = 0.0f;
static const CGFloat IMKAnimationDurationShow = 0.25f;
static const CGFloat IMKAnimationDurationHide = 0.5f;

@interface IMKPickColorCarViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIView *menuView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *menuRightConstraint;

@property (strong, nonatomic) NSArray *dataArray;

@end

@implementation IMKPickColorCarViewController
#pragma mark - Lifecycle -
//PK 296 - Модально открываем контролер меню выбора цвета авто
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
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissViewController:)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"IMKPickColorCell" bundle:nil] forCellWithReuseIdentifier:[IMKPickColorCell cellIdentifier]];
    
    [IMKInfoHelper addLeftSideShadow:self.menuView];
    [self getData];
}

- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:NO];
    
    [self showMenu];
}

#pragma mark - DataManager -

- (void)getData {
    self.dataArray = [IMKInfoHelper colorsArray];
    [self.collectionView reloadData];
}

#pragma mark - UICollectionView DataSource -

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    IMKPickColorCell *colorCell = [self.collectionView dequeueReusableCellWithReuseIdentifier:[IMKPickColorCell cellIdentifier] forIndexPath:indexPath];
   UIColor *colorItem = [self.dataArray objectAtIndex:indexPath.row];
    [colorCell configureCellWithObject:colorItem];
    
    return colorCell;
}

#pragma mark - UICollectionView Delegate -

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    self.selectedColor = [self.dataArray objectAtIndex:indexPath.row];
  
    
    [self animateCellShake:cell];
}

#pragma mark - Custom Methods -

- (void)dismissViewController:(UIGestureRecognizer *)gestureRecognizer {
    CGPoint touchPoint = [gestureRecognizer locationInView:self.view];
    if (!CGRectContainsPoint(self.menuView.frame, touchPoint)) {
        [self hideMenu];
    }
}
//PK 296 - Меню показываем/скрываем с анимацией
- (void)showMenu {
    [self animateMenuWithConstraint:IMKMenuShowConstraint animateDuration:IMKAnimationDurationShow];
}

- (void)hideMenu {
    [self animateMenuWithConstraint:IMKMenuHideConstraint animateDuration:IMKAnimationDurationHide];
}

#pragma mark - Animations -

- (void)animateMenuWithConstraint:(CGFloat)constraint animateDuration:(CGFloat)animateDuration {
    [UIView animateWithDuration:animateDuration animations:^{
        self.menuRightConstraint.constant = constraint;
        [self.view layoutIfNeeded];
    }
                     completion:^(BOOL finished) {
                         if (constraint == IMKMenuHideConstraint) {
                             [self dismissViewControllerAnimated:NO completion:nil];
                         }
                     }];
}
//PK 296 - Это для прикола чуть анимации при выборе цвета
- (void)animateCellShake:(UICollectionViewCell *)cell {
    
    cell.transform = CGAffineTransformMakeTranslation(20, 0);
    [UIView animateWithDuration:0.4
                          delay:0.0
         usingSpringWithDamping:0.2
          initialSpringVelocity:1.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         cell.transform = CGAffineTransformIdentity;
                     }
                     completion:^(BOOL finished) {
                         [self dismissViewControllerAnimated:YES completion:^{
                             [self.delegate colorFromPickColorCarController:self.selectedColor];
                         }];
                     }];
}

@end
