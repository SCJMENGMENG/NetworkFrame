//
//  MYBaseModel.m
//  NetworkFrame
//
//  Created by scj on 2019/8/7.
//  Copyright © 2019 scj. All rights reserved.
//

#import "MYBaseModel.h"

@implementation MYBaseModel

MJExtensionCodingImplementation

- (void)setValue:(id)value forKey:(NSString *)key {
    if (value == NSNull.null) {
        value = nil;
    }
    [super setValue:value forKey:key];
}

- (BOOL)save {
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [docPath stringByAppendingPathComponent:NSStringFromClass(self.class)];
    return [NSKeyedArchiver archiveRootObject:self toFile:filePath];
}

+ (BOOL)clear {
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [docPath stringByAppendingPathComponent:NSStringFromClass(self.class)];
    NSFileManager *fileManage = [NSFileManager defaultManager];
    NSError *error = NULL;
    if ([fileManage fileExistsAtPath:filePath] == YES) {
        return [fileManage removeItemAtPath:filePath error:&error];
    }
    return YES;
}

+ (instancetype)load {
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [docPath stringByAppendingPathComponent:NSStringFromClass(self.class)];
    id obj = nil;
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        obj = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
        if (obj == nil) {
            obj = [[self alloc] init];
        }
        return obj;
    }
    else {
        if (obj == nil) {
            obj = [[self alloc] init];
        }
        return obj;
    }
}
@end

@implementation MYErrorModel

@end
