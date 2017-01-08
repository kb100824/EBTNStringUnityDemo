//
//  EBTNSStringUnityGlobalHandler.h
//  EBTNStringUnityDemo
//
//  Created by ebaotong on 2017/1/6.
//  Copyright © 2017年 com.csst. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EBTGlobalHandlerUnity : NSObject


/**
 *  字符串反序列化转为json对象
 *
 *  @param jsonString json字符串
 *
 *  @return 返回id对象
 */
+ (instancetype)jsonObjectTransformToJsonString:(NSString *)jsonString;


/**
 * json序列化转为字符串
 *
 *  @param jsonObject json对象
 *
 *  @return 返回json字符串
 */
+ (NSString *)jsonStringTransformToJsonObject:(id)jsonObject;


/**
 *  url进行encode编码
 *
 *  @param originURLString 原始的字符串
 *
 *  @return 返回编码后字符串
 */

+ (NSString *)enCodeOriginURLString:(NSString *)originURLString;



/**
 *  url进行decode解码
 *
 *  @param encodedURLString 编码的字符串
 *
 *  @return 返回解码后的url
 */

+ (NSString *)decodeString:(NSString *)encodedURLString;


/**
 *   获取当前设备的型号
 *  @return 设备型号
 */

+ (NSString *)currentDeviceModelName;


/**
 *   获取当前设备的分辨率
 *  @return 分辨率
 */

+ (NSString *)currentDeviceScreen;


/**
 *   获取当前设备的运营商信息
 *  @return 返回电\信移\动联通
 */

+ (NSString *)currentDeviceIMSIType;


/**
 *   获取当前设备的网络类型2g 3g 4g等等
 *  @return 返回网络类型
 */
+ (NSString *)currentDeviceNetWorkType;


/**
 *  对字符串进行MD5加密
 *
 *  @param encryptString 要加密的字符串
 *
 *  @return md5加密后的字符串
 */
+ (NSString *)EncryptionMD5:(NSString *)encryptString;


/**
 *  获取设备的ip地址
 *
 *  @param netWorkisIPV4 ipv4还是ipv6
 *
 *  @return ip地址
 */

+ (NSString *)currentDeviceIPAddress_NetWorkIsIPV4:(BOOL)netWorkisIPV4;

/**
 *  获取设备电池百分比
 *  @return 电池百分比
 */

+ (NSString *)currentDeviceBatteryQuantityPercent;

/**
 *  获取设备充电状态
 *  @return 充电状态
 */

+ (NSString *)currentDeviceBatteryQuantityState;






@end
