//
//  ViewController.m
//  Lottery
//
//  Created by dongway on 14-8-13.
//  Copyright (c) 2014年 martin. All rights reserved.
//

#import "ViewController.h"
#import "InternetRequest.h"

#define Red [UIColor redColor]
#define Green [UIColor greenColor]

@interface ViewController ()
{
    __weak IBOutlet UIView *view1;
    __weak IBOutlet UIView *view2;
    __weak IBOutlet UIView *view3;
    __weak IBOutlet UIView *view4;
    __weak IBOutlet UIView *view5;
    __weak IBOutlet UIView *view6;
    __weak IBOutlet UIView *view7;
    __weak IBOutlet UIView *view8;
    __weak IBOutlet UIView *view9;
    __weak IBOutlet UIView *view10;
    __weak IBOutlet UIView *view11;
    __weak IBOutlet UIView *view12;
    
    __weak IBOutlet UIButton *startButton;
    NSArray *array;
    NSTimer *timer;
    UIView *currentView;
    float intervalTime;//变换时间差（用来表示速度）
    float accelerate;//减速度
    float endTimerTotal;//减速共耗时间
}
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    endTimerTotal = 5.0;
    
    array = [[NSArray alloc] initWithObjects:view1,view2,view3,view4,view5,view6,view7,view8,view9,view10,view11,view12,nil];
    int count = array.count;
    for (int i=0; i<count; i++) {
        UIView *view = array[i];
        view.tag = i;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//抽奖
- (IBAction)drawLotteryAction:(id)sender {
    [self initViews];
    timer = [NSTimer scheduledTimerWithTimeInterval:intervalTime target:self selector:@selector(startChoujiang:) userInfo:currentView repeats:NO];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [InternetRequest loadDataWithUrlString:@"http://old.idongway.com/sohoweb/q?method=store.get&format=json&cat=1"];
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            int resultValue = 3;
            [self endChoujiangWithResultValue:resultValue];

        });
    });
    
}

//初始化views的效果
-(void)initViews{
    intervalTime = 0.8;//起始的变换时间差（速度）
    currentView.backgroundColor = Green;
    currentView = [array objectAtIndex:0];
    currentView.backgroundColor = Red;
    
    startButton.enabled = NO;
}

-(void)startChoujiang:(id)sender{
    int count = array.count;
    NSTimer *myTimer = (NSTimer *)sender;
    UIView *preView = (UIView *)myTimer.userInfo;
    int index;
    if (preView==nil) {
        index = 0;
    }else{
        index = [array indexOfObject:preView];
    }
    if (index==count-1) {
        currentView = [array objectAtIndex:0];
    }else{
        currentView = [array objectAtIndex:index+1];
    }
    
    [self moveCurrentView:currentView inArray:array];

    
    if (intervalTime>0.1) {
        intervalTime = intervalTime - 0.1;
    }
    timer = [NSTimer scheduledTimerWithTimeInterval:intervalTime target:self selector:@selector(startChoujiang:) userInfo:currentView repeats:NO];
}


//红包移动一下
-(void)moveCurrentView:(UIView *)curView inArray:(NSArray *)views{
    
    UIView *preView = [self previewByCurrentView:curView andArray:views];
    preView.backgroundColor = Green;
    curView.backgroundColor = Red;
}

-(void)endChoujiangWithResultValue:(int)resultValue{
    accelerate = [self accelerateSpeedOfTimeMomentWithResultValue:resultValue];
    [self moveToStopWithAccelerate];
}

//减速至停止
-(void)moveToStopWithAccelerate{

    static float timeTotal = 0;
    if (timeTotal<endTimerTotal) {
        intervalTime = intervalTime+accelerate;
        timeTotal = timeTotal+intervalTime;
        [timer invalidate];
        currentView = [self nextViewByCurrentView:currentView andArray:array];
        [self moveCurrentView:currentView inArray:array];
        timer = [NSTimer scheduledTimerWithTimeInterval:intervalTime target:self selector:@selector(moveToStopWithAccelerate) userInfo:nil repeats:NO];
    }else{
        [timer invalidate];
        timeTotal = 0;
        [self showAwardView];
        startButton.enabled = YES;
    }

}

//得到上一个view
-(UIView *)previewByCurrentView:(UIView *)curView andArray:(NSArray *)views{
    int count = views.count;
    int curIndex = [views indexOfObject:curView];
    int preIndex;
    if (curIndex==0) {
        preIndex = count-1;
    }else{
        preIndex = curIndex-1;
    }
    return [views objectAtIndex:preIndex];
}

//得到下一个view
-(UIView *)nextViewByCurrentView:(UIView *)curView andArray:(NSArray *)views{
    int count = views.count;
    int curIndex = [views indexOfObject:curView];
    int nextIndex;
    if (curIndex==count-1) {
        nextIndex = 0;
    }else{
        nextIndex = curIndex+1;
    }
    return [views objectAtIndex:nextIndex];
}

//计算时间的加速度
-(float)accelerateSpeedOfTimeMomentWithResultValue:(int)resultValue{
    float a;
    int currentIndex = [array indexOfObject:currentView];
    int count = array.count;
    
    int endLength;
    
    if (resultValue>currentIndex+1) {
        endLength = resultValue-currentIndex+count-1;
    }else{
        endLength = 2*count-currentIndex-1+resultValue;
    }
    intervalTime = 0.1;
    a = (2*endTimerTotal/endLength-2*intervalTime)/(endLength-1);
    return a;

}

-(void)showAwardView{
    NSLog(@"你中了：%d等奖",currentView.tag+1);
}


@end
