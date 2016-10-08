//
//  GuidePageViewController.h
//  acupuncture
//
//  Created by 陈双超 on 15/9/15.
//  Copyright (c) 2015年 陈双超. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GuidePageViewController : UIViewController
@property (nonatomic, assign) BOOL animating;
@property (weak, nonatomic) IBOutlet UIImageView *MyBreathImage;

+ (GuidePageViewController *)sharedGuide;
+ (void)show;
+ (void)hide;

- (IBAction)joinClick:(UIButton *)sender;
@end
