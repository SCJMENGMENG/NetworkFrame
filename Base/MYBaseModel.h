//
//  MYBaseModel.h
//  NetworkFrame
//
//  Created by scj on 2019/8/7.
//  Copyright © 2019 scj. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MYBaseModel : NSObject

- (BOOL)save;

+ (BOOL)clear;

+ (instancetype)load;

@end


@interface MYErrorModel : NSObject

@property (nonatomic, assign) NSInteger code;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) id result;

@end

NS_ASSUME_NONNULL_END
