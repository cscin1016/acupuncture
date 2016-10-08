//
//  GuidePageViewController.m
//  acupuncture
//
//  Created by 陈双超 on 15/9/15.
//  Copyright (c) 2015年 陈双超. All rights reserved.
//

#import "GuidePageViewController.h"
#import "AppDelegate.h"

#define ScreenHeight ([UIScreen mainScreen].bounds.size.height)
#define ScreenWidth ([UIScreen mainScreen].bounds.size.width)

@interface GuidePageViewController ()

@end

@implementation GuidePageViewController

+ (GuidePageViewController *)sharedGuide
{
    @synchronized(self)
    {
        static GuidePageViewController *sharedGuide = nil;
        if (sharedGuide == nil)
        {
            sharedGuide = [[self alloc] initWithNibName:@"GuidePageViewController" bundle:nil];
        }
        return sharedGuide;
    }
}
+ (void)show
{
    [[GuidePageViewController sharedGuide] showGuide];
    //    NSLog(@"引导界面显示");
}

+ (void)hide
{
    [[GuidePageViewController sharedGuide] hideGuide];
    //    NSLog(@"引导界面隐藏");
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //    NSLog(@"引导界面");
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        int ChangeTag=0;
        BOOL ChangeAdd=YES;
        while (YES) {
            //通知主线程刷新
            ChangeTag=ChangeTag+4;
            if(ChangeTag>40){
                ChangeTag=0;
                ChangeAdd=!ChangeAdd;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                //回调或者说是通知主线程刷新
                if (ChangeAdd) {
                    [_MyBreathImage setFrame:CGRectMake(ScreenWidth*0.5-100-ChangeTag*0.5, ScreenHeight*0.5-90-ChangeTag*0.5, 200+ChangeTag, 200+ChangeTag)];
                }else{
                    [_MyBreathImage setFrame:CGRectMake(ScreenWidth*0.5-120+ChangeTag*0.5, ScreenHeight*0.5-110+ChangeTag*0.5, 240-ChangeTag, 240-ChangeTag)];
                }
            });
            [NSThread sleepForTimeInterval:0.1];
        }
        
    });
}
- (void)showGuide
{
    //	if (!_animating && self.view.superview == nil)
    //	{
    [GuidePageViewController sharedGuide].view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    [[self mainWindow] addSubview:[GuidePageViewController sharedGuide].view];
    //		_animating = NO;
    //		[UIView beginAnimations:nil context:nil];
    //		[UIView setAnimationDuration:0];
    //		[UIView setAnimationDelegate:self];
    //		[UIView setAnimationDidStopSelector:@selector(guideShown)];
    //		[GuidePageViewController sharedGuide].view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    //		[UIView commitAnimations];
    //	}
}
- (void)hideGuide
{
    
    
    [[[GuidePageViewController sharedGuide] view] removeFromSuperview];
    return;
    //    if (!_animating && self.view.superview != nil)
    //    {
    //        _animating = YES;
    //        [UIView beginAnimations:nil context:nil];
    //        [UIView setAnimationDuration:0.4];
    //        [UIView setAnimationDelegate:self];
    //        [UIView setAnimationDidStopSelector:@selector(guideHidden)];
    //        [GuidePageViewController sharedGuide].view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    //        [UIView commitAnimations];
    //    }
}
//- (void)guideShown
//{
//	_animating = NO;
//}
//- (void)guideHidden
//{
//	_animating = NO;
//	[[[GuidePageViewController sharedGuide] view] removeFromSuperview];
//}

- (UIWindow *)mainWindow
{
    UIApplication *app = [UIApplication sharedApplication];
    if ([app.delegate respondsToSelector:@selector(window)]){
        return [app.delegate window];
    }else{
        return [app keyWindow];
    }
}

- (IBAction)joinClick:(UIButton *)sender {
    [self hideGuide];
    //    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstLaunch"];
}

@end
