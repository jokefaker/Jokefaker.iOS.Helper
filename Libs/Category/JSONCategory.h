//
//  NSString+JSONCategory.h
//  Jokefaker.iOS.Helper.git
//
//  Created by 周国勇 on 8/18/14.
//  Copyright (c) 2014 jokefaker. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (JSON)

- (id)objectFromJSONString;

@end

@interface NSArray (JSON)

- (NSString *)JSONString;

@end

@interface NSDictionary (JSON)

+ (NSDictionary *)dictionaryWithContentOfJSONFile:(NSString *)path;
- (NSString *)JSONString;

@end