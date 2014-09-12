//
//  FPSManagedObjectBase.m
//  FPS
//
//  Created by 周国勇 on 6/29/14.
//  Copyright (c) 2014 jokefaker. All rights reserved.
//

#import "JFBaseManagedObject.h"

@implementation JFBaseManagedObject
@synthesize dictionaryValue = _dictionaryValue;

#pragma mark - Properties

- (NSDictionary *)dictionaryValue
{
    if (!_dictionaryValue) {
        NSMutableDictionary *cache = [NSMutableDictionary new];
        _dictionaryValue = [self getDictionaryValueWithConvertedCache:&cache];
    }
    return _dictionaryValue;
}

#pragma mark - Helper

+ (NSString *)dateFormat
{
    return @"yyyy-MM-dd HH:mm:ss";
}

+ (NSString *)entityName
{
    return NSStringFromClass([self class]);
}

+ (instancetype)insertNewObjectIntoContext:(NSManagedObjectContext *)context
{
    // 异常参数判断
    if (!context) {
        return nil;
    }
    return [NSEntityDescription insertNewObjectForEntityForName:[self entityName]
                                         inManagedObjectContext:context];
}

#pragma mark - Model To Dictionary

/**
 *  获取转换后的字典
 *
 *  @param alreadyConverted 存储
 *
 *  @return 转换后的字典
 */
- (NSDictionary *)getDictionaryValueWithConvertedCache:(NSMutableDictionary **)alreadyConverted
{
    JFBaseManagedObject *converted = nil;
    if (alreadyConverted == NULL) {
        NSLog(@"alreadyConverted array is null");
        return nil;
    }
    converted = [*alreadyConverted objectForKey:[self objectID]];
    // 如果已经转换过了那就直接返回，主要为了防止 父类<->子类的循环转换
    if (converted){
        return nil;
    }
    // 记录已经拷贝过的实体
    [*alreadyConverted setObject:self forKey:[self objectID]];

    // 开始转换
    NSMutableDictionary *dictionary = [NSMutableDictionary new];
    // 属性转换
    NSDictionary *attributes = [[self entity] attributesByName];
    for (NSString *attribute in attributes) {
        
        // 如果有keymapper就转换一下
        NSString *dictionaryKey = [[[self class] keyMapper] objectForKey:attribute]?[[[self class] keyMapper] objectForKey:attribute]:attribute;
        id value = [self valueForKey:attribute];
        if (value) {
            [dictionary setObject:value forKey:dictionaryKey];
        }
    }
    // 关系转换
    NSDictionary *relationships = [[self entity] relationshipsByName];
    for (NSString *relationshipName in relationships.allKeys){
        
        NSRelationshipDescription *rel = relationships[relationshipName];
        //        NSEntityDescription *subEntityeDes = rel.destinationEntity;
        
        // 如果有keymapper就转换一下
        NSString *dictionaryKey = [[[self class] keyMapper] objectForKey:relationshipName]?[[[self class] keyMapper] objectForKey:relationshipName]:relationshipName;
        
        JFBaseManagedObject *value = [self valueForKey:dictionaryKey];
        // 一对一关系的处理
        if (![rel isToMany]) {
            NSDictionary *dic = [value getDictionaryValueWithConvertedCache:alreadyConverted];
            if (dic) {
                [dictionary setObject:dic forKey:dictionaryKey];
            }
            continue;
        }
        NSArray *array = [self mutableSetValueForKey:relationshipName].allObjects;
        // key值已经存在，说明应该已经转换过，所以无需转换
        if (![dictionary objectForKey:dictionaryKey]) {
            NSMutableArray *tempArray = [NSMutableArray new];
            for (JFBaseManagedObject *obj in array) {
                NSDictionary *dic = [obj getDictionaryValueWithConvertedCache:alreadyConverted];
                if (dic) {
                    [tempArray addObject:dic];
                }
            }
            [dictionary setObject:[NSArray arrayWithArray:tempArray] forKey:dictionaryKey];
        }
    }
    return dictionary;
}

#pragma mark - Dictionary To Model

+ (NSDictionary *)keyMapper
{
    return nil;
}

+ (instancetype)entityFromDictionary:(NSDictionary *)dictionary InContext:(NSManagedObjectContext *)context
{
    // 异常参数判断
    if (!dictionary || !context) {
        return nil;
    }
    
    // 用父类接收子类创建好的对象
    JFBaseManagedObject *entity = [[self class] insertNewObjectIntoContext:context];
    // 赋值
    [entity setManagedValuesForKeysWithDictionary:dictionary];
    
    return entity;
}

+ (NSArray *)entitiesFromDictionaries:(NSArray *)dictionaries InContext:(NSManagedObjectContext *)context
{
    // 异常参数判断
    if (!dictionaries || !context) {
        return nil;
    }
    
    NSMutableArray *entities = [NSMutableArray array];
    // 遍历字典数组
    for (NSDictionary *dic in dictionaries) {
        [entities addObject:[[self class] entityFromDictionary:dic InContext:context]];
    }
    
    return entities;
}

- (void)setManagedValuesForKeysWithDictionary:(NSDictionary *)dictionary
{
    // 异常参数判断
    if (!dictionary) {
        return;
    }
    // 属性转换
    NSDictionary *attributes = [[self entity] attributesByName];
    for (NSString *attribute in attributes) {
        
        // 如果有keymapper就转换一下
        NSString *dictionaryKey = [[[self class] keyMapper] objectForKey:attribute]?[[[self class] keyMapper] objectForKey:attribute]:attribute;
        
        id value = [dictionary objectForKey:dictionaryKey];
        if (value == nil) {
            continue;
        }
        NSAttributeType attributeType = [[attributes objectForKey:attribute] attributeType];
        // 字典中是数字，属性中是字符串，则将数字转换为字符串
        if ((attributeType == NSStringAttributeType) && ([value isKindOfClass:[NSNumber class]])) {
            
            value = [value stringValue];
        }
        // 字典中是字符串，属性中是Int，则将字符串转为NSNumber
        else if (((attributeType == NSInteger16AttributeType) ||
                  (attributeType == NSInteger32AttributeType) ||
                  (attributeType == NSInteger64AttributeType)) && ([value isKindOfClass:[NSString class]])) {
            
            value = @([value integerValue]);
        }
        // 字典中是字符串，属性中是Boolean，则将字符串转为NSNumber
        else if (attributeType == NSBooleanAttributeType  && ([value isKindOfClass:[NSString class]])){
            
            value = @([value boolValue]);
        }
        // 字典中是字符串，属性中是float，则将字符串转为NSNumber
        else if (attributeType == NSFloatAttributeType  && ([value isKindOfClass:[NSString class]])){
            
            value = @([value floatValue]);
        }
        // 字典中是字符串，属性中是double，则将字符串转为NSNumber
        else if (((attributeType == NSDoubleAttributeType) ||
                  (attributeType == NSDecimalAttributeType))  && ([value isKindOfClass:[NSString class]])){
            
            value = @([value doubleValue]);
        }
        // 字典中是字符串，属性中是date，则将字符串转为NSDate
        else if ((attributeType == NSDateAttributeType) && ([value isKindOfClass:[NSString class]])) {
            
            value = [value dateWithFormate:[[self class]dateFormat]];
        }
        // 自定义类型，暂时用不到
        else if ((attributeType == NSTransformableAttributeType) && ([value isKindOfClass:[NSDictionary class]])) {
            
//            value = value;
        }
        // 把 NSNull 转为 nil
        else if ([value isKindOfClass:[NSNull class]]) {
            
            value = nil;
        }
        
        [self setValue:value forKey:attribute];
    }
    NSDictionary *relationships = [[self entity] relationshipsByName];
    for (NSString *relationshipName in relationships.allKeys){
        
        NSRelationshipDescription *rel = relationships[relationshipName];
        NSEntityDescription *subEntityeDes = rel.destinationEntity;
        NSString *className = [subEntityeDes managedObjectClassName];
        Class entityClass = NSClassFromString(className);
        
        // 如果有keymapper就转换一下
        NSString *dictionaryKey = [[[self class] keyMapper] objectForKey:relationshipName]?[[[self class] keyMapper] objectForKey:relationshipName]:relationshipName;
        
        id value = [dictionary objectForKey:dictionaryKey];
        // 一对一关系的处理
        if (![rel isToMany]) {
            // key值不是字典，直接继续循环
            if (![value isKindOfClass:[NSDictionary class]]) {
                continue;
            }
            // key值已经存在，说明已经设置过，所以无需转换
            if ([self valueForKey:relationshipName]) {
                continue;
            }
            JFBaseManagedObject *childObject = [entityClass entityFromDictionary:value InContext:self.managedObjectContext];
            [self setValue:childObject forKey:relationshipName];
            continue;
        }
        // 一对多关系的处理
        if (![value isKindOfClass:[NSArray class]]) {
            continue;
        }
        NSMutableSet *relationshipSet = [self mutableSetValueForKey:relationshipName];
        // key值已经存在，说明应该已经转换过，所以无需转换
        // 已经存在关系，说明已经设置过直接继续
        if (relationshipSet.count > 0) {
            continue;
        }
        NSArray *subEntities = [entityClass entitiesFromDictionaries:value InContext:self.managedObjectContext];
        [relationshipSet addObjectsFromArray:subEntities];
    }
}

#pragma mark - Clone

- (instancetype)clone
{
    return [self cloneToContext:self.managedObjectContext];
}

- (instancetype)cloneToContext:(NSManagedObjectContext *)context
{
    return [self cloneToContext:context exludeEntities:nil];
}

- (instancetype)cloneToContext:(NSManagedObjectContext *)context exludeEntities:(NSMutableArray *)namesOfEntitiesToExclude
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    return [self cloneToContext:context withCopiedCache:&dictionary exludeEntities:namesOfEntitiesToExclude];
}

/**
 *  拷贝自身到指定context
 *
 *  @param context                  指定coredata context
 *  @param alreadyCopied            已经拷贝过的对象
 *  @param namesOfEntitiesToExclude 需要忽略的对象
 *
 *  @return 实例对象
 */
- (instancetype)cloneToContext:(NSManagedObjectContext *)context
               withCopiedCache:(NSMutableDictionary **)alreadyCopied
                exludeEntities:(NSMutableArray *)namesOfEntitiesToExclude
{
    // 异常检查
    if (!context) {
        NSLog(@"clone's target context is nil");
        return nil;
    }
    // 排除的实体检查
    if ([namesOfEntitiesToExclude containsObject:[[self entity] name]]) {
        return nil;
    }
    // 已经拷贝过的实体检查
    JFBaseManagedObject *cloned = nil;
    if (alreadyCopied == NULL) {
        NSLog(@"alreadyCopied array is null");
        return nil;
    }else{
        cloned = [*alreadyCopied objectForKey:[self objectID]];
        // 如果已经拷贝过了那就直接返回，主要为了防止 父类<->子类的循环拷贝
        if (cloned){
            return cloned;
        }
        // 没有拷贝过，那就直接创建一个新的对象
        cloned = [[self class] insertNewObjectIntoContext:context];
        // 记录已经拷贝过的实体
        [*alreadyCopied setObject:cloned forKey:[self objectID]];
    }
    
    // 拿到key value 字典
    NSDictionary *attributes = [[self entity] attributesByName];
    
    for (NSString *attr in attributes) {
        [cloned setValue:[self valueForKey:attr] forKey:attr];
    }
    
    // 嵌套对象的key value
    NSDictionary *relationships = [[self entity] relationshipsByName];
    for (NSString *keyName in relationships.allKeys){
        NSRelationshipDescription *rel = relationships[keyName];
        // 不是一对多的话，直接赋值
        if (![rel isToMany]) {
            JFBaseManagedObject *relatedObject = [self valueForKey:keyName];
            if (relatedObject) {
                JFBaseManagedObject *clonedRelatedObject = [relatedObject cloneToContext:context withCopiedCache:alreadyCopied exludeEntities:namesOfEntitiesToExclude];
                if (clonedRelatedObject) {
                    [cloned setValue:clonedRelatedObject forKey:keyName];
                }
            }
            continue;
        }
        // 是否Ordered的判断，主要是mutableOrderedSetValueForKey和mutableSetValueForKey的区别
        if ([rel isOrdered]) {
            NSMutableOrderedSet *sourceSet = [self mutableOrderedSetValueForKey:keyName];
            NSMutableOrderedSet *clonedSet = [cloned mutableOrderedSetValueForKey:keyName];
            NSEnumerator *e = [sourceSet objectEnumerator];
            
            JFBaseManagedObject *relatedObject;
            while ( relatedObject = [e nextObject]){
                // Clone it, and add clone to set
                JFBaseManagedObject *clonedRelatedObject = [relatedObject cloneToContext:context withCopiedCache:alreadyCopied exludeEntities:namesOfEntitiesToExclude];
                
                if (clonedRelatedObject) {
                    [clonedSet addObject:clonedRelatedObject];
                }
            }
        }else{
            // 拿到对象集合
            NSMutableSet *sourceSet = [self mutableSetValueForKey:keyName];
            NSMutableSet *clonedSet = [cloned mutableSetValueForKey:keyName];
            NSEnumerator *e = [sourceSet objectEnumerator];
            
            JFBaseManagedObject *relatedObject = nil;
            while ( relatedObject = [e nextObject]){
                // 子对象进行克隆
                JFBaseManagedObject *clonedRelatedObject = [relatedObject cloneToContext:context withCopiedCache:alreadyCopied exludeEntities:namesOfEntitiesToExclude];

                if (clonedRelatedObject) {
                    [clonedSet addObject:clonedRelatedObject];
                }
            }
        }
    }
    
    return cloned;
}
@end
