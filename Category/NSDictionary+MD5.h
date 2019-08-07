//
//  NSDictionary+MD5.h
//  RestartProject
//
//  Created by scj on 2019/6/28.
//  Copyright © 2019 Reworld. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (MD5)

/// 返回结果：@{...,@"sign":@"加密字符串"} 加密字符串：参数升序 key=value&key=value&...&全局key
- (NSDictionary *)md5CodeSignWithKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
