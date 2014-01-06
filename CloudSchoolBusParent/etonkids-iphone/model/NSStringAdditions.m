//
//  NSStringAdditions.m
//  MyHealth
//
//  Created by Lv Hua on 12-7-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
//
#import "NSStringAdditions.h"
#import "NSDataAdditions.h"


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
/**
 * Additions.
 */

@implementation NSString (MTAdditions)

///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)isWhitespaceAndNewlines {
  NSCharacterSet* whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
  for (NSInteger i = 0; i < self.length; ++i) {
    unichar c = [self characterAtIndex:i];
    if (![whitespace characterIsMember:c]) {
      return NO;
    }
  }
  return YES;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)isEmptyOrWhitespace {
  // A nil or NULL string is not the same as an empty string
  return 0 == self.length ||
         ![self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)urlEncoded {
  CFStringRef cfUrlEncodedString = CFURLCreateStringByAddingPercentEscapes(NULL,
                                            (CFStringRef)self,NULL,
                                            (CFStringRef)@"!#$%&'()*+,/:;=?@[]",
                                            kCFStringEncodingUTF8);

  NSString *urlEncoded = [NSString stringWithString:(NSString *)cfUrlEncodedString];
  CFRelease(cfUrlEncodedString);
  return urlEncoded;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)md5Hash {
  return [[self dataUsingEncoding:NSUTF8StringEncoding] md5Hash];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)sha1Hash {
  return [[self dataUsingEncoding:NSUTF8StringEncoding] sha1Hash];
}

@end
