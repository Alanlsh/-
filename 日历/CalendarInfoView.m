//
//  CalendarInfoView.m
//  日历
//
//  Created by Alan on 16/12/5.
//  Copyright © 2016年 Alan. All rights reserved.
//

/**
   若要改变每一个日期对应的item时，仅需改变当前view对象的frame
   若是需要日期对应的item有自定义交互或界面设计时，可以试着自定义一个UIView类来顶替UIlabel做item，并做好相关交互
 
 */

#import "CalendarInfoView.h"

@implementation CalendarInfoView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        CGFloat viewWidth = frame.size.width;
        CGFloat itemHeight = frame.size.height/6.0;
        
        for (NSInteger i = 0; i < 6; i ++ ) {
            
            for (NSInteger index = 0; index < 7; index ++ ) {
                
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(index * viewWidth/7.0, i * itemHeight , viewWidth/7.0, itemHeight)];
                label.textAlignment = NSTextAlignmentCenter;
                label.tag = i * 7 + index + 10000;
                [self addSubview:label];
            }
        }
    }

    return self;
}

- (void)loadDataWithArray:(NSArray *)array FromIndex:(NSInteger)index TodayIndex:(NSInteger)today
{
    
    for (NSInteger i = 0; i < 6; i ++ ) {
        
        for (NSInteger index = 0; index < 7; index ++ ) {
            
            UILabel *label = [self viewWithTag:i * 7 + index + 10000];
            label.text = nil;
            label.backgroundColor = [UIColor whiteColor];
        }
    }
    
    
    for (NSInteger i = index; i < index + array.count; i ++ ) {
        
        UILabel *label = [self viewWithTag:i + 10000];
        label.text = array[i - index];
        label.backgroundColor = [UIColor whiteColor];
        
    }
    
    if (today > 0) {
        UILabel *label = [self viewWithTag:today + index + 10000];
        label.backgroundColor = [UIColor orangeColor];
    }
    
    
}




@end
