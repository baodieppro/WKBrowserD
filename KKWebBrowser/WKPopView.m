//
//  WKPopView.m
//  WKBrowser
//
//  Created by 李加建 on 2017/11/7.
//  Copyright © 2017年 jack. All rights reserved.
//

#import "WKPopView.h"

#import "IconButton.h"

#import "LogViewController.h"

#import "InfoViewController.h"

#import "WKYeLayerView.h"

@interface WKPopView ()

@property (nonatomic ,strong)UIView *customView;

@property (nonatomic ,strong)NSMutableArray *btnsArray;

@property (nonatomic ,copy)PopSelTag popSelBlock;



@property (nonatomic ,strong)UILabel * name;
@property (nonatomic ,strong)UIImageView *img;

@property (nonatomic ,strong)WeatherBtn *weatherBtn;

@property (nonatomic ,strong)UIButton *locationBtn;

@property (nonatomic ,assign)BOOL isWeb;

@end


@implementation WKPopView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


+ (void)showInView:(UIView*)view  success:(PopSelTag)success {
    
    WKPopView * popView = [[WKPopView alloc]initWithFrame:CGRectMake(0, 0, SCREEM_WIDTH, SCREEM_HEIGHT)];
    popView.popSelBlock  = success;
    
    [view addSubview:popView];
    
    [popView show];
}


+ (void)showInView:(UIView*)view  isWeb:(BOOL)isweb success:(PopSelTag)success {
    
    WKPopView * popView = [[WKPopView alloc]initWithFrame:CGRectMake(0, 0, SCREEM_WIDTH, SCREEM_HEIGHT)];
    popView.popSelBlock  = success;
    popView.isWeb = isweb;

    [popView creatView];
    
    [view addSubview:popView];
    
    [popView show];
    
}



- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
//    [self creatView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(weatherUpdate) name:@"weatherupdate" object:nil];
    
    return self;
}


- (void)weatherUpdate {
    
    WeatherModel * model = [WeatherModel currentWeather];
    
    _weatherBtn.model = model;
    
}


- (void)bgTapAction {
    
    [self hide];
}


- (void)weatherBtnAction {
    
    if(_popSelBlock != nil){
        
        _popSelBlock(10);
    }
    
    [self hide];
}


- (void)locationBtnAction {
    
    if(_popSelBlock != nil){
        
        _popSelBlock(11);
    }
    
}


- (void)creatView {
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEM_WIDTH, SCREEM_HEIGHT)];
    bgView.backgroundColor = RGBA(0, 0, 0, 0.75);
    [self addSubview:bgView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(bgTapAction)];
    
    [bgView addGestureRecognizer:tap];
    
    
    _weatherBtn = [[WeatherBtn alloc]initWithFrame:CGRectMake(0, 80, SCREEM_WIDTH/2, 50)];
    
    _weatherBtn.hidden = YES;
    [self addSubview:_weatherBtn];
    
    WeatherModel * model = [WeatherModel currentWeather];

    _weatherBtn.model = model ;
    
    [_weatherBtn addTarget:self action:@selector(weatherBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEM_WIDTH - 100, 80, 100, 50)];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitle:@"使用定位" forState:UIControlStateNormal];
    btn.titleLabel.font = FONT(14);
    [self addSubview:btn];
    
    [btn addTarget:self action:@selector(locationBtnAction) forControlEvents:UIControlEventTouchUpInside];
    btn.hidden = YES;
    self.locationBtn = btn;
    
    
    CGFloat w = SCREEM_WIDTH/2;
    
    _customView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEM_HEIGHT, SCREEM_WIDTH - 0, w + 100)];
    
    _customView.backgroundColor = RGB(250, 250, 250);
    [self addSubview:_customView];
    
//    _customView.layer.masksToBounds = YES;
//    _customView.layer.cornerRadius = 10;
    _customView.clipsToBounds = NO;
    
    [self addCustomView];
    
    
    
    UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(20, 15, 40, 40)];
    img.backgroundColor = [UIColor whiteColor];
    img.layer.masksToBounds = YES;
    img.layer.cornerRadius = img.height/2;
    img.contentMode = UIViewContentModeScaleAspectFill;
    img.clipsToBounds = YES;
    [_customView addSubview:img];
    img.image = [UIImage imageNamed:@"avatar"];
    img.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(btnAction)];
    
    [img addGestureRecognizer:tap2];
    
    
    UILabel *name = [[UILabel alloc]initWithFrame:CGRectMake(70, 15, SCREEM_WIDTH - 140, 40)];
    name.textColor = RGB(50, 50, 50);
    name.text = @"立即登录";
    name.font = FONT(14);
    [_customView addSubview:name];
    
    AVUser * user = [AVUser currentUser];
    
    if(user != nil){
        
        name.text = [user objectForKey:@"name"];;
        
        AVFile *file = [user objectForKey:@"avatar"];
        
        [img sd_setImageWithURL:[NSURL URLWithString:file.url]];
        
    }
    
}


- (void)btnAction {
    
    NSLog(@"info");
    
    [self removeFromSuperview];
    
    AVUser * user = [AVUser currentUser];
    
    if(user == nil){
        
        UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:[[LogViewController alloc]init]];
        
        
        UIViewController * root = [UIApplication sharedApplication].keyWindow.rootViewController;
        [root presentViewController:navi animated:YES completion:nil];
        
        return;
    }
    else {
        
        UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:[[InfoViewController alloc]init]];
        
        
        UIViewController * root = [UIApplication sharedApplication].keyWindow.rootViewController;
        [root presentViewController:navi animated:YES completion:nil];
    }
    
}



- (void)addCustomView {
    
    NSArray *array = @[@"历史记录",@"收藏列表",@"复制链接",@"分享",@"添加收藏",@"无痕模式",@"夜间模式",@"设置"];
    
    _btnsArray = [NSMutableArray array];
    
    CGFloat w = _customView.width/4;
    
    for(int i=0;i<array.count;i++){
        
        
        IconButton *btn = [[IconButton alloc]initWithFrame:CGRectMake(w * (i%4), 60+w*(i/4), w, w)];
        
        [_customView addSubview:btn];
        
        [btn setTitle:array[i] forState:UIControlStateNormal];
        
        NSString *imgName = [NSString stringWithFormat:@"pop_btn_00%@",@(i+1)];
        
        [btn setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
        
        NSString *imgSelName = [NSString stringWithFormat:@"pop_btn_%@",@(i+1)];
        
        [btn setImage:[UIImage imageNamed:imgSelName] forState:UIControlStateSelected];
        
        [btn setTitleColor:RGB(50, 50, 50) forState:UIControlStateNormal];
        
        btn.titleLabel.font = FONT(12);
        
        if(i == 2 || i == 3 || i == 4){
            
            [btn setTitleColor:RGB(205, 205, 205) forState:UIControlStateSelected];
        }
        else {
            [btn setTitleColor:MAINCOLOR forState:UIControlStateSelected];
        }
        
        [btn setImageRect:CGRectMake(btn.width/2 - 12, btn.height/2 - 25, 24, 24)];
     
        [btn setTitleRect:CGRectMake(0, btn.height/2 + 5, btn.width, 20)];
        
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [_btnsArray addObject:btn];
    }
    
    
#pragma mark 判断无痕
    BOOL isRecord = [[NSUserDefaults standardUserDefaults] boolForKey:@"wuheng"];
    
    IconButton *btn5 = _btnsArray[5];
    btn5.selected = isRecord;
    
#pragma mark 判断夜间模式
    
    BOOL isYe = [[NSUserDefaults standardUserDefaults] boolForKey:@"yejian"];
    
    IconButton *btn6 = _btnsArray[6];
    btn6.selected = isYe;

    
#pragma mark 判断是否可以点击
    
    IconButton *btn2 = _btnsArray[2];
    btn2.selected = !_isWeb;
    IconButton *btn3 = _btnsArray[3];
    btn3.selected = !_isWeb;
    IconButton *btn4 = _btnsArray[4];
    btn4.selected = !_isWeb;
    
    btn2.userInteractionEnabled = _isWeb;
    btn3.userInteractionEnabled = _isWeb;
    btn4.userInteractionEnabled = _isWeb;
   
}


- (void)btnAction:(IconButton*)btn {
    
    NSInteger index = [_btnsArray indexOfObject:btn];
    
    if(index == 5){
        
        BOOL isRecord = [[NSUserDefaults standardUserDefaults] boolForKey:@"wuheng"];
        
        isRecord = !isRecord;
        
        [[NSUserDefaults standardUserDefaults] setBool:isRecord forKey:@"wuheng"];
        
        btn.selected = isRecord;
    }
    else if (index == 6){
        
        BOOL isRecord = [[NSUserDefaults standardUserDefaults] boolForKey:@"yejian"];
        
        isRecord = !isRecord;
        
        [[NSUserDefaults standardUserDefaults] setBool:isRecord forKey:@"yejian"];
        
        btn.selected = isRecord;
        
        [WKYeLayerView shareInstance];
    }
    
    
    
    
    if(_popSelBlock != nil){
        
        _popSelBlock(index);
    }
    
    [self hide];
}



- (void)show {
    
    [UIView animateWithDuration:0.3 animations:^{
        
        _customView.frame = CGRectMake(_customView.left, SCREEM_HEIGHT - _customView.height, _customView.width, _customView.height - 0);
    } completion:^(BOOL finished) {
        
        _weatherBtn.hidden = NO;
        _locationBtn.hidden = NO;
    }];
    
}

- (void)hide {
    
    _weatherBtn.hidden = YES;
    _locationBtn.hidden = YES;
    
    [UIView animateWithDuration:0.3 animations:^{
        
        _customView.frame = CGRectMake(_customView.left, SCREEM_HEIGHT, _customView.width, _customView.height + 0);
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
    }];
}


- (void)removeFromSuperview {
    
    [super removeFromSuperview];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
