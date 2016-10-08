//
//  tb_2_graphic.m
//  xiangmu_1
//
//  Created by liu xiaotao008 on 12-3-14.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "draw_graphic.h"
#define  radius 83
#define  radiusWithLineWidth 100

@implementation draw_graphic
@synthesize height,red,green,blue;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    height=0;
    return self;
}

//当调用setNeedsDisplay时由系统调用
-(void)drawRect:(CGRect)rect
{
    //CG绘制三角形
    CGContextRef ctx=UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(ctx, 34.0);//设置当前画笔粗细
//    CGContextSetRGBStrokeColor(ctx, 1.0, 1.0, 1.0, 1.0);//设置当前笔头颜色
    CGContextBeginPath(ctx);
//    CGContextMoveToPoint(ctx, radius+radius, radiusWithLineWidth);
    CGContextAddArc(ctx, radiusWithLineWidth, radiusWithLineWidth, radius,  0,3.1415926*height/180, 0);
//    CGContextAddLineToPoint(ctx,radius, radius);
    //    CGContextStrokePath(ctx);
//    CGContextClosePath(ctx);
//    [[UIColor colorWithRed:92/255.0 green:177/255.0 blue:246/255.0 alpha:1] setFill];
    [[UIColor redColor] setStroke];//设置边框颜色
//    CGContextDrawPath(ctx, kCGPathFill);
    CGContextStrokePath(ctx);
}

-(void)drawRect22:(CGRect)rect
{
    
    //CG绘制三角形
    CGContextRef ctx=UIGraphicsGetCurrentContext();
    CGContextBeginPath(ctx);
    CGContextMoveToPoint(ctx, radius+radius, radius);
    CGContextAddArc(ctx, radius, radius, radius,  0,3.1415926*height/180, 0);
    CGContextAddLineToPoint(ctx,radius, radius);
    //    CGContextStrokePath(ctx);
    CGContextClosePath(ctx);
    [[UIColor colorWithRed:92/255.0 green:177/255.0 blue:246/255.0 alpha:1] setFill];
    [[UIColor clearColor] setStroke];//设置边框颜色
    CGContextDrawPath(ctx, kCGPathFillStroke);
    
}
@end
