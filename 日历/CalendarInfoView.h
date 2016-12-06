//
//  CalendarInfoView.h
//  日历
//
//  Created by Alan on 16/12/5.
//  Copyright © 2016年 Alan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalendarInfoView : UIView


/**
 * fromIndex  月份第一天的索引
 * today      今日的索引
 */
- (void)loadDataWithArray:(NSArray *)array FromIndex:(NSInteger)index TodayIndex:(NSInteger)today;



@end
