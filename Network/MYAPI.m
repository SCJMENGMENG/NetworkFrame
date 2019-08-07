//
//  MYAPI.m
//  NetworkFrame
//
//  Created by scj on 2019/8/7.
//  Copyright © 2019 scj. All rights reserved.
//

#import "MYAPI.h"

/**
 1. dev环境：           涉及到前后端功能开发时，前后端联调的环境，使用网络是公司内网；
 2. test环境：          只是前端做开发，部分后端无改动时可以在此环境测试，使用网络是外部网络；
 3. staging环境：       正式上线前，公司自测确认产品功能，使用网络是外部网络；
 4. production环境：    正式线上环境，使用网络是外部网络；
 */
@implementation MYAPI  {
    BOOL _addPublicParams;
    BOOL _allowNoInitKey;
    BOOL _useMd5;
}

- (instancetype)initWithModelClass:(Class)clazz {
    if (self = [super init]) {
        _addPublicParams = YES;
        _allowNoInitKey = NO;
        _useMd5 = YES;
        _modelClass = clazz;
    }
    return self;
}

+ (void)setEnv:(MYAPIEnv)env {
    
}

+ (MYAPIEnv)env {
#ifdef DEBUG
    //修改环境修改下面的代码即可👇👇👇👇👇👇
    return kRWHTTPAPIProduction;
#endif
    return kRWHTTPAPIProduction;
}


+ (NSArray<NSString *> *)urls {
    return nil;
}

+ (NSString *)baseURL {
    return self.urls[self.env];
}

- (MYAPI *)withoutXFormContentType {
    [self.loader.requestSerializer setValue:nil forHTTPHeaderField:@"Content-Type"];
    return self;
}

- (MYAPI *)withoutPublicParams {
    _addPublicParams = NO;
    return self;
}

- (MYAPI *)allowNoInitKey {
    _allowNoInitKey = YES;
    return self;
}

- (MYAPI *)withoutMD5 {
    _useMd5 = NO;
    return self;
}

- (NSDictionary *)processParams:(NSDictionary *)params {
    NSMutableDictionary *dic = (params ?: @{}).mutableCopy;
    if (_addPublicParams) {
        [dic addEntriesFromDictionary:PublicParams()];
    }
    return dic;
}

- (NSString*)processPath:(NSString*)path {
    if (![path isKindOfClass:NSString.class]) {
        return @"";
    }
    NSString *strPath = path;
    
    return strPath ?: @"";
}

- (MYAPILoader *)loader {
    NSURL *baseURL = [NSURL URLWithString:[self class].baseURL];
    MYAPILoader *loader = [[MYAPILoader alloc] initWithBaseURL:baseURL];
    if (_allowNoInitKey) {
        loader.needInitKey = NO;
    }
    if (_useMd5) {
        loader.useMd5 = YES;
    }
    return loader;
}

- (void)get:(NSString *)path params:(NSDictionary *)params completion:(MYAPICompleteHandler)handler {
    
    NSDictionary *dic = [self processParams:params];
    [self.loader GET:[self processPath:path] params:dic resultType:self.modelClass completeHandler:handler];
}

- (void)post:(NSString *)path params:(NSDictionary *)params completion:(MYAPICompleteHandler)handler {
    
    NSDictionary *dic = [self processParams:params];
    [self.loader POST:[self processPath:path] params:dic resultType:self.modelClass completeHandler:handler];
}

- (void)postUpload:(NSString *)path imgFiles:(NSArray *)imgFiles params:(NSDictionary *)params completion:(void (^)(id, MYErrorModel *))handler {
    
    NSDictionary *dic = [self processParams:params];
    [self.loader upload:[self processPath:path] imgFiles:imgFiles params:dic completeHandler:handler];
}

- (void)get:(NSString *)path completion:(MYAPICompleteHandler)handler {
    [self get:path params:nil completion:handler];
}

- (void)post:(NSString *)path completion:(MYAPICompleteHandler)handler {
    [self post:path params:nil completion:handler];
}

- (RACSignal*)rac_get:(NSString*)path
               params:(NSDictionary*)params {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [self get:path params:params completion:^(id model, MYErrorModel *errorModel) {
            [subscriber sendNext:model];
            [subscriber sendCompleted];
        }];
        return nil;
    }];
}

- (RACSignal*)rac_post:(NSString*)path
                params:(NSDictionary*)params {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [self post:path params:params completion:^(id model, MYErrorModel *errorModel) {
            [subscriber sendNext:model];
            [subscriber sendCompleted];
        }];
        return nil;
    }];
}

@end

@implementation MYAPIResult

@end
