//
//  EBTNSStringUnityGlobalHandler.m
//  EBTNStringUnityDemo
//
//  Created by ebaotong on 2017/1/6.
//  Copyright © 2017年 com.csst. All rights reserved.
//

//主屏宽
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
//主屏高
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

#import <UIKit/UIKit.h>
#import "EBTGlobalHandlerUnity.h"
#import <sys/utsname.h>
#include <CommonCrypto/CommonDigest.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>


@interface EBTGlobalHandlerUnity ()

@end
@implementation EBTGlobalHandlerUnity

+ (EBTGlobalHandlerUnity *)shareInstance{

    static EBTGlobalHandlerUnity *handlerUnity = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        handlerUnity = [[EBTGlobalHandlerUnity alloc]init];
    });
    return  handlerUnity;
}

#pragma mark - json序列化
+ (instancetype)jsonObjectTransformToJsonString:(NSString *)jsonString{
    NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    id resultObject = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    return resultObject;

}
+ (NSString *)jsonStringTransformToJsonObject:(id)jsonObject{

    NSData *data = [NSJSONSerialization dataWithJSONObject:jsonObject options:NSJSONWritingPrettyPrinted error:nil];
    NSString *resultStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return  resultStr;
}

#pragma mark - URL编码解码
+ (NSString *)enCodeOriginURLString:(NSString *)originURLString{
    
    NSString *newString = (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(
                                                                                                kCFAllocatorDefault, (__bridge CFStringRef)originURLString, NULL, CFSTR(":/?#[]@!$ &'()*+,;=\"<>%{}|\\^~`"), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    
    if (newString)
    {
        return newString;
    }
    
    return @"";

}
+ (NSString *)decodeString:(NSString *)encodedURLString{
    
    NSString *decodedString  = (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,
                                                                                                                     (__bridge CFStringRef)encodedURLString,
                                                                                                                     CFSTR(""),
                                                                                                                     CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    return decodedString;

}
#pragma mark - 当前设备相关信息

+ (NSString *)currentDeviceModelName{
    
    
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceModel = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    if ([deviceModel isEqualToString:@"iPhone4,1"]) {
        return @"iPhone 4S";
    }
    if ([deviceModel isEqualToString:@"iPhone5,1"]){
        return @"iPhone 5";
    }
    if ([deviceModel isEqualToString:@"iPhone5,2"]){
        return @"iPhone 5";
    }
    if ([deviceModel isEqualToString:@"iPhone5,3"]){
        return @"iPhone 5C";
    }
    if ([deviceModel isEqualToString:@"iPhone5,4"]){
        return @"iPhone 5C";
    }
    if ([deviceModel isEqualToString:@"iPhone6,1"]){
        return @"iPhone 5S";
    }
    if ([deviceModel isEqualToString:@"iPhone6,2"]){
        return @"iPhone 5S";
    }
    if ([deviceModel isEqualToString:@"iPhone7,1"]){
        return @"iPhone 6 Plus";
    }
    if ([deviceModel isEqualToString:@"iPhone7,2"]){
        return @"iPhone 6";
    }
    if ([deviceModel isEqualToString:@"iPhone8,1"]){
        return @"iPhone 6s";
    }
    if ([deviceModel isEqualToString:@"iPhone8,2"]){
        return @"iPhone 6s Plus";
    }
    if ([deviceModel isEqualToString:@"iPhone9,1"]){
        return @"iPhone 7 (CDMA)";
    }
    if ([deviceModel isEqualToString:@"iPhone9,3"]){
        return @"iPhone 7 (GSM)";
    }
    if ([deviceModel isEqualToString:@"iPhone9,2"]){
        return @"iPhone 7 Plus (CDMA)";
    }
    if ([deviceModel isEqualToString:@"iPhone9,4"]){
        return @"iPhone 7 Plus (GSM)";
    }
    else{
        
        return @"";
    }

    
    
}

+ (NSString *)currentDeviceScreen{
    
    CGFloat scale_screen = 1;
    NSInteger width = SCREEN_WIDTH*scale_screen;
    NSInteger height= SCREEN_HEIGHT*scale_screen;
    NSString *deviceScreen = [NSString stringWithFormat:@"%lux%lu",width,height];
    
    return deviceScreen;

}

+ (NSString *)currentDeviceIMSIType{
    NSString *mobileImsiType = @"";
    CTTelephonyNetworkInfo *netWorkInfo = [CTTelephonyNetworkInfo new];
    CTCarrier *carrier = [netWorkInfo subscriberCellularProvider];
    if (!carrier.isoCountryCode) {
        mobileImsiType = @"没有插入SIM卡";
    }else{
        mobileImsiType = [carrier carrierName];
    }
    
    return mobileImsiType;

}

+ (NSString *)currentDeviceNetWorkType{
    NSArray *statusSubViews = [[[[UIApplication sharedApplication] valueForKey:@"statusBar"] valueForKey:@"foregroundView"]subviews];
    
    NSNumber *dataNetworkItemView = nil;
    
    for (id subView in statusSubViews) {
        
        if([subView isKindOfClass:[NSClassFromString(@"UIStatusBarDataNetworkItemView") class]]) {
            dataNetworkItemView = subView;
            break;
        }
        
    }
    NSString *netWorkType = @"";
    switch ([[dataNetworkItemView valueForKey:@"dataNetworkType"]integerValue]) {
        case 0:
            netWorkType = @"无网络连接";
            break;
        case 1:
            netWorkType = @"2G";
            break;
        case 2:
            netWorkType = @"2G";
            break;
        case 3:
            netWorkType = @"3G";
            break;
        case 4:
            netWorkType = @"4G/LTE";
            break;
        case 5:
            netWorkType = @"WIFI";
            break;
        default:
            netWorkType = @"";
            break;
    }
    
    return netWorkType;
}

+ (NSString *)EncryptionMD5:(NSString *)encryptString{

    const char* input = [encryptString UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(input, (CC_LONG)strlen(input), result);
    
    NSMutableString *digest = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (NSInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [digest appendFormat:@"%02x", result[i]];
    }
    
    return digest;

}




@end
