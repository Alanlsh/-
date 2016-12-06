//
//  ViewController.m
//  日历
//
//  Created by Alan on 16/12/2.
//  Copyright © 2016年 Alan. All rights reserved.
//

#import "ViewController.h"

#import "CalendarView.h"

@interface ViewController ()

@property (nonatomic, strong) CalendarView *calendarView;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    self.view.backgroundColor = [UIColor grayColor];
    [self.view addSubview:self.calendarView];
    
    
    
    
    

}

- (CalendarView *)calendarView
{
    if (!_calendarView) {
        _calendarView = [[CalendarView alloc] initWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, 300)];
    }
    return _calendarView;
}


@end
