//
//  JFDateTimePicker.h
//  DateTimePicker
//
//  Created by 周国勇 on 8/13/14.
//  Copyright (c) 2014 hzgw. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, JFDateTimePickerMode) {
    JFDateTimePickerModeTime,          // 未实现
    JFDateTimePickerModeDate,
    JFDateTimePickerModeDateAndTime};

@interface JFDateTimePicker : UIView

@property (strong, nonatomic) NSDate *date; // 当前选中的日期
@property (strong, nonatomic) NSDate *maximumDate;  // 最大日期
@property (strong, nonatomic) NSDate *minimumDate;  // 最小日期
@property (nonatomic) JFDateTimePickerMode dateTimePickerMode;  // 时间日期类型

/**
 *  设置日期
 *
 *  @param date     要设置的日期，如果存在最大最小值，将会对日期进行过滤
 *  @param animated 是否使用动画
 */
- (void)setDate:(NSDate *)date animated:(BOOL)animated;

/**
 *  重载picker
 */
- (void)reloadPicker;
@end
