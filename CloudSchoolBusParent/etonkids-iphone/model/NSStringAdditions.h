//
//  NSStringAdditions.h
//  MyHealth
//
//  Created by Lv Hua on 12-7-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
//

#import <Foundation/Foundation.h>

@interface NSString (MTAdditions)

/**
 * Determines if the string contains only whitespace and newlines.
 */
- (BOOL)isWhitespaceAndNewlines;

/**
 * Determines if the string is empty or contains only whitespace.
 */
- (BOOL)isEmptyOrWhitespace;

/**
 * Returns a URL Encoded String
 */
- (NSString*)urlEncoded;



/**
 * Calculate the md5 hash of this string using CC_MD5.
 *
 * @return md5 hash of this string
 */
@property (nonatomic, readonly) NSString* md5Hash;

/**
 * Calculate the SHA1 hash of this string using CommonCrypto CC_SHA1.
 *
 * @return NSString with SHA1 hash of this string
 */
@property (nonatomic, readonly) NSString* sha1Hash;

@end

