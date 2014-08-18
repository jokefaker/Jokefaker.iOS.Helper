//
//  NSString+JSONCategory.m
//  Jokefaker.iOS.Helper.git
//
//  Created by 周国勇 on 8/18/14.
//  Copyright (c) 2014 jokefaker. All rights reserved.
//

#import "JSONCategory.h"

@implementation NSString (JSON)

- (id)objectFromJSONString
{
    NSError *error = nil;
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    id object = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    return object;
}

@end


@implementation NSArray (JSON)

- (NSString *)JSONString
{
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return string;
}

@end


@implementation NSDictionary (JSON)

+ (NSDictionary *)dictionaryWithContentOfJSONFile:(NSString *)path
{
    NSError *error = nil;
    NSString *content = [NSString stringWithContentsOfFile:path
                                                  encoding:NSUTF8StringEncoding
                                                     error:&error];
    return [content objectFromJSONString];
}

- (NSString *)JSONString
{
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return string;
}

@end
