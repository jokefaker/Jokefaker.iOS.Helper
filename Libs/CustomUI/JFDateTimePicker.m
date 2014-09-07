//
//  JFDateTimePicker.m
//  DateTimePicker
//
//  Created by 周国勇 on 8/13/14.
//  Copyright (c) 2014 hzgw. All rights reserved.
//

#import "JFDateTimePicker.h"
#import "CommonCategory.h"

@interface JFDateTimePicker ()<UIPickerViewDelegate,UIPickerViewDataSource>

@property (strong, nonatomic) UIPickerView *picker;
@property (strong, nonatomic) NSArray *months;
@property (strong, nonatomic) NSArray *years;
@property (strong, nonatomic) NSArray *days;
@property (strong, nonatomic) NSArray *hours;
@property (strong, nonatomic) NSArray *minutes;
@property (strong, nonatomic) NSArray *seconds;

@property (strong, nonatomic) NSCalendar *calendar;

// 选中的item
@property (strong, nonatomic) NSString *selectedYear;
@property (strong, nonatomic) NSString *selectedMonth;
@property (strong, nonatomic) NSString *selectedDay;
@property (strong, nonatomic) NSString *selectedHour;
@property (strong, nonatomic) NSString *selectedMinute;

@property (nonatomic) BOOL animate;
@end

@implementation JFDateTimePicker

#pragma mark - Init

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    self.dateTimePickerMode = JFDateTimePickerModeDateAndTime;
    [self addSubview:self.picker];
}

#pragma mark - Properties

- (NSCalendar *)calendar
{
    if (!_calendar) {
        _calendar = [NSCalendar currentCalendar];
    }
    return _calendar;
}

- (UIPickerView *)picker
{
    if (!_picker) {
        CGRect frame = self.frame;
        frame.origin = CGPointMake(0, 0);
        _picker = [[UIPickerView alloc] initWithFrame:frame];
        _picker.delegate = self;
        _picker.dataSource = self;
        _picker.backgroundColor = [UIColor clearColor];
    }
    return _picker;
}

- (NSArray *)years
{
    if (!_years) {
        NSMutableArray *array = [NSMutableArray array];
        NSInteger maxYear = 2050;
        NSInteger minYear = 1970;
        if (self.maximumDate) {
            maxYear = self.maximumDate.year;
        }
        if (self.minimumDate) {
            minYear = self.minimumDate.year;
        }
        for (int i = minYear; i <= maxYear ; i++)
        {
            [array addObject:[NSString stringWithFormat:@"%d",i]];
        }
        _years = [NSArray arrayWithArray:array];
    }
    return _years;
}

- (NSArray *)months
{
    NSMutableArray *array = [NSMutableArray array];
    
    // 最后一年
    if (self.maximumDate && self.selectedYear.integerValue == self.maximumDate.year) {
        for (NSInteger i = 1; i <= self.maximumDate.month; i++) {
            [array addObject:[NSString stringWithFormat:@"%d",i]];
        }
    }
    // 第一年
    else if (self.minimumDate && self.selectedYear.integerValue == self.minimumDate.year){
        for (NSInteger i = self.minimumDate.month; i <= 12; i++) {
            [array addObject:[NSString stringWithFormat:@"%d",i]];
        }
    }else{
        for (NSInteger i = 1; i <= 12; i++) {
            [array addObject:[NSString stringWithFormat:@"%d",i]];
        }
    }
    _months = [NSArray arrayWithArray:array];
    return _months;
}

- (NSArray *)days
{
    NSMutableArray *array = [NSMutableArray array];
    NSInteger count = [self theDaysInYear:self.selectedYear.integerValue inMonth:self.selectedMonth.integerValue];
    // 最后一年最后一个月
    if (self.maximumDate &&
        self.selectedYear.integerValue == self.maximumDate.year &&
        self.selectedMonth.integerValue == self.maximumDate.month) {
        for (NSInteger i = 1; i <= self.maximumDate.day; i++) {
            [array addObject:[NSString stringWithFormat:@"%02d",i]];
        }
    }
    // 第一年第一个月
    else if (self.minimumDate &&
             self.selectedYear.integerValue == self.minimumDate.year &&
             self.selectedMonth.integerValue == self.minimumDate.month){
        for (NSInteger i = self.minimumDate.day; i <= count; i++) {
            [array addObject:[NSString stringWithFormat:@"%02d",i]];
        }
    }else{
        for (NSInteger i = 1; i <= count; i++) {
            [array addObject:[NSString stringWithFormat:@"%02d",i]];
        }
    }
    _days = [NSArray arrayWithArray:array];
    return _days;
}

- (NSArray *)hours
{
    NSMutableArray *array = [NSMutableArray array];
    // 最后一年最后一个月最后一天
    if (self.maximumDate &&
        self.selectedYear.integerValue == self.maximumDate.year &&
        self.selectedMonth.integerValue == self.maximumDate.month &&
        self.selectedDay.integerValue == self.maximumDate.day) {
        for (NSInteger i = 0; i <= self.maximumDate.hour; i++) {
            [array addObject:[NSString stringWithFormat:@"%02d",i]];
        }
    }
    // 第一年第一个月第一天
    else if (self.minimumDate &&
             self.selectedYear.integerValue == self.minimumDate.year &&
             self.selectedMonth.integerValue == self.minimumDate.month &&
             self.selectedDay.integerValue == self.minimumDate.day){
        for (NSInteger i = self.minimumDate.hour; i <= 23; i++) {
            [array addObject:[NSString stringWithFormat:@"%02d",i]];
        }
    }else{
        for (NSInteger i = 0; i <= 23; i++) {
            [array addObject:[NSString stringWithFormat:@"%02d",i]];
        }
    }
    _hours = [NSArray arrayWithArray:array];
    return _hours;
}

- (NSArray *)minutes
{
    NSMutableArray *array = [NSMutableArray array];
    // 最后一年最后一个月最后一天最后一个小时
    if (self.maximumDate &&
        self.selectedYear.integerValue == self.maximumDate.year &&
        self.selectedMonth.integerValue == self.maximumDate.month &&
        self.selectedDay.integerValue == self.maximumDate.day &&
        self.selectedHour.integerValue == self.maximumDate.hour) {
        for (NSInteger i = 0; i <= self.maximumDate.minute; i++)
        {
            [array addObject:[NSString stringWithFormat:@"%02d",i]];
        }
    }
    // 第一年第一个月第一天第一个小时
    else if (self.minimumDate &&
             self.selectedYear.integerValue == self.minimumDate.year &&
             self.selectedMonth.integerValue == self.minimumDate.month &&
             self.selectedDay.integerValue == self.minimumDate.day &&
             self.selectedHour.integerValue == self.minimumDate.hour){
        for (NSInteger i = self.minimumDate.minute; i <= 59; i++)
        {
            [array addObject:[NSString stringWithFormat:@"%02d",i]];
        }
    }else{
        for (NSInteger i = 0; i <= 59; i++)
        {
            [array addObject:[NSString stringWithFormat:@"%02d",i]];
        }
    }
    _minutes = [NSArray arrayWithArray:array];

    return _minutes;
}

- (NSArray *)seconds
{
    if (!_seconds) {
        NSMutableArray *array = [NSMutableArray array];
        for (int i = 0; i < 60; i++)
        {
            [array addObject:[NSString stringWithFormat:@"%02d",i]];
        }
        _seconds = [NSArray arrayWithArray:array];
    }
    return _seconds;
}

#pragma mark - Selected Item

- (NSString *)selectedYear
{
    NSInteger row = [self.picker selectedRowInComponent:0];
    return self.years[row];
}

- (NSString *)selectedMonth
{
    NSInteger row = [self.picker selectedRowInComponent:1];
    return self.months[row];
}

- (NSString *)selectedDay
{
    NSInteger row = [self.picker selectedRowInComponent:2];
    return self.days[row];
}

- (NSString *)selectedHour
{
    NSInteger row = [self.picker selectedRowInComponent:3];
    return self.hours[row];
}

- (NSString *)selectedMinute
{
    NSInteger row = [self.picker selectedRowInComponent:4];
    return self.minutes[row];
}

- (void)setSelectedYear:(NSString *)selectedYear
{
    for (NSInteger i = 0; i < self.years.count; i++) {
        if ([selectedYear isEqualToString:self.years[i]]) {
            [self.picker selectRow:i inComponent:0 animated:self.animate];
            [self.picker reloadComponent:1];
            break;
        }
    }
}

- (void)setSelectedMonth:(NSString *)selectedMonth
{
    for (NSInteger i = 0; i < self.months.count; i++) {
        if ([selectedMonth isEqualToString:self.months[i]]) {
            [self.picker selectRow:i inComponent:1 animated:self.animate];
            [self.picker reloadComponent:2];
            break;
        }
    }
}

- (void)setSelectedDay:(NSString *)selectedDay
{
    for (NSInteger i = 0; i < self.days.count; i++) {
        if ([selectedDay isEqualToString:self.days[i]]) {
            [self.picker selectRow:i inComponent:2 animated:self.animate];
            if (self.dateTimePickerMode == JFDateTimePickerModeDateAndTime) {
                [self.picker reloadComponent:3];
            }
            break;
        }
    }

}

- (void)setSelectedHour:(NSString *)selectedHour
{
    for (NSInteger i = 0; i < self.hours.count; i++) {
        if ([selectedHour isEqualToString:self.hours[i]]) {
            [self.picker selectRow:i inComponent:3 animated:self.animate];
            [self.picker reloadComponent:4];
            break;
        }
    }
}

- (void)setSelectedMinute:(NSString *)selectedMinute
{
    for (NSInteger i = 0; i < self.minutes.count; i++) {
        if ([selectedMinute isEqualToString:self.minutes[i]]) {
            [self.picker selectRow:i inComponent:4 animated:self.animate];
            break;
        }
    }
}

#pragma mark - Date

- (NSDate *)date
{
    NSString *dateString = nil;
    NSString *format = @"yyyy-MM-dd HH:mm";
    if (self.dateTimePickerMode == JFDateTimePickerModeDateAndTime) {
        dateString =  [NSString stringWithFormat:@"%@-%@-%@ %@:%@",self.selectedYear,self.selectedMonth,self.selectedDay,self.selectedHour,self.selectedMinute];
    }else{
        dateString =  [NSString stringWithFormat:@"%@-%@-%@",self.selectedYear,self.selectedMonth,self.selectedDay];
        format = @"yyyy-MM-dd";
    }
    
    return [dateString dateWithFormate:format];
}

- (void)setDate:(NSDate *)date
{
    [self setDate:date animated:NO];
}

- (void)setDate:(NSDate *)date animated:(BOOL)animated
{
    // 异常判断
    if (!date || ![date isKindOfClass:[NSDate class]]) {
        return;
    }
    NSDate *tempMin = [date dateByAddingMinutes:1];
    NSDate *tempMax = [date dateBySubtractingMinutes:1];

    // 过滤超出范围的date
    if ((self.minimumDate && [tempMin isEarlierThanDate:self.minimumDate]) || (self.maximumDate && [tempMax isLaterThanDate:self.maximumDate])) {
        return;
    }
    self.animate = animated;
    self.selectedYear = [NSString stringWithFormat:@"%d",date.year];
    self.selectedMonth = [NSString stringWithFormat:@"%d",date.month];
    self.selectedDay = [NSString stringWithFormat:@"%02d",date.day];
    if (self.dateTimePickerMode == JFDateTimePickerModeDateAndTime) {
        self.selectedHour = [NSString stringWithFormat:@"%02d",date.hour];
        self.selectedMinute = [NSString stringWithFormat:@"%02d",date.minute];
    }
}

#pragma mark - Public Method

- (void)reloadPicker
{
    [self.picker reloadAllComponents];
}

#pragma mark - Private Method

-(NSInteger)theDaysInYear:(NSInteger)year inMonth:(NSInteger)month
{
    if (month == 1||month == 3||month == 5||month == 7||month == 8||month == 10||month == 12) {
        return 31;
    }
    if (month == 4||month == 6||month == 9||month == 11) {
        return 30;
    }
    if ((year % 4 == 0 && year % 100 != 0) || year % 400 == 0) {
        return 29;
    }
    return 28;
}

#pragma mark - Picker View Delegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        [self.picker reloadComponent:1];
    }
    if (component == 0 || component == 1) {
        [self.picker reloadComponent:2];
    }
    if (self.dateTimePickerMode == JFDateTimePickerModeDateAndTime) {
        if (component == 0 || component == 1 || component == 2) {
            [self.picker reloadComponent:3];
        }
        if (component != 4) {
            [self.picker reloadComponent:4];
        }
    }
    NSLog(@"%@",[self.date descriptionWithLocale:[NSLocale currentLocale]]);
}

#pragma mark - Picker View Data Source

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *pickerLabel = (UILabel *)view;
    if (!pickerLabel) {
        CGRect frame = CGRectMake(0.0, 0.0, 50, 60);
        pickerLabel = [[UILabel alloc] initWithFrame:frame];
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont systemFontOfSize:17.0f]];
        pickerLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:15.0];
        pickerLabel.textColor = [UIColor blackColor];
    }

    NSArray *array = self.years;
    NSString *unit = @"年";
    switch (component) {
        case 0:
            array = self.years;
            unit = @"年";
            break;
        case 1:
            array = self.months;
            unit = @"月";
            break;
        case 2:
            array = self.days;
            unit = @"日";
            break;
        case 3:
            array = self.hours;
            unit = @"时";
            break;
        case 4:
            array = self.minutes;
            unit = @"分";
            break;
        case 5:
            array = self.seconds;
            break;
        default:
            break;
    }
    NSInteger select = array.count > row ? row : array.count-1;
    pickerLabel.text = [NSString stringWithFormat:@"%@%@",array[select],unit];
    return pickerLabel;}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (self.dateTimePickerMode == JFDateTimePickerModeDateAndTime) {
        return 5;
    }
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSInteger count = 0;
    switch (component) {
        case 0:
            count = self.years.count;
            break;
        case 1:
            count = self.months.count;
            break;
        case 2:
            count = self.days.count;
            break;
        case 3:
            count = self.hours.count;
            break;
        case 4:
            count = self.minutes.count;
            break;
        case 5:
            count = self.seconds.count;
            break;
        default:
            break;
    }
    return count;
}


@end
