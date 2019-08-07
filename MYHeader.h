//
//  MYHeader.h
//  NetworkFrame
//
//  Created by scj on 2019/8/7.
//  Copyright © 2019 scj. All rights reserved.
//

#ifndef MYHeader_h
#define MYHeader_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 adId = 8001;
 appVer = "2.0.0";
 deviceId = "A164B2E6-2253-440F-9941-1A6A36EE715D";
 deviceName = "iPhone 6s Plus";
 lang = "zh_CN";
 osType = 02;
 osVer = "12.3";
 sign = DFB052352ECD16EA5F9747CE81178C40;
 token = 1565095065019TzitO;
 */

/**
 @"adId":@"AdID",
 @"appVer":@"AppVersion",
 @"osType":@"OSTypeName",
 @"osVer":@"OSVersion",
 @"deviceName":@"getDeviceType",
 @"deviceId":@"kDeviceID",
 @"lang":@"getDeviceLanguageCode",
 */

static inline NSDictionary *PublicParams() {
    NSMutableDictionary *param = [NSMutableDictionary new];
    param[@"deviceId"] = @"A164B2E6-2253-440F-9941-1A6A36EE715D";
    param[@"token"] = @"1565095065019TzitO";
    NSDictionary *initDic = @{
                              @"adId":@"8001",
                              @"appVer":@"2.0.0",
                              @"osType":@"02",
                              @"osVer":@"12.3",
                              @"deviceName":@"iPhone 6s Plus",
                              @"deviceId":@"A164B2E6-2253-440F-9941-1A6A36EE715D",
                              @"lang":@"zh_CN",
                              };
    [param addEntriesFromDictionary:initDic];
    return param;
}

static inline NSDictionary *InitParams() {
    NSDictionary *params = @{
                             @"adId":@"AdID",
                             @"appVer":@"AppVersion",
                             @"osType":@"OSTypeName",
                             @"osVer":@"OSVersion",
                             @"deviceName":@"getDeviceType",
                             @"deviceId":@"kDeviceID",
                             @"lang":@"getDeviceLanguageCode",
                             };
    return params;
}

#endif /* MYHeader_h */
