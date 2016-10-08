//
//  LunBoVC.h
//  acupuncture
//
//  Created by 陈双超 on 15/6/2.
//  Copyright (c) 2015年 陈双超. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LunBoVC : UIViewController<UIScrollViewDelegate>{
    UIScrollView *MySV;
    UIPageControl *pageControl;
}

- (IBAction)goBackAction:(id)sender;

@end
