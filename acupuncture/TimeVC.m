//
//  TimeVC.m
//  acupuncture
//
//  Created by 陈双超 on 15/5/14.
//  Copyright (c) 2015年 陈双超. All rights reserved.
//

#import "TimeVC.h"
#define MainScreen [[UIScreen mainScreen] bounds]
#define SCREENWIDTH MainScreen.size.width
#define SCREENHEIGHT MainScreen.size.height

@interface TimeVC (){
    NSInteger TimeInteger;
    NSUserDefaults *MyUserDefault;
    float jiaoduTem;
}
@end

@implementation TimeVC
@synthesize myView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    TimeInteger=1;
    
    myView.opaque=YES;
    myView.userInteractionEnabled=NO;
    myView.backgroundColor=[UIColor clearColor];
    
    myView.transform=CGAffineTransformMakeRotation(3.1415926*90/180);
    
    MyUserDefault=[NSUserDefaults standardUserDefaults];
    TimeInteger=[[[MyUserDefault objectForKey:[MyUserDefault objectForKey:@"peripheralUUIDString"]] objectForKey:@"TimeValue"] integerValue];
    NSLog(@"TimeInteger:%ld",(long)TimeInteger);
    if (TimeInteger==0) {
        TimeInteger=1;
    }
    jiaoduTem=TimeInteger*24;
    _TimeLebel.text=[NSString stringWithFormat:@"%ld",(long)TimeInteger];
    myView.height=jiaoduTem;
    [myView setNeedsDisplay];
    
}

- (IBAction)timeMinusAction:(UIButton *)sender {
    if (TimeInteger>1) {
        TimeInteger--;
        jiaoduTem=jiaoduTem-24;
        myView.height=jiaoduTem;
        [myView setNeedsDisplay];
    }
    _TimeLebel.text=[NSString stringWithFormat:@"%ld",(long)TimeInteger];
}

- (IBAction)timePlusAction:(UIButton *)sender {
    if (TimeInteger!=15) {
        TimeInteger++;
        jiaoduTem=jiaoduTem+24;
        myView.height=jiaoduTem;
        [myView setNeedsDisplay];
    }
    _TimeLebel.text=[NSString stringWithFormat:@"%ld",(long)TimeInteger];
}

- (IBAction)BackAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)TimeSaveAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
    [MyUserDefault setObject:[NSNumber numberWithInteger:TimeInteger] forKey:@"TimeValue"];
    NSDictionary *dic=[[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithInteger:TimeInteger],@"TimeNumber",nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TimeNotification" object:nil userInfo:dic];
}
- (BOOL)touchPointInsideCircle:(CGPoint)center radius:(CGFloat)radius targetPoint:(CGPoint)point
{
    CGFloat dist = sqrtf((point.x - center.x) * (point.x - center.x) +
                         (point.y - center.y) * (point.y - center.y));
    return (dist <= radius);
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{

   
    NSSet *allTouches = [event allTouches];    //返回与当前接收者有关的所有的触摸对象
    UITouch *touch = [allTouches anyObject];   //视图中的所有对象
    CGPoint point = [touch locationInView:[touch view]]; //返回触摸点在视图中的当前坐标
    
    int x = point.x;
    int y = point.y;

    BOOL pointInRound = [self touchPointInsideCircle:self.myView.center radius:100 targetPoint:point];
    if (!pointInRound) {
        
    }else{
        [self touchDraw:x :y];
    }
}
-(void)touchDraw:(int)x :(int)y{
    jiaoduTem=atan((y-SCREENHEIGHT*0.5)*1.0/(x-SCREENWIDTH*0.5))*180.0/3.1415926;
    
    if (x<160) {
        jiaoduTem+=90;
    }else if(x>160){
        jiaoduTem+=270;
    }else if(x==160&&y<SCREENWIDTH*0.5){
        jiaoduTem=180;
    }else if(x==160&&y>SCREENWIDTH*0.5){
        jiaoduTem=0;
    }
    TimeInteger=15*jiaoduTem/360.0+1;
    _TimeLebel.text=[NSString stringWithFormat:@"%ld",(long)TimeInteger];
    myView.height=jiaoduTem;
    [myView setNeedsDisplay];
    
}
-(void)touchDrawEnd:(int)x :(int)y{
    jiaoduTem=atan((y-SCREENHEIGHT*0.5)*1.0/(x-SCREENWIDTH*0.5))*180.0/3.1415926;
    
    if (x<160) {
        jiaoduTem+=90;
    }else if(x>160){
        jiaoduTem+=270;
    }else if(x==160&&y<SCREENWIDTH*0.5){
        jiaoduTem=180;
    }else if(x==160&&y>SCREENWIDTH*0.5){
        jiaoduTem=0;
    }
    float TimeFloat=15*jiaoduTem/360.0;
    TimeInteger=round(TimeFloat);
    if (TimeInteger<1) {
        TimeInteger=1;
    }
    _TimeLebel.text=[NSString stringWithFormat:@"%ld",(long)TimeInteger];
    jiaoduTem=TimeInteger*24;
    myView.height=jiaoduTem;
    [myView setNeedsDisplay];
 
//    NSDictionary *dic=[[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithInteger:TimeInteger],@"TimeNumber",nil];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"StrengthNotification" object:nil userInfo:dic];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    NSSet *allTouches = [event allTouches];    //返回与当前接收者有关的所有的触摸对象
    UITouch *touch = [allTouches anyObject];   //视图中的所有对象
    CGPoint point = [touch locationInView:[touch view]]; //返回触摸点在视图中的当前坐标
    int x = point.x;
    int y = point.y;
    
    BOOL pointInRound = [self touchPointInsideCircle:self.myView.center radius:100 targetPoint:point];
    if (!pointInRound) {
        
    }else{
        [self touchDraw:x :y];
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    NSSet *allTouches = [event allTouches];    //返回与当前接收者有关的所有的触摸对象
    UITouch *touch = [allTouches anyObject];   //视图中的所有对象
    CGPoint point = [touch locationInView:[touch view]]; //返回触摸点在视图中的当前坐标
    int x = point.x;
    int y = point.y;
    
    BOOL pointInRound = [self touchPointInsideCircle:self.myView.center radius:100 targetPoint:point];
    if (!pointInRound) {
        
    }else{
        [self touchDrawEnd:x :y];
    }

}


@end
