//
//  MainCell.h
//  NT
//
//  Created by Kohn on 14-5-27.
//  Copyright (c) 2014年 Pem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AKPickerView.h"
#import "CustomSlideView.h"

@interface MainCell : UITableViewCell

@property (strong, nonatomic)  CustomSlideView *StrengthView;
@property (strong, nonatomic)  AKPickerView *MyPickerView;

@end


