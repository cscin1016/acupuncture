//
//  CustomMode.h
//  acupuncture
//
//  Created by 陈双超 on 15/7/22.
//  Copyright (c) 2015年 陈双超. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AKPickerView.h"
#import "CustomSlideView.h"

@interface CustomMode : UIViewController<AKPickerViewDataSource, AKPickerViewDelegate,CSCSlideDelegate>


- (IBAction)BackAction:(UIButton *)sender;
@end
