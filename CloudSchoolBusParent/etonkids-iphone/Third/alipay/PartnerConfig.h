//
//  PartnerConfig.h
//  AlipaySdkDemo
//
//  Created by ChaoGanYing on 13-5-3.
//  Copyright (c) 2013年 RenFei. All rights reserved.
//
//  提示：如何获取安全校验码和合作身份者id
//  1.用您的签约支付宝账号登录支付宝网站(www.alipay.com)
//  2.点击“商家服务”(https://b.alipay.com/order/myorder.htm)
//  3.点击“查询合作者身份(pid)”、“查询安全校验码(key)”
//

#ifndef MQPDemo_PartnerConfig_h
#define MQPDemo_PartnerConfig_h

#ifndef MQPDemo_PartnerConfig_h
#define MQPDemo_PartnerConfig_h

//合作身份者id，以2088开头的16位纯数字
#define PartnerID @"2088511416723811"
//收款支付宝账号
#define SellerID  @"guokr@mac-top.mobi"

//安全校验码（MD5）密钥，以数字和字母组成的32位字符
#define MD5_KEY @"i5yskm3o4kgy818ipj2pi76yiuc98c9v"

//商户私钥，自助生成
#define PartnerPrivKey @"MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBAOz2NY3/ewRoxS7gvN84JMfGzBGFnZWvn21rHInNeE0zIPprps2yvknMF2Htkatg286NgLpFsS/0AkgyiB25rQdO/Hi0ZjOqyKTQoQBL72VwRvlojuLJGWjqgxt2ZdxHukd+r9inOmKfJfHPwShMUVoG0ut5yhnDNbB3HB5HpN1RAgMBAAECgYByT2eQY6F1hBEzRwj16cCcewMwpLNbZUhUYWp3853IKBUNmObzrflr4j+ZZyBxex0uLEbgFQSf7Gc5at8M7+hOg3v8Rh/wjB/LmQFqDw1k4ShEh0aPlzxvb5l/PTIgIy5Oy8Fo7lVwVHhYpA6t2gE2i/JNTy4ZcKMFvilwIhE3TQJBAP9XNVtenT9yH9cGPm7SOkK3yA4OY23ejX0oRvVgiiw/DmZzigkRxPPYc96EaI6Fz/KGhLxHiCpakCbKVoY/zCsCQQDtktn7tIK742q1Zlu8OgU0ZoWgiSvAi23cVJzSDHnlRgoSipqGbiKOgsnNxq5kI9Ag+N3CqByI6Ix2H/Zqs3JzAkBqDnn+EoVz9d4dvN0vwKgsUBOLKxTHbNoN8y3N+6RIjoRXr4PVEolg0zYFZa/cCt59mLwHTBrVpLodMovPxS3zAkEAgEhXpG6oWURHjoQi7NR3kv/5D+KB2YpwXBTkSRerin3zWme1YPl/d2xwA8lQyYn9DJDVThLwtYy8q9w+dwdGuQJBAMQ8/L7v/NM2vBXP+XcrLeSCoIYwywHWmDjXBInBCfhFjOBdDgywn8uMk7AQ+qgwIeP73t+iEepu4mK0B2lJVKU="


//支付宝公钥
#define AlipayPubKey   @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCnxj/9qwVfgoUh/y2W89L6BkRAFljhNhgPdyPuBV64bfQNN1PjbCzkIM6qRdKBoLPXmKKMiFYnkd6rAoprih3/PrQEB/VsW8OoM8fxn67UDYuyBTqA23MML9q1+ilIZwBC2AQ2UBVOrFXfFl75p6/B5KsiNG9zpgmLCUYuLkxpLQIDAQAB"

#endif
