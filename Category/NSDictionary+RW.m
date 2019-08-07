//
//  NSDictionary+RW.m
//  RestartProject
//
//  Created by nododo on 2019/7/4.
//  Copyright © 2019 Reworld. All rights reserved.
//

#import "NSDictionary+RW.h"

@implementation NSDictionary (RW)

- (BOOL)successState {
    return ([self[@"code"] integerValue] == 1);
}

- (NSInteger)codeState {
    return [self[@"code"] integerValue];
}

- (NSString *)rw_message {
    return self[@"message"];
}

- (NSString *)urlString {
    NSMutableArray *parts = [NSMutableArray array];
    for (NSString *key in self) {
        NSString *value = [self objectForKey: key];
        NSString *part = [NSString stringWithFormat: @"%@=%@", [key stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], [value stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        [parts addObject: part];
    }
    return [parts componentsJoinedByString: @"&"];
}
@end
