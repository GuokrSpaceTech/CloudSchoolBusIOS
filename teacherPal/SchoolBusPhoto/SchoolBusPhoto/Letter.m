//
//  Letter.m
//  SchoolBusPhoto
//
//  Created by wen peifang on 13-10-28.
//  Copyright (c) 2013年 mactop. All rights reserved.
//

#import "Letter.h"

@implementation Letter

@synthesize letterContent,letterID,letterTime,letterFromRole,picArr;
@synthesize letterFromRoleID,letterLetterType,letterToRole,letterToRoleID;

-(void)dealloc
{
    self.letterFromRole=nil;
    self.letterID=nil;
    self.letterTime=nil;
    self.picArr=nil;
    self.letterContent=nil;
    
    self.letterToRoleID=nil;
    self.letterLetterType=nil;
    self.letterToRole=nil;
    self.letterToRoleID=nil;
    [super dealloc];
}

@end
