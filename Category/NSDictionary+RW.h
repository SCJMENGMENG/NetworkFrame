//
//  NSDictionary+RW.h
//  RestartProject
//
//  Created by nododo on 2019/7/4.
//  Copyright © 2019 Reworld. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (RW)

- (BOOL)successState;

- (NSInteger)codeState;

- (NSString *)rw_message;

- (NSString *)urlString;

@end

NS_ASSUME_NONNULL_END
