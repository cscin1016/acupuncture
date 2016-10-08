//
//  LunBoVC.m
//  acupuncture
//
//  Created by 陈双超 on 15/6/2.
//  Copyright (c) 2015年 陈双超. All rights reserved.
//

#import "LunBoVC.h"
#define ScreenHeight ([UIScreen mainScreen].bounds.size.height)
#define ScreenWidth ([UIScreen mainScreen].bounds.size.width)

@interface LunBoVC (){
    NSInteger currentPage;
    CGFloat offset;
}
@end

@implementation LunBoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    MySV=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 64,ScreenWidth, ScreenHeight-64)];
    MySV.contentSize=CGSizeMake(2*ScreenWidth, ScreenHeight-64);
    MySV.pagingEnabled=YES;
    MySV.bounces=NO;
    MySV.delegate=self;
    MySV.showsHorizontalScrollIndicator = NO;
    MySV.showsVerticalScrollIndicator = NO;
    MySV.multipleTouchEnabled=YES;
    MySV.minimumZoomScale=1.0;
    MySV.maximumZoomScale=3.0;
    for (int i=0; i<2; i++) {
        UITapGestureRecognizer *doubleTap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
        [doubleTap setNumberOfTapsRequired:2];
        
        UIScrollView *s = [[UIScrollView alloc] initWithFrame:CGRectMake(320*i, 0, 320, 460)];
        s.backgroundColor = [UIColor clearColor];
        s.contentSize = CGSizeMake(320, 460);
        s.delegate = self;
        s.minimumZoomScale = 1.0;
        s.maximumZoomScale = 3.0;
        [s setZoomScale:1.0];
        
        UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64)];
        NSString *imageName = [NSString stringWithFormat:@"ref_%d.png",i+1];
        imageview.image = [UIImage imageNamed:imageName];
        imageview.userInteractionEnabled = YES;
        imageview.tag = i+1;
        [imageview addGestureRecognizer:doubleTap];
        [s addSubview:imageview];
        [MySV addSubview:s];
        
    }
    [self.view addSubview:MySV];
    
    offset = 0.0;
}

- (IBAction)goBackAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - ScrollView delegate
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    
    for (UIView *v in scrollView.subviews){
        return v;
    }
    return nil;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if (scrollView == MySV){
        CGFloat x = scrollView.contentOffset.x;
        if (x==offset){
            
        }
        else {
            offset = x;
            for (UIScrollView *s in scrollView.subviews){
                if ([s isKindOfClass:[UIScrollView class]]){
                    [s setZoomScale:1.0];
                }
            }
        }
    }
}

//- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale {
//    [scrollView setZoomScale:scale+1.0 animated:YES];
//    [scrollView setZoomScale:scale animated:YES];
//}
#pragma mark -
-(void)handleDoubleTap:(UIGestureRecognizer *)gesture{
    
    float newScale = [(UIScrollView*)gesture.view.superview zoomScale] * 1.5;
    CGRect zoomRect = [self zoomRectForScale:newScale  inView:(UIScrollView*)gesture.view.superview withCenter:[gesture locationInView:gesture.view]];
    [(UIScrollView*)gesture.view.superview zoomToRect:zoomRect animated:YES];
}

#pragma mark - Utility methods

- (CGRect)zoomRectForScale:(float)scale inView:(UIScrollView*)scrollView withCenter:(CGPoint)center {
    
    CGRect zoomRect;
    
    zoomRect.size.height = [scrollView frame].size.height / scale;
    zoomRect.size.width  = [scrollView frame].size.width  / scale;
    
    zoomRect.origin.x    = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y    = center.y - (zoomRect.size.height / 2.0);
    
    return zoomRect;
}



//
//-(void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
////    CGPoint offset=scrollView.contentOffset;
////    pageControl.currentPage=offset.x/320.0f;
//    
//}
//-(void)pageTurn:(UIPageControl *)aPageControl
//{
//    MySV.frame=CGRectMake(0, 64,ScreenWidth, ScreenHeight-64);
//    MySV.contentSize=CGSizeMake(2*ScreenWidth, ScreenHeight-64);
//    iv1.frame=CGRectMake(0, 0, ScreenWidth, ScreenHeight-64);
//    iv2.frame=CGRectMake(ScreenWidth, 0, ScreenWidth, ScreenHeight-64);
//   
//    
//    NSInteger whichPage=aPageControl.currentPage;
//    currentPage=whichPage;
//    [UIView beginAnimations:nil context:NULL];
//    [UIView setAnimationDuration:0.3];
//    //[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
//    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view cache:YES];
//    MySV.contentOffset=CGPointMake(320*whichPage, 0);
//    [UIView commitAnimations];
//}
//
//- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view{
//    NSLog(@"aaaa");
//    
//}
//

//
////实现图片的缩放
//-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
//    NSLog(@"**************viewForZoomingInScrollView");
//    if (currentPage==0) {
//        return iv1;
//    }else{
//        return iv2;
//    }
//    
//}
//#pragma mark 当正在缩放的时候调用
////实现图片在缩放过程中居中
//- (void)scrollViewDidZoom:(UIScrollView *)scrollView
//{
////    NSLog(@"scrollView:%f",scrollView.zoomScale*20.0);
////    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?(scrollView.bounds.size.width - scrollView.contentSize.width)/2 : 0.0;
////    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?(scrollView.bounds.size.height - scrollView.contentSize.height)/2 : 0.0;
////    if (currentPage==0) {
////        iv1.center = CGPointMake(scrollView.contentSize.width/2 + offsetX,scrollView.contentSize.height/2 + offsetY);
//////        MySV.contentSize=CGSizeMake(2*iv1.frame.size.width, ScreenHeight-64);
////        iv2.hidden=YES;
////    }else{
////        iv2.center = CGPointMake(scrollView.contentSize.width/2 + offsetX,scrollView.contentSize.height/2 + offsetY);
//////        MySV.contentSize=CGSizeMake(2*iv2.frame.size.width, ScreenHeight-64);
////        iv1.hidden= YES;
//////        CGPointMake(scrollView.contentSize.width/4+ offsetX,scrollView.contentSize.height/2 + offsetY)
////    }
////    
////    if (scrollView.zoomScale==1) {
////        iv1.hidden= NO;
////        iv2.hidden= NO;
////    }
//    
//}
//
//#pragma mark 当缩放完毕的时候调用
//- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale {
//    
//    
//}
@end
