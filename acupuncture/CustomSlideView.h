//
//  CustomSlideView.h
//  acupuncture
//
//  Created by 陈双超 on 15/7/31.
//  Copyright (c) 2015年 陈双超. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CSCSlideDelegate
@optional
-(void)UpdateStrengthSlide:(int)value fromView:(UIView*)view;
@end

@interface CustomSlideView : UIView{
    BOOL isContain;
    UIImageView *Headerphoto;
    int time;
}
@property (nonatomic, weak) id <CSCSlideDelegate> SlideDelegate;
-(void)setNumber:(int)i;
@end
