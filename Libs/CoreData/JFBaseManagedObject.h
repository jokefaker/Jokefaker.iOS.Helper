//
//  FPSManagedObjectBase.h
//  FPS
//
//  Created by 周国勇 on 6/29/14.
//  Copyright (c) 2014 jokefaker. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "CommonCategory.h"

@interface JFBaseManagedObject : NSManagedObject

#pragma mark - Helper

/**
 *  在字段转化到coredata对象的时候遇到时间格式所采用的时间格式
 *
 *  @return 默认为yyyy-MM-dd HH:mm:ss，子类可以重载
 */
+ (NSString *)dateFormat;

/**
 *  创建新对象
 *
 *  @param context coredata的上下文
 *
 *  @return 返回coredata对象
 */
+ (instancetype)insertNewObjectIntoContext:(NSManagedObjectContext *)context;

/**
 *  该类所对应的实体名称
 *
 *  @return 默认为类名，子类可以重载
 */
+ (NSString *)entityName;

#pragma mark - Dictionary To Model

/**
 *  字典到对象的映射关系
 *
 *  @return 字典，value为原字典的字段名称，key为对象的字段名称
 */
+ (NSDictionary *)keyMapper;

/**
 *  字典转coredata对象
 *
 *  @param dictionary 字典
 *  @param context    coredata上下文
 *
 *  @return 返回coredata对象
 */
+ (instancetype)entityFromDictionary:(NSDictionary *)dictionary InContext:(NSManagedObjectContext *)context;

/**
 *  字典数组转coredata对象数组
 *
 *  @param dictionaries 字典数组
 *  @param context      coredata上下文
 *
 *  @return 返回coredata数组    
 */
+ (NSArray *)entitiesFromDictionaries:(NSArray *)dictionaries InContext:(NSManagedObjectContext *)context;

/**
 *  用字典为coredata对象赋值
 *
 *  @param dictionary 包含属性名和值的字典
 */
- (void)setManagedValuesForKeysWithDictionary:(NSDictionary *)dictionary;

#pragma mark - Clone

/**
 *  在自身上下文克隆自身
 *
 *  @return 克隆后的对象
 */
- (instancetype)clone;

/**
 *  在指定上下文克隆自身
 *
 *  @param context 指定上下文
 *
 *  @return 克隆后的对象
 */
- (instancetype)cloneToContext:(NSManagedObjectContext *)context;

/**
 *  在指定上下文克隆自身，但是去除某些实体
 *
 *  @param context                  指定上下文
 *  @param namesOfEntitiesToExclude 需要去除的实体
 *
 *  @return 克隆后的对象
 */
- (instancetype)cloneToContext:(NSManagedObjectContext *)context exludeEntities:(NSMutableArray *)namesOfEntitiesToExclude;

@end
