//
//  MYAPILoader.h
//  NetworkFrame
//
//  Created by scj on 2019/8/7.
//  Copyright © 2019 scj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

NS_ASSUME_NONNULL_BEGIN

@class MYErrorModel;

extern NSString * InitKey;


@interface MYAPILoader : NSObject

@property (nonatomic,assign) BOOL needInitKey;

@property (nonatomic,assign) BOOL useMd5;

@property (nonatomic,readonly) AFHTTPRequestSerializer *requestSerializer;

- (instancetype)initWithBaseURL:(NSURL *)url;

- (NSURLSessionDataTask *)GET:(NSString *)strURL
                       params:(NSDictionary *)dicParams
                   resultType:(Class)modelClass
              completeHandler:(void(^)(id model, MYErrorModel *errorModel))completeHandler;

- (NSURLSessionDataTask *)POST:(NSString *)strURL
                        params:(NSDictionary *)dicParams
                    resultType:(Class)modelClass
               completeHandler:(void(^)(id model, MYErrorModel *errorModel))completeHandler;

- (NSURLSessionDataTask*)upload:(NSString*)strURL
                           data:(NSData*)data
                         params:(NSDictionary *)dicParams
                completeHandler:(void(^)(id model, MYErrorModel *errorModel))completeHandler;

- (NSURLSessionDataTask*)upload:(NSString*)strURL
                       imgFiles:(NSArray*)imgFiles
                         params:(NSDictionary *)dicParams
                completeHandler:(void(^)(id model, MYErrorModel *errorModel))completeHandler;
@end

NS_ASSUME_NONNULL_END

