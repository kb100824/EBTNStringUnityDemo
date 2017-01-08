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

//设备型号
#import <sys/utsname.h>
//md5
#include <CommonCrypto/CommonDigest.h>

//设备网络类型以及运营商
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>

//获取设备ip地址
#include <ifaddrs.h>
#include <arpa/inet.h>
#include <net/if.h>
#define IOS_CELLULAR    @"pdp_ip0"
#define IOS_WIFI        @"en0"
#define IOS_VPN         @"utun0"
#define IP_ADDR_IPv4    @"ipv4"
#define IP_ADDR_IPv6    @"ipv6"

//获取设备内存
#import <sys/sysctl.h>
#import <mach/mach.h>
//设备容量
#import <sys/mount.h>
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
#pragma mark - 当前设备分辨率
+ (NSString *)currentDeviceScreen{
    
    CGFloat scale_screen = 1;
    NSInteger width = SCREEN_WIDTH*scale_screen;
    NSInteger height= SCREEN_HEIGHT*scale_screen;
    NSString *deviceScreen = [NSString stringWithFormat:@"%ldx%ld",width,height];
    
    return deviceScreen;

}
#pragma mark - 当前设备运营商
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
#pragma mark - 当前设备网络类型
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
#pragma mark - MD5
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
#pragma mark - 当前设备IP地址
+ (NSString *)currentDeviceIPAddress_NetWorkIsIPV4:(BOOL)netWorkisIPV4
{
    NSArray *searchArray = netWorkisIPV4 ?
    @[ IOS_VPN @"/" IP_ADDR_IPv4, IOS_VPN @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6 ] :
    @[ IOS_VPN @"/" IP_ADDR_IPv6, IOS_VPN @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4 ] ;
    
    NSDictionary *addresses = getIPAddress();
    NSLog(@"addresses: %@", addresses);
    
    __block NSString *address;
    [searchArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop)
     {
         address = addresses[key];
         //筛选出IP地址格式
         if(validateIPAddress(address)) *stop = YES;
     } ];
    return address ? address : @"0.0.0.0";
}
//验证ip地址
static inline BOOL validateIPAddress(NSString *ipAddress){
    if (ipAddress.length == 0) {
        return NO;
    }
    NSString *urlRegEx = @"^([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\."
    "([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\."
    "([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\."
    "([01]?\\d\\d?|2[0-4]\\d|25[0-5])$";
    
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:urlRegEx options:0 error:&error];
    
    if (regex != nil) {
        NSTextCheckingResult *firstMatch=[regex firstMatchInString:ipAddress options:0 range:NSMakeRange(0, [ipAddress length])];
        
        if (firstMatch) {
            NSRange resultRange = [firstMatch rangeAtIndex:0];
            NSString *result=[ipAddress substringWithRange:resultRange];
            //输出结果
            NSLog(@"%@",result);
            return YES;
        }
    }
    return NO;

}

static inline NSDictionary * getIPAddress(){
    NSMutableDictionary *addresses = [NSMutableDictionary dictionaryWithCapacity:8];
    
    // retrieve the current interfaces - returns 0 on success
    struct ifaddrs *interfaces;
    if(!getifaddrs(&interfaces)) {
        // Loop through linked list of interfaces
        struct ifaddrs *interface;
        for(interface=interfaces; interface; interface=interface->ifa_next) {
            if(!(interface->ifa_flags & IFF_UP) /* || (interface->ifa_flags & IFF_LOOPBACK) */ ) {
                continue; // deeply nested code harder to read
            }
            const struct sockaddr_in *addr = (const struct sockaddr_in*)interface->ifa_addr;
            char addrBuf[ MAX(INET_ADDRSTRLEN, INET6_ADDRSTRLEN) ];
            if(addr && (addr->sin_family==AF_INET || addr->sin_family==AF_INET6)) {
                NSString *name = [NSString stringWithUTF8String:interface->ifa_name];
                NSString *type;
                if(addr->sin_family == AF_INET) {
                    if(inet_ntop(AF_INET, &addr->sin_addr, addrBuf, INET_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv4;
                    }
                } else {
                    const struct sockaddr_in6 *addr6 = (const struct sockaddr_in6*)interface->ifa_addr;
                    if(inet_ntop(AF_INET6, &addr6->sin6_addr, addrBuf, INET6_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv6;
                    }
                }
                if(type) {
                    NSString *key = [NSString stringWithFormat:@"%@/%@", name, type];
                    addresses[key] = [NSString stringWithUTF8String:addrBuf];
                }
            }
        }
        // Free memory
        freeifaddrs(interfaces);
    }
    return [addresses count] ? addresses : nil;

}

#pragma mark - 获取设备电量百分比以及充电状态

+ (NSString *)currentDeviceBatteryQuantityPercent{
  
    NSString *result = nil;
    if (![UIDevice currentDevice].batteryMonitoringEnabled) {
        //开启电池状态监视开关
        [UIDevice currentDevice].batteryMonitoringEnabled = YES;
    }
   
    CGFloat batteryLevelResult = [UIDevice currentDevice].batteryLevel;
    //-1表示未开启电池状态监视
    if (batteryLevelResult<0) {
        result = @"未开启电池状态监视";
    }else{
      
        result = [NSString stringWithFormat:@"%3.0f%%",batteryLevelResult*100];
    }
   
    return result;

}

+ (NSString *)currentDeviceBatteryQuantityState{
    
    NSString *resultState = nil;
    if (![UIDevice currentDevice].batteryMonitoringEnabled) {
        //开启电池状态监视开关
        [UIDevice currentDevice].batteryMonitoringEnabled = YES;
    }
    
    switch ([UIDevice currentDevice].batteryState) {
        case UIDeviceBatteryStateUnknown:
             resultState = @"无法读取电池状态";
            break;
        case UIDeviceBatteryStateUnplugged:
            resultState = @"未充电";
            break;
        case UIDeviceBatteryStateFull:
            resultState = @"充电已满";
            break;
        case UIDeviceBatteryStateCharging:
            resultState = @"充电中";
            break;
    }
    
    return resultState;
}

#pragma mark - 设备容量
// 获取当前设备可用内存
+(NSString *)currentDeviceAvailableMemory{
    
    return capacitySizeToString(availableMemory());
    
}
+ (NSString *)currentDeviceUserTakeUpMemory{
    return  capacitySizeToString(userTakeUpMemory());
}
// 获取当前设备可用内存
static inline double availableMemory(){
    vm_statistics_data_t vmStats;
    mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;
    kern_return_t kernReturn = host_statistics(mach_host_self(),
                                               HOST_VM_INFO,
                                               (host_info_t)&vmStats,
                                               &infoCount);
    
    if (kernReturn != KERN_SUCCESS) {
        return NSNotFound;
    }
    
    return (vm_page_size *vmStats.free_count) ;
}

// 获取当前任务所占用的内存
static inline double userTakeUpMemory()
{
    task_basic_info_data_t taskInfo;
    mach_msg_type_number_t infoCount = TASK_BASIC_INFO_COUNT;
    kern_return_t kernReturn = task_info(mach_task_self(),
                                         TASK_BASIC_INFO,
                                         (task_info_t)&taskInfo,
                                         &infoCount);
    
    if (kernReturn != KERN_SUCCESS
        ) {
        return NSNotFound;
    }
    
    return taskInfo.resident_size;
}

+ (NSString *)currentDeviceTotalCapacitySize{
    
    return capacitySizeToString(getTotalCapacitySize());
}
//获取总磁盘容量
static inline long long getTotalCapacitySize (){
    struct statfs buf;
    unsigned long long freeSpace = -1;
    if (statfs("/var", &buf) >= 0)
    {
        freeSpace = (unsigned long long)(buf.f_bsize * buf.f_blocks);
    }
    return freeSpace;
    
}
+  (NSString *)currentDeviceAvailableCapacitySize{
    return capacitySizeToString(getAvailableCapacitySize());
}
//获取可用磁盘容量
static inline long long getAvailableCapacitySize(){
    struct statfs buf;
    unsigned long long freeSpace = -1;
    if (statfs("/var", &buf) >= 0)
    {
        freeSpace = (unsigned long long)(buf.f_bsize * buf.f_bavail);
    }
    return freeSpace;
}

//容量转换
static inline NSString * capacitySizeToString(unsigned long long  capacitySize){
    NSInteger KB = 1024;
    NSInteger MB = KB*KB;
    NSInteger GB = MB*KB;
    
    if (capacitySize < 10)  {
        return @"0 B";
    }else if (capacitySize < KB)    {
        return @"< 1 KB";
    }else if (capacitySize < MB)    {
        return [NSString stringWithFormat:@"%.1f KB",((CGFloat)capacitySize)/KB];
    }else if (capacitySize < GB)    {
        return [NSString stringWithFormat:@"%.1f MB",((CGFloat)capacitySize)/MB];
    }else   {
        return [NSString stringWithFormat:@"%.1f GB",((CGFloat)capacitySize)/GB];
    }
    
}

@end
