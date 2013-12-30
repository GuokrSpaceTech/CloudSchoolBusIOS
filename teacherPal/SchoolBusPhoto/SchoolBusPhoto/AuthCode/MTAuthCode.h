//
//  MTAuthCode.h
//  MyHealth
//
//  Created by Lv Hua on 12-2-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

// Authcode option
#define MT_AUTH_ENCODE              0
#define MT_AUTH_DECODE              1

// Auth keys
#define MT_AUTH_KEY_IPHONE          @"iphoneuser"
#define MT_AUTH_KEY_IPAD            @"ipaduser"
#define MT_AUTH_KEY_IPHONE_INDEX    @"1"
#define MT_AUTH_KEY_IPAD_INDEX      @"2"

@interface MTAuthCode : NSObject

+ (NSString*)authCode:(NSString*)string encodeOrDecode:(int)operation authKey:(NSString*)key expiryPeriod:(long)expiry;
+ (NSString*)authEncode:(NSString*)string authKey:(NSString*)key expiryPeriod:(long)expiry;
+ (NSString*)authDecode:(NSString*)string authKey:(NSString*)key expiryPeriod:(long)expiry;

@end
