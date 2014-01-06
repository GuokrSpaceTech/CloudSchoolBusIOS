//
//  MTAuthCode.m
//  MyHealth
//
//  Created by Lv Hua on 12-2-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MTAuthCode.h"
#import "NSStringAdditions.h"
#import "NSDataAdditions.h"

@implementation MTAuthCode

+ (NSString*)authCode:(NSString*)source encodeOrDecode:(int)operation authKey:(NSString*)key expiryPeriod:(long)expiry
{
    // $ckey_length = 4;
    NSUInteger ckey_length = 4;
    NSString* keymd5, *keya, *keyb, *keyc, *cryptkey;
    NSString* tempStr, *tempMd5;
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    // $key = md5($key ? $key : UC_KEY);
    if (key == nil)
    {
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) 
            key = MT_AUTH_KEY_IPHONE;
        else 
            key = MT_AUTH_KEY_IPAD;
    }
    
    keymd5 = [key md5Hash];
    
    // $keya = md5(substr($key, 0, 16));	
    tempStr = [keymd5 substringWithRange:NSMakeRange(0, 16)];
    keya = [tempStr md5Hash];
    
    // $keyb = md5(substr($key, 16, 16));
    tempStr = [keymd5 substringWithRange:NSMakeRange(16, 16)];
    keyb = [tempStr md5Hash];
    
    // $keyc = $ckey_length ? ($operation == 'DECODE' ? substr($string, 0, $ckey_length): substr(md5(microtime()), -$ckey_length)) : '';
    if (ckey_length != 0)
    {
        if (operation == MT_AUTH_DECODE)
            keyc = [source substringToIndex:ckey_length];
        else
        {
            NSDateFormatter *nsdf=[[[NSDateFormatter alloc] init] autorelease];  
            [nsdf setDateStyle:NSDateFormatterShortStyle];  
            [nsdf setDateFormat:@"YYYYMMDDHHmmssSSSS"];  
            NSDate* now = (NSDate*)[NSDate date];
            tempStr=[nsdf stringFromDate:now];
            tempMd5 = [tempStr md5Hash];
            keyc = [tempMd5 substringFromIndex:[tempMd5 length]-ckey_length];
        }
    }
    else
    {
        keyc = @"";
    }
    
    // $cryptkey = $keya.md5($keya.$keyc);
    tempStr = [keya stringByAppendingString:keyc];
    tempMd5 = [tempStr md5Hash];
    cryptkey = [keya stringByAppendingString:tempMd5];
    
    // $key_length = strlen($cryptkey);
    NSUInteger key_length = [cryptkey length];
    NSData* tempData = nil;
    // $string = $operation == 'DECODE' ? base64_decode(substr($string, $ckey_length)) : sprintf('%010d', $expiry ? $expiry + time() : 0).substr(md5($string.$keyb), 0, 16).$string;
    if (operation == MT_AUTH_DECODE)
    {
        tempStr = [source substringFromIndex:ckey_length];
        tempData = [NSData dataWithBase64EncodedString:tempStr]; 
    }
    else
    {
        NSMutableString* mutableString = [NSMutableString stringWithCapacity:10 + 16 + [source length] + 16];
        
        long time = 0;
        
        if (expiry)
        {
            NSDate* now = [NSDate date];
            time = (long)[now timeIntervalSince1970] + expiry;
        }
        
        [mutableString appendFormat:@"%010d", time];
        tempStr = [source stringByAppendingString:keyb];
        tempMd5 = [tempStr md5Hash];
        
        NSString* subMd5 = [tempMd5 substringWithRange:NSMakeRange(0, 16)];
        
        [mutableString appendString:subMd5];
        [mutableString appendString:source];
        
        tempData = [mutableString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        //[mutableString release];
    }
    
    // $string_length = strlen($string);
    NSUInteger string_length = [tempData length];
    
    // $box = range(0, 255);
    int i, box[256];
    for (i = 0; i < 256; ++i)
        box[i] = i;
    
    // $rndkey = array();
    // for($i = 0; $i <= 255; $i++) {
	//	  $rndkey[$i] = ord($cryptkey[$i % $key_length]);
	// }
    int rndkey[256];
    const char* cstr = [cryptkey UTF8String];
    if (cstr == NULL)
    {
        [pool release];
        return nil;
    }
    
    for (i = 0; i < 256; ++i)
        rndkey[i] = cstr[i%key_length];
    
    //  for($j = $i = 0; $i < 256; $i++) {
    //      $j = ($j + $box[$i] + $rndkey[$i]) % 256;
    //      $tmp = $box[$i];
    //      $box[$i] = $box[$j];
    //      $box[$j] = $tmp;
    //  }
    
    int j;
    for (i = 0, j = 0; i < 256; ++i)
    {
        int tmp;
        
        j = (j + box[i] + rndkey[i]) % 256;
        tmp = box[i];
        box[i] = box[j];
        box[j] = tmp;
    }
    
    // for($a = $j = $i = 0; $i < $string_length; $i++) {
	//	$a = ($a + 1) % 256;
	//	$j = ($j + $box[$a]) % 256;
	//	$tmp = $box[$a];
	//	$box[$a] = $box[$j];
	//	$box[$j] = $tmp;
	//	$result .= chr(ord($string[$i]) ^ ($box[($box[$a] + $box[$j]) % 256]));
	// }
    char* resultArray = (char*)malloc(string_length);
    int a;
    const char* dataBytes = [tempData bytes];
    for (a =0, i = 0, j = 0; i < string_length; ++i)
    {
        int tmp;
        
        a = (a + 1) % 256;
        j = (j + box[a]) % 256;
        tmp = box[a];
        box[a] = box[j];
        box[j] = tmp;
        resultArray[i] = (dataBytes[i] ^ (box[(box[a] + box[j]) % 256]));
    }
    
    // if($operation == 'DECODE') {
	// 	if((substr($result, 0, 10) == 0 || substr($result, 0, 10) - time() > 0) && substr($result, 10, 16) == substr(md5(substr($result, 26).$keyb), 0, 16)) {
	//		return substr($result, 26);
	//	} else {
    //      return '';
    //    }
	// } else {
	//	return $keyc.str_replace('=', '', base64_encode($result));
	// }
    
    NSString* ret = nil;
    if (operation == MT_AUTH_DECODE)
    {
        // 	if((substr($result, 0, 10) == 0 || substr($result, 0, 10) - time() > 0) && substr($result, 10, 16) == substr(md5(substr($result, 26).$keyb), 0, 16)) {
        //		return substr($result, 26);
        //	} else {
        //      return '';
        //    }
        NSDate* now = [NSDate date];
        NSTimeInterval nowTime = [now timeIntervalSince1970];
        
        tempStr = [[[NSString alloc] initWithBytes:resultArray length:10 encoding:NSUTF8StringEncoding] autorelease];
        double expiryTime = [tempStr doubleValue];
        
        if (expiryTime == 0 || expiryTime - nowTime > 0)
        {
            tempStr = [[[NSString alloc] initWithBytes:resultArray+26 length:string_length - 26 encoding:NSUTF8StringEncoding] autorelease];
            NSString* tempStr1 = [tempStr stringByAppendingString:keyb];
            tempMd5 = [tempStr1 md5Hash];
            tempStr1 = [tempMd5 substringToIndex:16];
            tempStr = [[[NSString alloc] initWithBytes:resultArray+10 length:16 encoding:NSUTF8StringEncoding] autorelease];
            NSComparisonResult compareResult = [tempStr compare:tempStr1];
            if (compareResult == NSOrderedSame)
            {
                // Here ret don't need to autorelease since we need to return it
                ret = [[NSString alloc] initWithBytes:resultArray+26 length:string_length - 26 encoding:NSUTF8StringEncoding];
            }
            else
            {
                // Here ret don't need to autorelease since we need to return it
                ret = @"";
            }                   
        }
        else
        {
            // Here ret don't need to autorelease since we need to return it
            ret = @"";
        }
    }
    else // Encoding
    {
        // return $keyc.str_replace('=', '', base64_encode($result));
        NSData* resultData = [NSData dataWithBytes:resultArray length:string_length];
        NSString* base64Str = [resultData base64Encoding];
        tempStr = [base64Str stringByReplacingOccurrencesOfString:@"="withString:@""];
        
        // ret is an autorelease object. So we need to retain it before return.
        ret = [[keyc stringByAppendingString:tempStr] retain];
    }
    
    free(resultArray);
    [pool release];
    
    // according to the cocoa memory managerment rule, we should autorelease ret.
    [ret autorelease];
    return ret;
}

+ (NSString*)authEncode:(NSString*)source authKey:(NSString*)key expiryPeriod:(long)expiry
{
    return [MTAuthCode authCode:source encodeOrDecode:MT_AUTH_ENCODE authKey:key expiryPeriod:expiry];
}

+ (NSString*)authDecode:(NSString*)source authKey:(NSString*)key expiryPeriod:(long)expiry
{
    return [MTAuthCode authCode:source encodeOrDecode:MT_AUTH_DECODE authKey:key expiryPeriod:expiry];
}

@end
