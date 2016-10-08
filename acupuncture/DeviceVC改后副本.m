//
//  DeviceVC.m
//  acupuncture
//
//  Created by 陈双超 on 15/5/13.
//  Copyright (c) 2015年 陈双超. All rights reserved.
//

#import "DeviceVC.h"
#import "PopupView.h"
#import "SDImageCache.h"

@interface DeviceVC (){
    NSUserDefaults *MyUserDefault;
    NSMutableArray *DeviceToBle;//设备的对应关系,UUID，头像，名称
    NSMutableDictionary *DeviceSettingDic;//根据UUID对应的单个设备的所有信息
    BOOL ISShowLunbo;//是否有在显示更多view，no表示没有显示。
    bool ISStart;//是否已经开始播放
    
    BOOL ISTestOver;//是否执行体验结束方法，YES就会发送000，NO不会发送
    
    __block int timeout;
    dispatch_queue_t queue;
    dispatch_source_t _timer;
}

@end

@implementation DeviceVC
@synthesize deviceType;
@synthesize peripheralOpration;


- (NSString *) formatTime: (int) num
{
    int secs = num % 60;
    int min = num / 60;
    if (num < 60) return [NSString stringWithFormat:@"0:%02d", num];
    return	[NSString stringWithFormat:@"%d:%02d", min, secs];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    timeout=0;
    MyUserDefault=[NSUserDefaults standardUserDefaults];
    [MyUserDefault setObject:[peripheralOpration.identifier UUIDString] forKey:@"peripheralUUIDString"];
    
    //设备名称，头像对应关系
    DeviceToBle=[[NSMutableArray alloc] initWithArray:[MyUserDefault objectForKey:@"DeviceToBle"]];
    
    //显示标题
    NSMutableDictionary *MyDic=[DeviceToBle objectAtIndex:[deviceType integerValue]];
    if([MyDic objectForKey:@"name"]){
        [_TitleButton setTitle:[NSString stringWithFormat:@"%@🔽",[MyDic objectForKey:@"name"]] forState:UIControlStateNormal];
    }else{
        [_TitleButton setTitle:[NSString  stringWithFormat:@"%@🔽",NSLocalizedStringFromTable(@"Device", @"Localizable", nil) ] forState:UIControlStateNormal];
    }
    
    //显示头像
    if([MyDic objectForKey:@"image"]){
        UIImage *myCachedImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:[MyDic objectForKey:@"image"]];
        if (myCachedImage) {
            [_SetButton setImage:myCachedImage forState:UIControlStateNormal];
        }
    }
    
    
    //这个UUID对应的设备设置：模式，强度，时间，显示到界面
    DeviceSettingDic=[[NSMutableDictionary alloc]initWithDictionary:[MyUserDefault objectForKey:[peripheralOpration.identifier UUIDString]]];
    NSInteger modeNumber=[[DeviceSettingDic objectForKey:@"ModeValue"] integerValue];
    switch (modeNumber) {
        case 0:
            [_CenterButton setBackgroundImage:[UIImage imageNamed:@"dev_mode1.png"] forState:UIControlStateNormal];
            break;
        case 1:
            [_CenterButton setBackgroundImage:[UIImage imageNamed:@"dev_mode2.png"] forState:UIControlStateNormal];
            break;
        case 2:
            [_CenterButton setBackgroundImage:[UIImage imageNamed:@"dev_mode3.png"] forState:UIControlStateNormal];
            break;
        case 3:
            [_CenterButton setBackgroundImage:[UIImage imageNamed:@"dev_mode4.png"] forState:UIControlStateNormal];
            break;
        default:
            break;
    }
    
    
    //蓝牙中心
    self.cbCentralMgr = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).cbCentralMgr;
    
    
    //三个通知
    [[NSNotificationCenter defaultCenter] addObserver: self selector:@selector(SetModeAction:) name:@"ModeNotification" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver: self selector:@selector(SetTimeAction:) name:@"TimeNotification" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver: self selector:@selector(SetStrengthAction:) name:@"StrengthNotification" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver: self selector:@selector(ElectricAction:) name:@"ElectricValueNotification" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver: self selector:@selector(SendCustomDataAction:) name:@"SendCustomDataNotification" object:nil];
    
    //中间针灸动画
    NSArray *hopAnimation=[[NSArray alloc] initWithObjects:
                           [UIImage imageNamed:@"progress8.png"],
                           [UIImage imageNamed:@"progress7.png"],
                           [UIImage imageNamed:@"progress6.png"],
                           [UIImage imageNamed:@"progress5.png"],
                           [UIImage imageNamed:@"progress4.png"],
                           [UIImage imageNamed:@"progress3.png"],
                           [UIImage imageNamed:@"progress2.png"],
                           [UIImage imageNamed:@"progress1.png"],nil];
    _RotationImageView.animationImages=hopAnimation;
    _RotationImageView.animationDuration=1;
    
    
    ISShowLunbo=NO;
    ISStart=NO;
    
    
}
#pragma - mark 通知响应方法
//收到来自模式改变的通知
-(void)SetModeAction:(NSNotification*) notification{
    //第一步，改变设置中的值
    NSInteger modeNumber=[[[notification userInfo] objectForKey:@"ModeNumber"] integerValue];
    [DeviceSettingDic setObject:[NSNumber numberWithInteger:modeNumber] forKey:@"ModeValue"];
    [MyUserDefault setObject:DeviceSettingDic forKey:[peripheralOpration.identifier UUIDString]];
    //第二步，改变界面
    switch (modeNumber) {
        case 0:
            [_CenterButton setBackgroundImage:[UIImage imageNamed:@"dev_mode1.png"] forState:UIControlStateNormal];
            break;
        case 1:
            [_CenterButton setBackgroundImage:[UIImage imageNamed:@"dev_mode2.png"] forState:UIControlStateNormal];
            break;
        case 2:
            [_CenterButton setBackgroundImage:[UIImage imageNamed:@"dev_mode3.png"] forState:UIControlStateNormal];
            break;
        case 3:
            [_CenterButton setBackgroundImage:[UIImage imageNamed:@"dev_mode4.png"] forState:UIControlStateNormal];
            break;
        default:
            break;
    }
}

//收到来自时间改变的通知
-(void)SetTimeAction:(NSNotification*) notification{
    NSInteger timeNumber=[[[notification userInfo] objectForKey:@"TimeNumber"] integerValue];
    [DeviceSettingDic setObject:[NSNumber numberWithInteger:timeNumber] forKey:@"TimeValue"];
    
    [DeviceSettingDic setObject:[NSNumber numberWithBool:YES] forKey:@"ISRESETTIME"];
    
    [MyUserDefault setObject:DeviceSettingDic forKey:[peripheralOpration.identifier UUIDString]];
    
}

//收到来自强度改变的通知
-(void)SetStrengthAction:(NSNotification*) notification{
    NSInteger StrengthNumber=[[[notification userInfo] objectForKey:@"StrengthNumber"] integerValue];
    [DeviceSettingDic setObject:[NSNumber numberWithInteger:StrengthNumber] forKey:@"StrengthValue"];
    [MyUserDefault setObject:DeviceSettingDic forKey:[peripheralOpration.identifier UUIDString]];
    
    //发送数据
    NSInteger ModeValue=[[DeviceSettingDic objectForKey:@"ModeValue"] integerValue];
    
    NSData *cmdData;
    if (ModeValue==3) {//如果是自定义模式，取出自定义模式要发送的数据格式MyCustomData，取出自定义模式的总时间
        cmdData=[DeviceSettingDic objectForKey:@"MyCustomData"];
    }else{
        int TimeValue=[[DeviceSettingDic objectForKey:@"TimeValue"] intValue];
        NSInteger StrengthValue=[[DeviceSettingDic objectForKey:@"StrengthValue"] integerValue];
        
        if (TimeValue<1) {
            TimeValue=1;
        }
        if (StrengthValue<1) {
            StrengthValue=1;
        }
        char strcommand[3]={ModeValue,TimeValue,StrengthValue};
        cmdData = [NSData dataWithBytes:strcommand length:3];
        
    }
    
    for(int i=0;i<peripheralOpration.services.count;i++){
        for (CBCharacteristic *characteristic in [[peripheralOpration.services objectAtIndex:i] characteristics])
        {
            if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:TRANSFER_CHARACTERISTIC_UUID_2B01]])
            {
                [peripheralOpration writeValue:cmdData forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
                NSLog(@"收到来自强度改变的通知cmdData:%@",cmdData);
            }
        }
    }
    
    
    if (!ISStart) {//未开始，进入20秒体验模式，20秒之后关闭
        dispatch_time_t time=dispatch_time(DISPATCH_TIME_NOW, 20*NSEC_PER_SEC);
        dispatch_after(time, dispatch_get_main_queue(), ^{
            NSLog(@"SetStrengthAction stop!");
            if (!ISStart) {
                [self pauseAction];
            }
        });
    }else{//已经开始，发送数据到针灸仪，在界面显示结束时，关闭
        
    }
}
-(void)sendBLEData{
    NSInteger ModeValue=[[DeviceSettingDic objectForKey:@"ModeValue"] integerValue];
    
    NSData *cmdData;
    if (ModeValue==3) {//如果是自定义模式，取出自定义模式要发送的数据格式MyCustomData，取出自定义模式的总时间
        cmdData=[DeviceSettingDic objectForKey:@"MyCustomData"];
        timeout=[[DeviceSettingDic objectForKey:@"MyCustomAllTime"] intValue]*60; //倒计时时间
        NSLog(@"自定义时间:%d",timeout);
    }else{
        int TimeValue=[[DeviceSettingDic objectForKey:@"TimeValue"] intValue];
        NSInteger StrengthValue=[[DeviceSettingDic objectForKey:@"StrengthValue"] integerValue];
        
        if (TimeValue<1) {
            TimeValue=1;
        }
        if (StrengthValue<1) {
            StrengthValue=1;
        }
        char strcommand[3]={ModeValue,TimeValue,StrengthValue};
        cmdData = [NSData dataWithBytes:strcommand length:3];
        
        NSLog(@"TimeValue时间:%ld",(long)TimeValue);
        timeout=TimeValue*60;
    }
    
    NSDate *localDate=[NSDate date];
    NSTimeInterval secondsEnd = timeout;
    NSDate *endTime = [NSDate  dateWithTimeInterval:secondsEnd sinceDate:localDate];
    [DeviceSettingDic setObject:endTime forKey:@"DateEnd"];
    [MyUserDefault setObject:DeviceSettingDic forKey:[peripheralOpration.identifier UUIDString]];
    [self remaindTimeAction:timeout];
    
    for(int i=0;i<peripheralOpration.services.count;i++){
        for (CBCharacteristic *characteristic in [[peripheralOpration.services objectAtIndex:i] characteristics])
        {
            if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:TRANSFER_CHARACTERISTIC_UUID_2B01]])
            {
                [peripheralOpration writeValue:cmdData forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
                NSLog(@"cmdData:%@",cmdData);
            }
        }
    }
}
-(void)ElectricAction:(NSNotification*) notification{
    NSString *MyElecticStr=[NSString stringWithFormat:@"%@",[[notification userInfo] objectForKey:@"ElectricNumber"]] ;
    if (MyElecticStr.length>3) {
        int ElecticNumber=[self TotexHex:[MyElecticStr substringWithRange:NSMakeRange(1, 2)]];
        _ElectricLabel.text=[NSString stringWithFormat:@"%d%%",ElecticNumber];
        if (ElecticNumber>80) {
            [_ElectricImage setImage:[UIImage imageNamed:@"battery_lvl3"]];
        }else if (ElecticNumber>60){
            [_ElectricImage setImage:[UIImage imageNamed:@"battery_lvl2"]];
        }else if (ElecticNumber>40){
            [_ElectricImage setImage:[UIImage imageNamed:@"battery_lvl1"]];
        }else if (ElecticNumber>20){
            [_ElectricImage setImage:[UIImage imageNamed:@"battery_lvl0"]];
        }else{
            [_ElectricImage setImage:[UIImage imageNamed:@"battery_lvln"]];
        }
    }
}

-(void)SendCustomDataAction:(NSNotification*) notification{
    [DeviceSettingDic setObject:[[notification userInfo] objectForKey:@"tempData"] forKey:@"MyCustomData"];
    [DeviceSettingDic setObject:[[notification userInfo] objectForKey:@"allTime"]  forKey:@"MyCustomAllTime"];
    [DeviceSettingDic setObject:[NSNumber numberWithBool:YES] forKey:@"ISRESETTIME"];
    [MyUserDefault setObject:DeviceSettingDic forKey:[peripheralOpration.identifier UUIDString]];
}

#pragma - mark
-(void)stopAction{
    char strcommand[3]={0,0,0};
    NSData *cmdData = [NSData dataWithBytes:strcommand length:3];
    NSLog(@"暂停/停止:%@",cmdData);
    for(int i=0;i<peripheralOpration.services.count;i++){
        for (CBCharacteristic *characteristic in [[peripheralOpration.services objectAtIndex:i] characteristics])
        {
            if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:TRANSFER_CHARACTERISTIC_UUID_2B01]])
            {
                [peripheralOpration writeValue:cmdData forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
            }
        }
    }
}
-(void)pauseAction{
    
    [_CenterButton setImage:[UIImage imageNamed:@"dev_progress_start.png"] forState:UIControlStateNormal];
    [_RotationImageView stopAnimating];
    
    if (_timer!=nil) {
        NSLog(@"pauseAction");
        dispatch_source_cancel(_timer);
        _RemainTimeLabel.text=@"0:00";
    }
    
    [self stopAction];
}

-(void)viewWillDisappear:(BOOL)animated{
    
    
}

-(void)viewDidAppear:(BOOL)animated{
    ISShowLunbo=NO;
    _MyMoreView.hidden=YES;
    if(peripheralOpration.state!=2){
        PopupView  *popUpView= [[PopupView alloc]initWithFrame:CGRectMake(100, 240, 0, 0)];
        popUpView.ParentView = self.view;
        [popUpView setText: NSLocalizedStringFromTable(@"Equipment_Disconnected", @"Localizable", nil)];
        [self.view addSubview:popUpView];
        
        return;
    }
    for(int i=0;i<peripheralOpration.services.count;i++){
        for (CBCharacteristic *characteristic in [[peripheralOpration.services objectAtIndex:i] characteristics])
        {
            if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:TRANSFER_CHARACTERISTIC_UUID_F202]])
            {
                [peripheralOpration readValueForCharacteristic:characteristic];
            }
        }
    }
    
    NSDate *localDate=[NSDate date];
    NSDate *endDate= [DeviceSettingDic objectForKey:@"DateEnd"];
    long difference =[endDate timeIntervalSinceDate:localDate];
    if(difference>0){
        ISStart=YES;
        [_CenterButton setImage:[UIImage imageNamed:@"dev_progress_pause.png"] forState:UIControlStateNormal];
        [_RotationImageView startAnimating];
        [self remaindTimeAction:(int)difference];
    }else{
        ISStart=NO;
        [_CenterButton setImage:[UIImage imageNamed:@"dev_progress_start.png"] forState:UIControlStateNormal];
        [_RotationImageView stopAnimating];
        _RemainTimeLabel.text=@"0:00";
        NSLog(@"viewDidAppear");
        if (_timer!=nil) {
            dispatch_source_cancel(_timer);
        }
    }
}

-(void)remaindTimeAction:(int)timeNumber{
    timeout=timeNumber; //倒计时时间
    
    NSLog(@"timeout:%d",timeout);
    
    if (_timer!=nil) {
        NSLog(@"quxiao");
        dispatch_source_cancel(_timer);
    }
    
    
    
    queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                NSLog(@"结束");
                [_CenterButton setImage:[UIImage imageNamed:@"dev_progress_start.png"] forState:UIControlStateNormal];
                [_RotationImageView stopAnimating];
                _RemainTimeLabel.text=@"0:00";
                [self stopAction];
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"刷新");
                //设置界面的按钮显示 根据自己需求设置
                _RemainTimeLabel.text=[self formatTime:timeout];
                timeout--;
            });
            
        }
    });
    dispatch_resume(_timer);
}

- (IBAction)StartOrPause:(UIButton *)sender {
    //隐藏右上角跳转到about和轮播的界面
    ISShowLunbo=NO;
    _MyMoreView.hidden=YES;
    
    if (_RotationImageView.isAnimating) {
        NSDate *localDate=[NSDate date];
        NSDate *endTimeDate=[DeviceSettingDic objectForKey:@"DateEnd"];
        NSLog(@"剩下时间:%f",[endTimeDate timeIntervalSinceDate:localDate]);
        NSInteger leftTime=(NSInteger)[endTimeDate timeIntervalSinceDate:localDate];
        [DeviceSettingDic setObject:[NSNumber numberWithInteger:leftTime] forKey:@"PAUSELEFTTIME"];
        [DeviceSettingDic setObject:[NSNumber numberWithBool:YES] forKey:@"ISPAUSE"];
        
        NSTimeInterval secondsEnd = -3600*3;
        NSDate *endTime = [NSDate  dateWithTimeInterval:secondsEnd sinceDate:localDate];
        [DeviceSettingDic setObject:endTime forKey:@"DateEnd"];
        
        [MyUserDefault setObject:DeviceSettingDic forKey:[peripheralOpration.identifier UUIDString]];
        
        ISStart=NO;
        [self pauseAction];
    }else{
        ISStart=YES;
        if (peripheralOpration.state==2) {
            [_CenterButton setImage:[UIImage imageNamed:@"dev_progress_pause.png"] forState:UIControlStateNormal];
            [_RotationImageView startAnimating];
            [self sendBLEData];
        }else{
            PopupView  *popUpView= [[PopupView alloc]initWithFrame:CGRectMake(100, 240, 0, 0)];
            popUpView.ParentView = self.view;
            [popUpView setText:NSLocalizedStringFromTable(@"Equipment_Disconnected", @"Localizable", nil)];
            [self.view addSubview:popUpView];
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSString *str=[alertView textFieldAtIndex:0].text;
    NSLog(@"%ld,%@",(long)buttonIndex,str);
    if (str.length) {
        NSMutableDictionary *MyDic=[[NSMutableDictionary alloc]initWithDictionary:[DeviceToBle objectAtIndex:[deviceType integerValue]]];
        [MyDic setObject:str forKey:@"name"];
        [DeviceToBle replaceObjectAtIndex:[deviceType integerValue] withObject:MyDic];
        [MyUserDefault setObject:DeviceToBle forKey:@"DeviceToBle"];
        [_TitleButton setTitle:[NSString stringWithFormat:@"%@🔽",str] forState:UIControlStateNormal];
    }
}

- (IBAction)ChangeNameAction:(id)sender {
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NSLocalizedStringFromTable(@"Modify_Device_Name", @"Localizable", nil) message:nil delegate:self cancelButtonTitle:NSLocalizedStringFromTable(@"Cancel", @"Localizable", nil) otherButtonTitles:NSLocalizedStringFromTable(@"OK", @"Localizable", nil), nil];
    alert.alertViewStyle=UIAlertViewStylePlainTextInput;
    [alert show];
}

- (IBAction)goBackAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)SetButtonAction:(id)sender {
    ISShowLunbo=NO;
    _MyMoreView.hidden=YES;
    
    //相册是可以用模拟器打开的
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        
        UIActionSheet *myActionSheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedStringFromTable(@"Cancel", @"Localizable", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedStringFromTable(@"take_photo", @"Localizable", nil),NSLocalizedStringFromTable(@"Open_photo_album", @"Localizable", nil), nil];
        [myActionSheet showInView:self.view];
        
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"您没有摄像头资源!" delegate:nil cancelButtonTitle:@"Drat!" otherButtonTitles:nil];
        [alert show];
    }
}
#pragma - mark delegate methods
//选择完成之后
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
    [self dismissModalViewControllerAnimated:YES];
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error
  contextInfo:(void *)contextInfo {
    
}

//用户点击图像选取器中的“cancel”按钮时被调用，这说明用户想要中止选取图像的操作
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void) imagePickerController: (UIImagePickerController *) picker didFinishPickingMediaWithInfo: (NSDictionary *) info
{
    
//    UIImage *originalImage = (UIImage *) [info objectForKey: UIImagePickerControllerOriginalImage];//得到照片
    UIImage *editedImage = (UIImage *) [info objectForKey:UIImagePickerControllerEditedImage];//编辑的照片
//    UIImageWriteToSavedPhotosAlbum(originalImage, nil, nil, nil);//图片存入相册
    
    [_SetButton setImage:editedImage forState:UIControlStateNormal];
    
    NSString *myImageKey=[NSString stringWithFormat:@"deviceImage%@",deviceType];
    NSMutableDictionary *MyDic=[[NSMutableDictionary alloc]initWithDictionary:[DeviceToBle objectAtIndex:[deviceType integerValue]]];
    [MyDic setObject:myImageKey forKey:@"image"];
    [DeviceToBle replaceObjectAtIndex:[deviceType integerValue] withObject:MyDic];
    [MyUserDefault setObject:DeviceToBle forKey:@"DeviceToBle"];
    [[SDImageCache sharedImageCache] storeImage:editedImage forKey:myImageKey];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        _MyImagePicker = [[UIImagePickerController alloc] init];//实例化图片选择器
        _MyImagePicker.delegate = self; //实现委托，委托必须实现UIImagePickerControllerDelegate协议，来对用户在图片选取器中的动作
        _MyImagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        _MyImagePicker.allowsEditing=YES;//在选定图片之前，用户可以简单编辑要选的图片。包括上下移动改变图片的选取范围，用手捏合动作改变图片的大小等。
        [self presentViewController:_MyImagePicker animated:YES completion:nil];//设置完iamgePicker后，就可以启动了。用以下方法将图像选取器的视图“推”出来
    }else if (buttonIndex==1){
        _MyImagePicker = [[UIImagePickerController alloc]init];
        _MyImagePicker.delegate = self;
        _MyImagePicker.allowsEditing = YES;//是否可以编辑
        //打开相册选择照片
        _MyImagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        [self presentViewController:_MyImagePicker animated:YES completion:nil];
    }
}
-(void)DidCancelAction{
    
    [_MyImagePicker dismissViewControllerAnimated:YES completion:nil];
}
#pragma - mark Other methods

- (IBAction)ShowLunBoAction:(UIButton *)sender {
    
    ISShowLunbo=!ISShowLunbo;
    if(ISShowLunbo){
        _MyMoreView.hidden=NO;
    }else{
        _MyMoreView.hidden=YES;
    }
}
//十六进制数转十进制数
-(int)TotexHex:(NSString*)tmpid
{
    int int_ch;  ///两位16进制数转化后的10进制数
    unichar hex_char2 = [tmpid characterAtIndex:0]; ///两位16进制数中的第二位(低位)
    int int_ch2;
    if(hex_char2 >= '0' && hex_char2 <='9')
        int_ch2 = (hex_char2-48)*16; //// 0 的Ascll - 48
    else if(hex_char2 >= 'A' && hex_char2 <='F')
        int_ch2 = (hex_char2-55)*16; //// A 的Ascll - 65
    else
        int_ch2 = (hex_char2-87)*16; //// a 的Ascll - 97
    
    unichar hex_char3 = [tmpid characterAtIndex:1]; ///两位16进制数中的第二位(低位)
    int int_ch3;
    if(hex_char3 >= '0' && hex_char3 <='9')
        int_ch3 = (hex_char3-48); //// 0 的Ascll - 48
    else if(hex_char3 >= 'A' && hex_char3 <='F')
        int_ch3 = (hex_char3-55); //// A 的Ascll - 65
    else
        int_ch3 = (hex_char3-87); //// a 的Ascll - 97
    
    int_ch = int_ch2 +int_ch3;
    
    return int_ch;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    ISShowLunbo=NO;
    _MyMoreView.hidden=YES;
}

@end
