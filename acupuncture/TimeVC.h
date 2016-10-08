//
//  TimeVC.h
//  acupuncture
//
//  Created by 陈双超 on 15/5/14.
//  Copyright (c) 2015年 陈双超. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "draw_graphic.h"

@interface TimeVC : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *TimeLebel;

@property (weak, nonatomic) IBOutlet draw_graphic *myView;

- (IBAction)timeMinusAction:(UIButton *)sender;
- (IBAction)timePlusAction:(UIButton *)sender;

- (IBAction)BackAction:(UIButton *)sender;

- (IBAction)TimeSaveAction:(UIButton *)sender;

@end
