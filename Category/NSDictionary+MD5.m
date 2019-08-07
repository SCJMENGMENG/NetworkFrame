//
//  NSDictionary+MD5.m
//  RestartProject
//
//  Created by scj on 2019/6/28.
//  Copyright © 2019 Reworld. All rights reserved.
//

#import "NSDictionary+MD5.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSDictionary (MD5)

- (NSDictionary *)md5CodeSignWithKey:(NSString *)key {
    
    key = InitKey;
    
    NSMutableDictionary *dict = [self mutableCopy];
    
    NSArray *allKeyArray = [dict allKeys];
    NSArray *afterSortKeyArray = [allKeyArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSComparisonResult resuest = [obj1 compare:obj2];
        return resuest;
    }];
    
    NSMutableArray *valueArray = [NSMutableArray array];
    for (NSString *sortsing in afterSortKeyArray) {
        NSString *valueString = [NSString stringWithFormat:@"%@=%@",sortsing,[dict objectForKey:sortsing]];
        [valueArray addObject:valueString];
    }
    
    NSMutableString *signString = [NSMutableString string];
    for (int i = 0; i < afterSortKeyArray.count; i++) {
        NSString *keyValue = [NSString stringWithFormat:@"%@&",valueArray[i]];
        [signString appendString:keyValue];
    }
    
    [signString appendString:key];
    dict[@"sign"] = [signString md5Hash];
    
    return dict;
}

@end
