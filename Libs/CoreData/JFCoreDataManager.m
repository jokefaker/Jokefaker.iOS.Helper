//
//  FPSCoreDataManager.m
//  FPS
//
//  Created by 周国勇 on 6/29/14.
//  Copyright (c) 2014 jokefaker. All rights reserved.
//

#import "JFCoreDataManager.h"

@implementation JFCoreDataManager

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

static JFCoreDataManager *SINGLETON = nil;

static bool isFirstAccess = YES;

#pragma mark - Core Data stack

- (NSString *)dataModelName
{
    if (!_dataModelName) {
        _dataModelName = self.sqliteName;
    }
    return _dataModelName;
}

- (NSString *)sqliteName
{
    if (!_sqliteName) {
        NSDictionary *infDic = [[NSBundle mainBundle] infoDictionary];
        _sqliteName = [infDic objectForKey:@"CFBundleDisplayName"];
    }
    return _sqliteName;
}

- (NSManagedObjectContext *)managedObjectContext {
    
    // 如果不存在context，并且persistentStoreCoordinator不为空就创建一个
    if (!_managedObjectContext && self.persistentStoreCoordinator) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:self.persistentStoreCoordinator];
    }

    return _managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel {
    
    if (!_managedObjectModel) {
        
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:self.dataModelName withExtension:@"momd"];
        _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    }

    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    
    if (!_persistentStoreCoordinator) {
        
        NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:self.sqliteName];
        
        NSError *error = nil;
        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
        if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Private Method

// 取得Document的目录
- (NSURL *)applicationDocumentsDirectory {
    
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark - Public Method

+ (id)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        isFirstAccess = NO;
        SINGLETON = [[super allocWithZone:NULL]init];    
    });
    
    return SINGLETON;
}

- (void)saveContext {
    
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    
    if (managedObjectContext) {
        
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

- (NSArray *)fetchEntity:(NSString *)entityName
                    with:(NSPredicate *)predicate
          sortDescriptor:(NSSortDescriptor *)descriptor
{
    // 异常参数检测
    if (!entityName) {
        return nil;
    }
    
    NSArray *results = nil;
    
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:entityName inManagedObjectContext:self.managedObjectContext];
    if (!entityDescription) {
        return nil;
    }
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    [request setPredicate:predicate];
    
    if (descriptor) {
        [request setSortDescriptors:@[descriptor]];
    }
    
    NSError *error = nil;
    results = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (error)
    {
        return nil;
    }
    return results;
}

- (void)clearStores
{
    NSArray *stores = [self.persistentStoreCoordinator persistentStores];
    
    for(NSPersistentStore *store in stores) {
        [self.persistentStoreCoordinator removePersistentStore:store error:nil];
        [[NSFileManager defaultManager] removeItemAtPath:store.URL.path error:nil];
    }
    
    _persistentStoreCoordinator = nil;
    _managedObjectModel = nil;
    _managedObjectContext = nil;
}

- (void)deleteObject:(NSManagedObject *)object
{
    [self.managedObjectContext deleteObject:object];
}

#pragma mark - Life Cycle

+ (id) allocWithZone:(NSZone *)zone
{
    return [self sharedInstance];
}

+ (id)copyWithZone:(struct _NSZone *)zone
{
    return [self sharedInstance];
}

+ (id)mutableCopyWithZone:(struct _NSZone *)zone
{
    return [self sharedInstance];
}

- (id)copy
{
    return [[JFCoreDataManager alloc]init];
}

- (id)mutableCopy
{
    return [[JFCoreDataManager alloc]init];
}

- (id) init
{
    if(SINGLETON){
        return SINGLETON;
    }
    if (isFirstAccess) {
        [self doesNotRecognizeSelector:_cmd];
    }
    self = [super init];
    return self;
}


@end
