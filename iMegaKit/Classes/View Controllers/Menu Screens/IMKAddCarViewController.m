//
//  IMKAddCarViewController.m
//  iMegaKit
//
//  Created by Konstantin Pikhterev on 20.07.17.
//  Copyright © 2017 MegaKit. All rights reserved.
//

#import "IMKAddCarViewController.h"

#import "IMKPickDriverViewController.h"
#import "IMKPickColorCarViewController.h"

#import "IMKCoreDataManager.h"
#import "IMKCloudeKitManager.h"

#import "Car+CoreDataClass.h"
#import "Car+CoreDataProperties.h"
#import "Driver+CoreDataClass.h"
#import "Driver+CoreDataProperties.h"

#import "IMKInfoHelper.h"

@import CloudKit;

@interface IMKAddCarViewController () <UIImagePickerControllerDelegate, UITextFieldDelegate, IMKPickColorCarDelegate>

@property (weak, nonatomic) IBOutlet UITextField *modelTextField;
@property (weak, nonatomic) IBOutlet UITextField *numberTextField;
@property (weak, nonatomic) IBOutlet UITextField *driverTextField;
@property (weak, nonatomic) IBOutlet UIButton *makePhotoButton;
@property (weak, nonatomic) IBOutlet UIButton *selectPhotoButton;
@property (weak, nonatomic) IBOutlet UIButton *selectColorButton;

@property (retain, nonatomic) NSData *imageData;
@property (retain, nonatomic) NSData *colorData;
@property (strong, nonatomic) UIImage *selectedImage;
@property (strong, nonatomic) UIColor *selectedColor;
@property (strong, nonatomic) Driver *selectedDriver;

@property (strong, nonatomic) UIImagePickerController *cameraPicker;
@property (weak, nonatomic) IBOutlet UIImageView *carImageView;

@property (strong, nonatomic) NSURL *imageURL;

@end

@implementation IMKAddCarViewController

#pragma mark - LifeCicle -

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [IMKInfoHelper addRoundBorderToView:self.makePhotoButton
                       withCornerRadius:25.0f
                            borderWidth:1.0f
                            borderColor:[UIColor lightGrayColor]];
    [IMKInfoHelper addRoundBorderToView:self.selectPhotoButton
                       withCornerRadius:25.0f
                            borderWidth:1.0f
                            borderColor:[UIColor lightGrayColor]];
    [IMKInfoHelper addRoundBorderToView:self.selectColorButton
                       withCornerRadius:25.0f
                            borderWidth:1.0f
                            borderColor:[UIColor lightGrayColor]];
    
    self.selectedColor = [UIColor whiteColor];
    self.colorData = [NSKeyedArchiver archivedDataWithRootObject:self.selectedColor];
    self.selectColorButton.backgroundColor = self.selectedColor;
    //PK 296 - Открытие детальной информации о Car с сохранением свойств для последующей записи
    if (self.car) {
        self.carImageView.image = [UIImage imageWithData: self.car.image];
        self.selectedImage = [UIImage imageWithData:self.car.image];
        self.imageData = self.car.image;
        [self createImageURL];
        
        self.selectedColor = (UIColor *)[NSKeyedUnarchiver unarchiveObjectWithData:(NSData *)self.car.color];
        self.colorData = (NSData *)self.car.color;
        self.selectColorButton.backgroundColor = self.selectedColor;
        self.selectedDriver = self.car.owner;
        self.modelTextField.text = self.car.model;
        self.numberTextField.text = self.car.number;
        self.driverTextField.text = self.car.owner.firstName;
    }
}

#pragma mark - UITextFieldDelegate -

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self hideKeyboard];
    
}


- (BOOL)textFieldShouldBeginEditing:(UITextField*)textField {
    //PK 296 - Для ввода текста в textFields для удобства используем алерты
    NSString *currentText = textField.text;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:textField.placeholder message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Введите данные";
        textField.text = currentText;
        textField.delegate = self;
    }];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Готово" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        
        if (alert.textFields.firstObject.text.length > 0) {
           
            textField.text = alert.textFields.firstObject.text;
        }
        else {
            [self showAlertWithTitle:@"" message:@"Введите" buttonTitle:@"OK"];
        }
    }];
    
    UIAlertAction *cancelButton = [UIAlertAction actionWithTitle:@"Отмена"
                                                           style:UIAlertActionStyleDestructive
                                                         handler:^(UIAlertAction * action) {
                                                             [alert dismissViewControllerAnimated:YES completion:nil];
                                                         }];
    
    [alert addAction:okAction];
    [alert addAction:cancelButton];
    
    [self presentViewController:alert];
    
    if (textField == self.driverTextField) {
        self.selectedDriver = nil;
    }
    
    return YES;
}

#pragma mark - Actions -

- (IBAction)saveBattonPressed:(UIBarButtonItem *)sender {
   //PK 296 - Запись Car & Driver в CoreData и CloudKit
    if (!self.selectedDriver) {
        NSDictionary *paramsDriver = @{@"firstName" : self.driverTextField.text};
        
        [[IMKCoreDataManager sharedManager] addDriverWithParams:paramsDriver completion:^(BOOL success, id  _Nullable result, NSError * _Nullable error) {
            if (success) {
                self.selectedDriver = result;
            }
            else {
                NSString *errorMessage = [error localizedDescription];
                [self showAlertWithTitle:@"Ошибка создания Driver" message:errorMessage buttonTitle:@"OK"];
            }
        }];
    }
    
    NSDictionary *paramsCar = @{@"model" : self.modelTextField.text,
                                @"number" : self.numberTextField.text,
                                @"owner" : self.selectedDriver,
                                @"imageData" : self.imageData,
                                @"colorData" : self.colorData
                                };
    
    if (self.car) {
        [[IMKCoreDataManager sharedManager] editCar:self.car withParams:paramsCar completion:^(BOOL success, id  _Nullable result, NSError * _Nullable error) {
            
            if (success) {
                
                [IMKCloudeKitManager updateRecordInCloudWithCar:self.car imageCar:self.imageURL andDriver:self.selectedDriver completion:^(BOOL success, NSString * _Nullable result, NSError * _Nullable error) {
                    
                    if (success) {
                        NSLog(@"%@",result);
                    }
                    else {
                        NSString *errorMessage = [error localizedDescription];
                        [self showAlertWithTitle:@"Ошибка изменения в CloudKit" message:errorMessage buttonTitle:@"OK"];
                    }
                }];
            }
            else {
                NSString *errorMessage = [error localizedDescription];
                [self showAlertWithTitle:@"Ошибка изменения Car" message:errorMessage buttonTitle:@"OK"];
            }
        }];
    } else {
        
        [[IMKCoreDataManager sharedManager] addCarWithParams:paramsCar completion:^(BOOL success, id  _Nullable result, NSError * _Nullable error) {
            if (success) {
                
                [IMKCloudeKitManager saveRecordToCloudWithCar:result imageCar:self.imageURL andDriver:self.selectedDriver completion:^(BOOL success, NSString * _Nullable result, NSError * _Nullable error) {
                    if (success) {
                        NSLog(@"%@",result);
                    }
                    else {
                        NSString *errorMessage = [error localizedDescription];
                        [self showAlertWithTitle:@"Ошибка создания в CloudKit" message:errorMessage buttonTitle:@"OK"];
                    }
                }];
            }
            else {
                NSString *errorMessage = [error localizedDescription];
                [self showAlertWithTitle:@"Ошибка создания Car" message:errorMessage buttonTitle:@"OK"];
            }
        }];
    }
}

- (IBAction)selectPhotoButtonPressed:(UIButton *)sender {
    //PK 296 - Выбор фото авто
    UIImagePickerController *pickerViewController = [[UIImagePickerController alloc] init];
    pickerViewController.allowsEditing = YES;
    pickerViewController.delegate = self;
    [pickerViewController setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [self presentViewController:pickerViewController animated:YES completion:nil];
}
//PK 296 - Выбор цвета авто
- (IBAction)selectColorButtonPressed:(UIButton *)sender {
    IMKPickColorCarViewController *presentViewController = [[IMKPickColorCarViewController alloc] initWithNibName:@"IMKPickColorCarViewController" bundle:nil];
    presentViewController.delegate = self;
    [self presentViewController:presentViewController];
}

//PK 296 - Выбор водителя
- (IBAction)driversButtonPressed:(UIButton *)sender {
    IMKPickDriverViewController *presentViewController = [[IMKPickDriverViewController alloc] initWithNibName:@"IMKPickDriverViewController" bundle:nil];
    presentViewController.delegate = self;
    [self presentViewController:presentViewController];
}

#pragma mark - Custom Methods -

- (void)hideKeyboard {
    [self.view endEditing:YES];
}

- (void)createImageURL {

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* path = [documentsDirectory stringByAppendingPathComponent:@"image.png" ];
    [self.imageData writeToFile:path atomically:YES];
    NSURL* myImagePath = nil;
    myImagePath = [[NSBundle mainBundle] URLForResource:path withExtension:@"png"];
    self.imageURL = [NSURL fileURLWithPath:path];
}

#pragma mark - Delegate -
//PK 296 - Методы делегата - запись полученных при выборе данных
- (void)driverFromPickDriverController:(Driver *)driver {
    
    self.selectedDriver = driver;
    self.driverTextField.text = driver.firstName;
}

- (void)colorFromPickColorCarController:(UIColor *)color {
    
    self.selectedColor = color;
    self.selectColorButton.backgroundColor = color;
    self.colorData = [NSKeyedArchiver archivedDataWithRootObject:color];
}

#pragma mark - Photo camera Buttons -
//PK 296 - Открываем фотокамеру для фото авто
- (IBAction)photoCameraButtonPressed:(UIButton *)sender {
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]){
        
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType =  UIImagePickerControllerSourceTypeCamera;
        imagePicker.videoQuality = UIImagePickerControllerQualityTypeHigh;
        imagePicker.delegate = self;
        imagePicker.mediaTypes = [UIImagePickerController  availableMediaTypesForSourceType:imagePicker.sourceType];
        [self presentModalViewController:imagePicker animated:YES];
    } else {
        NSLog(@"Ваше устройство не поддерживает эту функцию");
    }
}

#pragma mark - UIImagePickerControllerDelegate -
//PK 296 - Обработка сделанного/выбранного фото
- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    NSString* mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ( [ mediaType isEqualToString:@"public.image" ]) {
        
        UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        self.carImageView.image = image;
        self.imageData = UIImageJPEGRepresentation(image, 0.0);
//        self.imageURL = (NSURL *)[info valueForKey:UIImagePickerControllerReferenceURL];
        [self createImageURL];
        
    } else if ( [ mediaType isEqualToString:@"public.movie" ]){
        NSString *moviePath = [[info objectForKey:UIImagePickerControllerMediaURL] path];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
