//
//  DeviceVC.h
//  acupuncture
//
//  Created by 陈双超 on 15/5/13.
//  Copyright (c) 2015年 陈双超. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

#import "CoreBluetooth/CoreBluetooth.h"

#define TRANSFER_CHARACTERISTIC_UUID_2B01    @"2B01"
#define TRANSFER_CHARACTERISTIC_UUID_F202    @"F202"

@interface DeviceVC : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate,UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UIButton *TitleButton;//顶部改名按钮
@property (weak, nonatomic) IBOutlet UILabel *ElectricLabel;//电量label
@property (weak, nonatomic) IBOutlet UIImageView *ElectricImage;//电量image
@property (weak, nonatomic) IBOutlet UIButton *SetButton;//头像选择按钮
@property (weak, nonatomic) IBOutlet UIImageView *RotationImageView;//中间旋转图片
@property (weak, nonatomic) IBOutlet UIButton *CenterButton;//中间开始暂停按钮

@property (weak, nonatomic) IBOutlet UIView *MyMoreView;//更多view，包含轮播和关于按钮

@property (weak, nonatomic) IBOutlet UILabel *RemainTimeLabel;

@property (strong,nonatomic) UIImagePickerController *MyImagePicker;//选择相册对象
@property (strong,nonatomic) NSNumber *deviceType;//第几个设备
@property (strong,nonatomic) CBPeripheral *peripheralOpration;//操作的蓝牙对象
@property (strong,nonatomic) CBCentralManager *cbCentralMgr;//蓝牙控制中心


- (IBAction)ShowLunBoAction:(UIButton *)sender;
- (IBAction)StartOrPause:(UIButton *)sender;
- (IBAction)ChangeNameAction:(id)sender;

- (IBAction)goBackAction:(id)sender;
- (IBAction)SetButtonAction:(id)sender;

@end
