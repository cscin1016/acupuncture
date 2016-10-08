//
//  ViewController.h
//  acupuncture
//
//  Created by 陈双超 on 15/5/12.
//  Copyright (c) 2015年 陈双超. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "CoreBluetooth/CoreBluetooth.h"

@interface ViewController : UIViewController<CBCentralManagerDelegate,CBPeripheralDelegate,UIActionSheetDelegate>

@property (strong,nonatomic) CBCentralManager * cbCentralMgr;

@property (weak, nonatomic) IBOutlet UITableView *MyTableView;

@property (weak, nonatomic) IBOutlet UILabel *label;

@end

