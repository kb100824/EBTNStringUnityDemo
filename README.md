# 常用方法:比如获取手机网络类型、运营商等相关信息、URL编码解码、json序列化

#PS:有两种使用方法
<ul type="disc">
<li>方法1:请使用"EBTGlobalHandlerUnity"文件中的类方法</li>
<li>方法2:请使用"NSString+TJ_Unity"类别文件中的类方法</li>
</ul>  

#使用pod指令添加到项目中:
```
 pod 'EBTNStringUnity', '~> 1.0.2'
```
 ```
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
```
