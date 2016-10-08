//
//  AppDelegate.h
//  acupuncture
//
//  Created by 陈双超 on 15/5/12.
//  Copyright (c) 2015年 陈双超. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreBluetooth/CoreBluetooth.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong,nonatomic) CBCentralManager * cbCentralMgr;

@property (strong,nonatomic) UIWindow *window;

@end

