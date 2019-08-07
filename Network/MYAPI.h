//
//  MYAPI.h
//  NetworkFrame
//
//  Created by scj on 2019/8/7.
//  Copyright © 2019 scj. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MYAPILoader.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

typedef NS_ENUM(NSInteger, MYAPIEnv) {
    kRWHTTPAPIProduction = 0,
    kRWHTTPAPIStaging,
    kRWHTTPAPITest,
    kRWHTTPAPIDev,
};

@interface MYAPIResult<__covariant ObjectType> : NSObject
@property (nonatomic,strong) ObjectType model;
@property (nonatomic,strong) MYErrorModel *errorModel;
@end
typedef void(^MYAPICompleteHandler)(id model, MYErrorModel *errorModel);

@interface MYAPI <__covariant ObjectType> : NSObject

@property(class) MYAPIEnv env;

@property(class,readonly) NSArray<NSString*>* urls;

@property(class,readonly) NSString* baseURL;

@property(readonly) MYAPI *withoutXFormContentType;

@property(readonly) MYAPI *allowNoInitKey;

@property(readonly) MYAPI *withoutPublicParams;

@property(readonly) MYAPI *withoutMD5;

@property(readonly) MYAPILoader* loader;

@property(readonly) Class modelClass;


- (instancetype)initWithModelClass:(Class)clazz;

- (void)get:(NSString*)path
 completion:(void(^)(ObjectType model, MYErrorModel *errorModel))handler;

- (void)post:(NSString*)path
  completion:(void(^)(ObjectType model, MYErrorModel *errorModel))handler;

- (void)get:(NSString*)path
     params:(NSDictionary*)params
 completion:(void(^)(ObjectType model, MYErrorModel *errorModel))handler;

- (void)post:(NSString*)path
      params:(NSDictionary*)params
  completion:(void(^)(ObjectType model, MYErrorModel *errorModel))handler;

- (void)postUpload:(NSString*)path
          imgFiles:(NSArray*)imgFiles
            params:(NSDictionary*)params
        completion:(void(^)(ObjectType model, MYErrorModel *errorModel))handler;

- (RACSignal*)rac_get:(NSString*)path
               params:(NSDictionary*)params;

- (RACSignal*)rac_post:(NSString*)path
                params:(NSDictionary*)params;

@end

#define api_subclass(api_type) @interface MYAPI##api_type<__covariant ObjectType> : MYAPI\
- (void)get:(NSString*)path completion:(void(^)(ObjectType model, MYErrorModel *errorModel))handler;\
- (void)post:(NSString*)path completion:(void(^)(ObjectType model, MYErrorModel *errorModel))handler;\
- (void)get:(NSString*)path params:(NSDictionary*)params  completion:(void(^)(ObjectType model, MYErrorModel *errorModel))handler;\
- (void)post:(NSString*)path params:(NSDictionary*)params completion:(void(^)(ObjectType model, MYErrorModel *errorModel))handler;\
- (RACSignal*)rac_get:(NSString*)path params:(NSDictionary*)params;\
- (RACSignal*)rac_post:(NSString*)path params:(NSDictionary*)params;\
@end

#define api_subclass_imp(api_type,url1,url2,url3,url4) @implementation MYAPI##api_type\
+ (NSArray<NSString *> *)urls {\
return @[url1,url2,url3,url4];\
}\
@end

#define BaseAPI(model_type) [[MYAPI<model_type*> alloc] initWithModelClass:[model_type class]]
#define AccountAPI(model_type) [[MYAPIAccount<model_type*> alloc] initWithModelClass:[model_type class]]


