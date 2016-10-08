//
//  StrengthVC.h
//  acupuncture
//
//  Created by 陈双超 on 15/5/15.
//  Copyright (c) 2015年 陈双超. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "draw_graphic.h"

@interface StrengthVC : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *StrengthLabel;

@property (weak, nonatomic) IBOutlet draw_graphic *myView;


- (IBAction)jianAction:(UIButton *)sender;

- (IBAction)jiaAction:(UIButton *)sender;

- (IBAction)BackAction:(UIButton *)sender;

- (IBAction)StrengthSaveAction:(UIButton *)sender;


@end
