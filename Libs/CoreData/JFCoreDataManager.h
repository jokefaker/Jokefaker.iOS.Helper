//
//  FPSCoreDataManager.h
//  FPS
//
//  Created by 周国勇 on 6/29/14.
//  Copyright (c) 2014 jokefaker. All rights reserved.
//
#import <CoreData/CoreData.h>

@interface JFCoreDataManager : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (strong, nonatomic) NSString *sqliteName;
@property (strong, nonatomic) NSString *dataModelName;

/**
 * 获得CoreDataManager的单例
 * @return 单例
 */
+ (JFCoreDataManager*)sharedInstance;

/**
 *  保存CoreData的上下文
 */
- (void)saveContext;

/**
 *  从数据库读取对象
 *
 *  @param entityName 实体名称
 *  @param predicate  查询条件
 *  @param descriptor 排序条件
 *
 *  @return 对象数组，如果参数异常则返回nil
 */
- (NSArray *)fetchEntity:(NSString *)entityName
                    with:(NSPredicate *)predicate
          sortDescriptor:(NSSortDescriptor *)descriptor;

/**
 *  删除所有coredata数据
 */
- (void)clearStores;

/**
 *  删除指定coredata对象
 *
 *  @param object 指定NSManagedObject子对象
 */
- (void)deleteObject:(NSManagedObject *)object;


@end
