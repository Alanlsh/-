//
//  CalendarView.m
//  日历
//
//  Created by Alan on 16/12/2.
//  Copyright © 2016年 Alan. All rights reserved.
//

#import "CalendarView.h"
#import "CalendarInfoView.h"

#define kScreenWidth   [UIScreen mainScreen].bounds.size.width
#define KScreenHeight    [UIScreen mainScreen].bounds.size.height


#define KViewWidth     self.bounds.size.width
#define KViewHeight    self.bounds.size.height


#define HeadLabelHeight  30
#define HweekLabelHeight 20


@interface CalendarView ()

//@property (nonatomic, strong) NSCalendar *myCalendar;

@property (nonatomic, strong) UILabel *headLabel;

@property (nonatomic, strong) CalendarInfoView *calendarInfoView;

/// 当前日历显示的月份的某个日期
@property (nonatomic, strong) NSDate *currentDate;

@end

@implementation CalendarView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
//        //初始化日历类，并设置日历类的格式是阳历 若想设置中国日历 设置为NSChineseCalendar
//        self.myCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
//        //设置每周的第一天从星期几开始  设置为 1 是周日，2是周一
//        [self.myCalendar setFirstWeekday:1];
//        //设置每个月或者每年的第一周必须包含的最少天数  设置为1 就是第一周至少要有一天
//        [self.myCalendar setMinimumDaysInFirstWeek:1];
//        //设置时区，不设置时区获取月的第一天和星期的第一天的时候可能会提前一天。
//        [self.myCalendar setTimeZone:[NSTimeZone timeZoneWithAbbreviation:0]];
//        //计算绘制日历需要的数据，我传入当前日期  输入月份或年不同的日期就能得到不同的日历。
////        [self calendarSetDate:[NSDate date]];
        
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.headLabel];
        
        UIButton *lastButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, HeadLabelHeight)];
        [lastButton setTitle:@"<" forState:UIControlStateNormal];
        [lastButton addTarget:self action:@selector(lastMonth) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:lastButton];
        
        UIButton *nextButton = [[UIButton alloc] initWithFrame:CGRectMake(KViewWidth - 60, 0, 60, HeadLabelHeight)];
        [nextButton setTitle:@">" forState:UIControlStateNormal];
        [nextButton addTarget:self action:@selector(nextMonth) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:nextButton];
        
        NSArray *weeks = @[@"日",@"一",@"二",@"三",@"四",@"五",@"六"];
        for (NSInteger i = 0; i < 7; i ++ ) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(i * KViewWidth/7.0, self.headLabel.bounds.size.height, KViewWidth/7.0, HweekLabelHeight)];
            label.backgroundColor = [UIColor grayColor];
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = [UIColor whiteColor];
            label.text = weeks[i];
            [self addSubview:label];
        }
        
        [self addSubview:self.calendarInfoView];

        [self reloadCalendarDataWithDate:[NSDate date]];
    }
    return self;
}

//前一个月
- (void)lastMonth
{
    NSDate *date = [self getDateWithParame:-1];
    [self reloadCalendarDataWithDate:date];
    
}

// 后一个月
- (void)nextMonth
{
    NSDate *date = [self getDateWithParame:1];
    [self reloadCalendarDataWithDate:date];
}

/// parame 决定得到的日期为日历当前月的之前的月份还是之后的月份
- (NSDate *)getDateWithParame:(NSInteger)parame
{
    if (!self.currentDate) {
        self.currentDate = [NSDate date];
    }
    
    NSDateComponents * dateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond|NSCalendarUnitWeekOfMonth|NSCalendarUnitWeekday fromDate:self.currentDate];

    if (parame <= 0) {
    
        if (dateComponents.month == 1) {
            dateComponents.month = 12;
            dateComponents.year -= 1;
        }else{
            dateComponents.month -= 1;
        }
        
    }else{
    
        if (dateComponents.month == 12) {
            dateComponents.month = 1;
            dateComponents.year += 1;
        }else{
            dateComponents.month += 1;
        }
    }
    
    NSString *dateString = [NSString stringWithFormat:@"%zd-%zd-%zd",dateComponents.year,dateComponents.month,dateComponents.day];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSDate *date = [formatter dateFromString:dateString];

    self.currentDate = date;

    return date;
}

//  传入一个时间 刷新页面日历信息
- (void)reloadCalendarDataWithDate:(NSDate *)date
{
    self.headLabel.text = [self getYearMonthStringWithDate:date];
    
    NSArray *array = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",@"31"];
    
    NSInteger days = [self getNumberOfDaysInMonthWithDate:date];
    NSArray *dataArray = [array subarrayWithRange:NSMakeRange(0, days)];
    
    //月份的第一天索引
    NSInteger index = [self getFirstWeekDayWithDate:date] - 1;
    
    //今天的索引
    
    // 设置日期
    NSDateComponents * dateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond|NSCalendarUnitWeekOfMonth|NSCalendarUnitWeekday fromDate:date];
    // 今日
    NSDateComponents * todayComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond|NSCalendarUnitWeekOfMonth|NSCalendarUnitWeekday fromDate:[NSDate date]];
    
    NSInteger todayIndex = -1;
    if (todayComponents.month == dateComponents.month) {
        if (todayComponents.year == dateComponents.year) {
           todayIndex = [[NSCalendar currentCalendar] ordinalityOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:[NSDate date]] - 1;
        }
    }
    
    [self.calendarInfoView loadDataWithArray:dataArray FromIndex:index TodayIndex:todayIndex];

}

#pragma mark - 日历数据相关
/// 根据指定日期获取该日期所在年月字符串
- (NSString *)getYearMonthStringWithDate:(NSDate *)date
{
    NSDateComponents * components = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond|NSCalendarUnitWeekOfMonth|NSCalendarUnitWeekday fromDate:date];

    return[NSString stringWithFormat:@"%zd年%zd月",components.year,components.month];
}


/// 根据NSDate对象获取该月的天数
- (NSInteger)getNumberOfDaysInMonthWithDate:(NSDate *)date
{
    NSCalendar * calendar = [NSCalendar currentCalendar]; // 指定日历的算法
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit: NSCalendarUnitMonth forDate:date];
    
    return range.length;
}

/// 根据NSDate对象获取该月的第一天周几
- (NSInteger)getFirstWeekDayWithDate:(NSDate *)date
{
    NSTimeInterval interval;
    NSDate *startDate = nil;
    
    if ([[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitMonth startDate:&startDate interval:&interval forDate:date]) {
        
        // startDate 就是第一天的数据
        // 获取第一天为周几   5:周四   6： 周五
        NSInteger weekDay = [[NSCalendar currentCalendar] ordinalityOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitWeekOfMonth forDate:startDate];
        
        return weekDay;
        
    }else{
    
        NSDateComponents * dateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond|NSCalendarUnitWeekOfMonth|NSCalendarUnitWeekday fromDate:[NSDate date]];
        
        NSString *dateString = [NSString stringWithFormat:@"%zd-%zd-%zd",dateComponents.year,dateComponents.month,1];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd";
        NSDate *date = [formatter dateFromString:dateString];
        
        NSInteger weekDay = [[NSCalendar currentCalendar] ordinalityOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitWeekOfMonth forDate:date];
        
        return weekDay;
    }

    return 0;
}


/**

 /// 该方法计算date所在的larger单位里有几个smaller单位
   -(NSRange)rangeOfUnit:(NSCalendarUnit)smaller inUnit:(NSCalendarUnit)larger forDate:(NSDate *)date;
 
 /// 该方法计算date所在的smaller单位在date所在的larger单位里的位置，即第几位    也可计算在一周里第几
  -(NSUInteger)ordinalityOfUnit:(NSCalendarUnit)smaller inUnit:(NSCalendarUnit)larger forDate:(NSDate *)date;
 
 ///若datep 和 tip 可计算，则方法返回YES，否则返回NO。当返回YES时，可从datep里得到date所在的 unit单位 的第一天。unit可以为 NSMonthCalendarUnit NSWeekCalendarUnit 等
 -(BOOL)rangeOfUnit:(NSCalendarUnit)unit startDate:(NSDate *)datep interval:(NSTimeInterval )tip forDate:(NSDate *)date;
 
 
 另：下面也可算周几
 NSDateComponents *comps = [calendar components:NSWeekdayCalendarUnit fromDate:date];

 */



#pragma mark - initializing
- (UILabel *)headLabel
{
    if (!_headLabel) {
        _headLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, KViewWidth, HeadLabelHeight)];
        _headLabel.textAlignment = NSTextAlignmentCenter;
        _headLabel.textColor = [UIColor whiteColor];
        _headLabel.backgroundColor = [UIColor greenColor];
    }
    return _headLabel;
}

- (CalendarInfoView *)calendarInfoView
{
    if (!_calendarInfoView) {
        _calendarInfoView = [[CalendarInfoView alloc] initWithFrame:CGRectMake(0, HeadLabelHeight + HweekLabelHeight , KViewWidth, KViewHeight - HeadLabelHeight - HweekLabelHeight)];
     }
    return _calendarInfoView;
}

@end
