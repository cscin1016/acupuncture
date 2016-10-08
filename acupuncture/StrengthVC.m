//
//  StrengthVC.m
//  acupuncture
//
//  Created by 陈双超 on 15/5/15.
//  Copyright (c) 2015年 陈双超. All rights reserved.
//

#import "StrengthVC.h"
#define MainScreen [[UIScreen mainScreen] bounds]
#define SCREENWIDTH MainScreen.size.width
#define SCREENHEIGHT MainScreen.size.height

@interface StrengthVC (){
    NSInteger StrengthNumber;
    NSUserDefaults *MyUserDefault;
}

@end

@implementation StrengthVC
@synthesize myView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    StrengthNumber=1;
    
    myView.opaque=YES;
    myView.userInteractionEnabled=NO;
    myView.backgroundColor=[UIColor clearColor];
    
    myView.transform=CGAffineTransformMakeRotation(3.1415926*90/180);
    
    MyUserDefault=[NSUserDefaults standardUserDefaults];
                 
                 
    StrengthNumber=[[[MyUserDefault objectForKey:[MyUserDefault objectForKey:@"peripheralUUIDString"]] objectForKey:@"StrengthValue"] integerValue];
    if(StrengthNumber==0)StrengthNumber=1;
    float jiaoduTem=StrengthNumber*24;
    _StrengthLabel.text=[NSString stringWithFormat:@"%ld",(long)StrengthNumber];
    myView.height=jiaoduTem;
    [myView setNeedsDisplay];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)jianAction:(UIButton *)sender {
    if (StrengthNumber>1) {
        StrengthNumber--;
        myView.height=StrengthNumber*24.0;
        [myView setNeedsDisplay];
    }
    _StrengthLabel.text=[NSString stringWithFormat:@"%ld",(long)StrengthNumber];
    
    NSDictionary *dic=[[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithInteger:StrengthNumber],@"StrengthNumber",nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"StrengthNotification" object:nil userInfo:dic];
}

- (IBAction)jiaAction:(UIButton *)sender {
    if (StrengthNumber!=15) {
        StrengthNumber++;
        myView.height=StrengthNumber*24.0;
        [myView setNeedsDisplay];
    }
    _StrengthLabel.text=[NSString stringWithFormat:@"%ld",(long)StrengthNumber];
    
    NSDictionary *dic=[[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithInteger:StrengthNumber],@"StrengthNumber",nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"StrengthNotification" object:nil userInfo:dic];
}

- (IBAction)BackAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)StrengthSaveAction:(UIButton *)sender {
    NSDictionary *dic=[[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithInteger:StrengthNumber],@"StrengthNumber",nil];
    
    [MyUserDefault setObject:[NSNumber numberWithInteger:StrengthNumber] forKey:@"StrengthValue"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"StrengthNotification" object:nil userInfo:dic];
    [self.navigationController popViewControllerAnimated:YES];
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
    [self touchDrawEnd:x :y];
}

-(void)touchDraw:(int)x :(int)y{
    float jiaoduTem=atan((y-SCREENHEIGHT*0.5)*1.0/(x-SCREENWIDTH*0.5))*180.0/3.1415926;
    
    if (x<160) {
        jiaoduTem+=90;
    }else if(x>160){
        jiaoduTem+=270;
    }else if(x==160&&y<SCREENWIDTH*0.5){
        jiaoduTem=180;
    }else if(x==160&&y>SCREENWIDTH*0.5){
        jiaoduTem=0;
    }
    
    if(fabs(StrengthNumber-15*jiaoduTem/360.0)<4 ){
        StrengthNumber=15*jiaoduTem/360.0+1;
        _StrengthLabel.text=[NSString stringWithFormat:@"%ld",(long)StrengthNumber];
        myView.height=jiaoduTem;
        [myView setNeedsDisplay];
    }
    
    
}

-(void)touchDrawEnd:(int)x :(int)y{
    float  jiaoduTem=atan((y-SCREENHEIGHT*0.5)*1.0/(x-SCREENWIDTH*0.5))*180.0/3.1415926;
    
    if (x<160) {
        jiaoduTem+=90;
    }else if(x>160){
        jiaoduTem+=270;
    }else if(x==160&&y<SCREENWIDTH*0.5){
        jiaoduTem=180;
    }else if(x==160&&y>SCREENWIDTH*0.5){
        jiaoduTem=0;
    }
//    NSLog(@"jiaoduTem:%f",jiaoduTem);
    
    float TimeFloat=15*jiaoduTem/360.0;
    
    if(fabs(StrengthNumber-15*jiaoduTem/360.0)<4 ){
        StrengthNumber=round(TimeFloat);
        if (StrengthNumber<1) {
            StrengthNumber=1;
        }
        _StrengthLabel.text=[NSString stringWithFormat:@"%ld",(long)StrengthNumber];
    }
    
    myView.height=(int)StrengthNumber*24;
    [myView setNeedsDisplay];
    
    NSDictionary *dic=[[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithInteger:StrengthNumber],@"StrengthNumber",nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"StrengthNotification" object:nil userInfo:dic];
}


- (BOOL)touchPointInsideCircle:(CGPoint)center radius:(CGFloat)radius targetPoint:(CGPoint)point
{
    CGFloat dist = sqrtf((point.x - center.x) * (point.x - center.x) +
                         (point.y - center.y) * (point.y - center.y));
    return (dist <= radius);
}

@end
