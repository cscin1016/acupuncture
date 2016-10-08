//
//  CustomSlideView.m
//  acupuncture
//
//  Created by 陈双超 on 15/7/31.
//  Copyright (c) 2015年 陈双超. All rights reserved.
//

#import "CustomSlideView.h"

@implementation CustomSlideView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    //刻度图片
    UIImageView *strengImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 14, 220, 39)];
    [strengImage setImage:[UIImage imageNamed:@"linenum.png"]];
    [self addSubview:strengImage];
    
    //刻标图片
    Headerphoto = [[UIImageView alloc]initWithFrame:CGRectMake(0, 14, 20, 20)];
    Headerphoto.image = [UIImage imageNamed:@"scrolbtn.png"];
    [self addSubview:Headerphoto];
    
    [self setNumber:time];
}

-(void)setNumber:(int)i{
    time=i;
    if (i<1) {
        i=1;
    }
//    if (i==15) {
//        Headerphoto.center=CGPointMake(i*15, Headerphoto.center.y);
//        return;
//    }
    Headerphoto.center=CGPointMake(i*15-15, Headerphoto.center.y);
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    CGPoint touched=[[[touches allObjects] objectAtIndex:0] locationInView:self];
    [self tochAction:touched event:0];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    CGPoint touched=[[[touches allObjects] objectAtIndex:0] locationInView:self];
    [self tochAction:touched event:1];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    CGPoint touched=[[[touches allObjects] objectAtIndex:0] locationInView:self];
    [self tochAction:touched event:2];
}

-(void)tochAction:(CGPoint)touched event:(int)status{
    
    CGRect mCenterRect=CGRectMake(Headerphoto.frame.origin.x-20, 0, 60, Headerphoto.frame.size.height+40);
    
    if (CGRectContainsPoint (mCenterRect, touched)) {
        if (status==0) {//touchesBegan
            isContain=YES;
        }
    }
    
    if (status==1&&isContain&&touched.x>0&&touched.x<220) {//touchesMoved
        Headerphoto.center=CGPointMake(touched.x, Headerphoto.center.y);
    }

    if (status==2&&isContain){//touchesEnded
        if(touched.x<=14){
            [self.SlideDelegate UpdateStrengthSlide:1 fromView:self];
        }else if (touched.x>=220){
            [self.SlideDelegate UpdateStrengthSlide:15 fromView:self];
        }else{
            int resultNumber=(touched.x)/200*15+1;
            NSLog(@"resultNumber:%d",resultNumber);
            [self.SlideDelegate UpdateStrengthSlide:resultNumber fromView:self];
        }
        isContain=NO;
    }
}
@end
