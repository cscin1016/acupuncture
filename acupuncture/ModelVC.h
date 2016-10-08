//
//  ModelVC.h
//  acupuncture
//
//  Created by 陈双超 on 15/5/14.
//  Copyright (c) 2015年 陈双超. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ModelVC : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *modeOne;
@property (weak, nonatomic) IBOutlet UILabel *modeTwo;
@property (weak, nonatomic) IBOutlet UILabel *modeThree;
@property (weak, nonatomic) IBOutlet UILabel *modeFour;


- (IBAction)SelectModeAction:(UIButton *)sender;


- (IBAction)GetBackAction:(UIButton *)sender;



@end
