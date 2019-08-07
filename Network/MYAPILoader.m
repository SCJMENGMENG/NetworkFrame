//
//  MYAPILoader.m
//  NetworkFrame
//
//  Created by scj on 2019/8/7.
//  Copyright © 2019 scj. All rights reserved.
//

#import "MYAPILoader.h"
#import "MYAPI.h"

NSString * InitKey = nil;

@interface _MYAPILoader: AFHTTPSessionManager

@property (nonatomic,assign) BOOL needInitKey;
@property (nonatomic,assign) BOOL useMd5;

@end


@implementation _MYAPILoader

- (instancetype)initWithBaseURL:(NSURL *)url {
    //    NSURLSessionConfiguration *conf = NSURLSessionConfiguration.defaultSessionConfiguration;
    //    conf.protocolClasses = @[NSClassFromString(@"NEURLProtocol")];
    if (self = [super initWithBaseURL:url]) {
        NSSet *typeSet = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", @"text/xml", @"video/mp2t", @"suggestion/json", @"application/zip", nil];
        self.responseSerializer = [AFHTTPResponseSerializer serializer];
        self.responseSerializer.acceptableContentTypes = typeSet;
        self.requestSerializer.timeoutInterval = 10.0f;
        [self.requestSerializer setValue:@"application/a-ccc-dddd-asdasda" forHTTPHeaderField:@"Content-Type"];
        AFSecurityPolicy *policy = [AFSecurityPolicy defaultPolicy];
        policy.allowInvalidCertificates = YES;
        policy.validatesDomainName = NO;
        self.securityPolicy = policy;
        self.needInitKey = YES;
    }
    return self;
}

- (NSDictionary *)processParam:(NSDictionary *)param {
    if (self.needInitKey && InitKey != nil) {
        return [param md5CodeSignWithKey:InitKey];
    }
    else
    {
        return param;
    }
}

- (NSURLSessionDataTask *)GET:(NSString *)strURL params:(NSDictionary *)dicParams resultType:(Class)modelClass completeHandler:(void(^)(id model, MYErrorModel *errorModel))completeHandler {
    if (InitKey == nil && self.needInitKey == YES) {
        [self processInitKey:^{
            [self GetWithURLString:strURL Params:[self processParam:dicParams] ResultModelClass:modelClass CompleteHandler:completeHandler];
        }];
        return nil;
    }
    return [self GetWithURLString:strURL Params:[self processParam:dicParams] ResultModelClass:modelClass CompleteHandler:completeHandler];
}

- (NSURLSessionDataTask *)POST:(NSString *)strURL params:(NSDictionary *)dicParams resultType:(Class)modelClass completeHandler:(void(^)(id model, MYErrorModel *errorModel))completeHandler {
    if (InitKey == nil && self.needInitKey == YES) {
        [self processInitKey:^{
            [self PostWithURLString:strURL Params:[self processParam:dicParams] ResultModelClass:modelClass CompleteHandler:completeHandler];
        }];
        return nil;
    }
    return [self PostWithURLString:strURL Params:[self processParam:dicParams] ResultModelClass:modelClass CompleteHandler:completeHandler];
}

- (NSURLSessionDataTask *)upload:(NSString *)strURL data:(NSData*)data params:(NSDictionary *)dicParams completeHandler:(void (^)(id, MYErrorModel *))completeHandler {
    
    return [self POST:strURL parameters:[self processParam:dicParams] constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:data name:@"image" fileName:@"file.png" mimeType:@"image/jpeg"];
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //        [self printLogWithURLString:strURL params:dicParams responseObject:responseObject error:nil];
        [self successWithRespData:responseObject resultModelClass:(NSDictionary.class) task:task completeHandler:completeHandler];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self printLogWithURLString:strURL params:dicParams responseObject:nil error:error];
        [self failureWithError:error task:task completeHandler:completeHandler];
    }];
}

- (NSURLSessionDataTask*)upload:(NSString*)strURL imgFiles:(NSArray*)imgFiles params:(NSDictionary *)dicParams completeHandler:(void(^)(id model, MYErrorModel *errorModel))completeHandler{
    
    return [self POST:strURL parameters:[self processParam:dicParams] constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (int i = 0; i<imgFiles.count; i++) {
            NSData *data = imgFiles[i][@"data"];
            NSString *imageFile = imgFiles[i][@"imageFile"];
            [formData appendPartWithFileData:data name:imageFile fileName:@"file.jpg" mimeType:@"image/jpeg"];
        }
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [self successWithRespData:responseObject resultModelClass:(NSDictionary.class) task:task completeHandler:completeHandler];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self printLogWithURLString:strURL params:dicParams responseObject:nil error:error];
        [self failureWithError:error task:task completeHandler:completeHandler];
    }];
}

#pragma mark - HTTP Get, Post

- (NSURLSessionDataTask *)GetWithURLString:(NSString *)strURL
                                    Params:(NSDictionary *)dicParams
                          ResultModelClass:(Class)modelClass
                           CompleteHandler:(void(^)(id model, MYErrorModel *errorModel))completeHandler {
    return [self GET:strURL parameters:dicParams progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
#if XCODE_USER != 8001
        [self printLogWithURLString:strURL params:dicParams responseObject:responseObject error:nil];
#endif
        [self successWithRespData:responseObject resultModelClass:modelClass task:task completeHandler:completeHandler];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self printLogWithURLString:strURL params:dicParams responseObject:nil error:error];
        [self failureWithError:error task:task completeHandler:completeHandler];
    }];
    
}

- (NSURLSessionDataTask *)PostWithURLString:(NSString *)strURL
                                     Params:(NSDictionary *)dicParams
                           ResultModelClass:(Class)modelClass
                            CompleteHandler:(void(^)(id model, MYErrorModel *errorModel))completeHandler {
    return [self POST:strURL parameters:dicParams progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
#if XCODE_USER != 8001
        [self printLogWithURLString:strURL params:dicParams responseObject:responseObject error:nil];
#endif
        [self successWithRespData:responseObject resultModelClass:modelClass task:task completeHandler:completeHandler];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self printLogWithURLString:strURL params:dicParams responseObject:nil error:error];
        [self failureWithError:error task:task completeHandler:completeHandler];
    }];
}

- (void)processInitKey:(void(^)(void))completion {
    NSString *strURL = [MYAPIAccount.baseURL stringByAppendingString:kInitURL];;
    NSDictionary *params = InitParams();
    [self POST:strURL parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        if (![dic isKindOfClass:[NSDictionary class]]) {
            return;
        }
        InitKey = dic[@"key"];
        if (completion) {
            completion();
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (completion) {
            completion();
        }
    }];
}

#pragma mark  HTTP Result Handler

- (void)successWithRespData:(id)responseObj resultModelClass:(Class)modelClass task:(NSURLSessionDataTask *)task completeHandler:(void(^)(id model, MYErrorModel *errorModel))completeHandler {
#if XCODE_USER != 8001
    NSLog(@"Request URL: %@", [task.currentRequest.URL absoluteString]);
#endif
    
    if (!completeHandler) {
        return;
    }
    if ([responseObj conformsToProtocol:@protocol(OS_dispatch_data)] && [modelClass isSubclassOfClass:[NSData class]]) {
        completeHandler(responseObj, nil);
        return;
    }
    MYErrorModel *errorModel = [[MYErrorModel alloc] init];
    if (![responseObj isKindOfClass:[NSData class]]) {
        errorModel.message = @"responseObj 无法解析";
        completeHandler(nil,errorModel);
        return;
    }
    
    if ([[[modelClass alloc] init] isKindOfClass:[NSString class]]) {
        NSString *str = [[NSString alloc] initWithData:responseObj encoding:NSUTF8StringEncoding];
        completeHandler(str,nil);
        return;
    }
    
    id jsonObj = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableContainers error:nil];
    if (jsonObj == nil) {
        errorModel.message = @"responseObj 不是字典或数组";
        completeHandler(nil,errorModel);
        return;
    }
    
#if XCODE_USER != 8001
    NSLog(@"responseObj: %@", [jsonObj description]);
#endif
    
    if (![jsonObj isKindOfClass:[NSDictionary class]]) {
        errorModel.message = @"responseObj 不是字典类型";
        completeHandler(nil,errorModel);
        return;
    }
    
    NSDictionary *responseDic = jsonObj;
    
    if (responseDic.codeState == 25013) {
        errorModel.message = @"账户被踢了";
        completeHandler(nil,nil);
        [self showKickedAlert];
        return;
    }
    
    if (![[[modelClass alloc] init] isKindOfClass:[MYBaseModel class]]) {
        completeHandler(jsonObj,nil);
        return;
    }
    
    if (responseDic.successState) {
        NSDictionary *dicDest = [jsonObj copy];
        if ([dicDest[@"data"] isKindOfClass:[NSDictionary class]]) {
            dicDest = responseDic[@"data"];
        }
        MYBaseModel *model = [modelClass mj_objectWithKeyValues:dicDest];
        completeHandler(model, nil);
    }
    else {
        MYErrorModel *errorModel = [MYErrorModel mj_objectWithKeyValues:responseDic];
        completeHandler(nil, errorModel);
    }
}


- (void)failureWithError:(NSError *)error task:(NSURLSessionDataTask *)task completeHandler:(void(^)(id model, MYErrorModel *errorModel))completeHandler {
    MYErrorModel *errorModel = [[MYErrorModel alloc] init];
    errorModel.message = @"网络请求失败";
    errorModel.code = error.code;
    if (completeHandler) {
        completeHandler(nil, errorModel);
    }
}

#pragma mrak - Helper

- (void)printLogWithURLString:(NSString *)strURLString params:(NSDictionary *)dicParams responseObject:(id)respObj error:(NSError *)error {
    NSURL *url = [NSURL URLWithString:strURLString relativeToURL:self.baseURL];
    if (error) {
        NSLog(@"Request URL: %@", url.absoluteString);
        NSLog(@"Params: %@", dicParams);
        NSLog(@"Error: %@", error);
    }
}

- (void)showKickedAlert {
    NSLog(@"当前账号已被登出，若非本人操作，请重新登录并修改密码");
}

@end

@implementation MYAPILoader

{
    _MYAPILoader *loader;
}

- (instancetype)initWithBaseURL:(NSURL *)url {
    if (self = [super init]) {
        loader = [[_MYAPILoader alloc] initWithBaseURL:url];
    }
    return self;
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    return loader;
}

- (void)setNeedInitKey:(BOOL)needInitKey {
    loader.needInitKey = needInitKey;
}

- (BOOL)needInitKey {
    return loader.needInitKey;
}

- (void)setUseMd5:(BOOL)useMd5 {
    loader.useMd5 = useMd5;
}
@end

