//
//  GKUserLogin.m
//  SchoolBusParents
//
//  Created by CaiJingPeng on 13-7-24.
//  Copyright (c) 2013年 wen peifang. All rights reserved.
//

#import "GKUserLogin.h"
#import "SFHFKeychainUtils.h"
#define kMHKeychainServiceName    @"school_bus_parents"
#define kMHKeychainAccount        @"school_bus_parents_account"
#define kMHKeychainPassword       @"school_bus_parents_password"
#define kMHKeychainAccountType    @"school_bus_parents_type"

static GKUserLogin *currentUser=nil;

@implementation GKUserLogin
@synthesize _userName=userName;
@synthesize _passWord=passWord;
@synthesize _loginState=loginState;
@synthesize _sid=sid;
@synthesize classInfo;
@synthesize studentArr;
@synthesize upIP;
@synthesize credit,credit_last,credit_orders;
@synthesize photoCredit,vipCredit,predCredit;
@synthesize badgeNumber,photoTagArray;
-(id)init
{
    if(self=[super init])
    {
        [self set_loginState:LOGINOFF];
        [self set_userName:@""];
        [self set_passWord:@""];
        [self set_sid:@""];
        [self setBadgeNumber:0];
        [self setUpIP:@""];
        //[self setStudentArr:<#(NSMutableArray *)#>];
    }
    return self;
}

+(GKUserLogin *)currentLogin;
{
    if(currentUser==nil)
    {
        currentUser=[[GKUserLogin alloc]init];
    }
    
    return currentUser;
}

+ (void)clearLastLogin
{
    [SFHFKeychainUtils deleteItemForUsername:kMHKeychainAccount andServiceName:kMHKeychainServiceName error:nil];
    [SFHFKeychainUtils deleteItemForUsername:kMHKeychainPassword andServiceName:kMHKeychainServiceName error:nil];
    [SFHFKeychainUtils deleteItemForUsername:kMHKeychainAccountType andServiceName:kMHKeychainServiceName error:nil];
}
+(void)clearpassword
{
     [SFHFKeychainUtils deleteItemForUsername:kMHKeychainPassword andServiceName:kMHKeychainServiceName error:nil];
}
//+ (void)clearLastPassword
//{
//    [SFHFKeychainUtils deleteItemForUsername:kMHKeychainPassword andServiceName:kMHKeychainServiceName error:nil];
//}

// Get the user name and password from keychain
- (BOOL)getLastLogin
{
    NSString* account = [SFHFKeychainUtils getPasswordForUsername:kMHKeychainAccount andServiceName:kMHKeychainServiceName error:nil];
    NSString* password = [SFHFKeychainUtils getPasswordForUsername:kMHKeychainPassword andServiceName:kMHKeychainServiceName error:nil];
    
    if (account == nil)
        return NO;
    
    if(account!=nil)
    {
         self._userName= account;
    }
    if(passWord!=nil)
    {
        self._passWord = password;
    }
   
 
    return YES;
}

// Save user and password to keychain
- (void)updateLastLogin
{
    if (self._userName != nil && self._passWord != nil)
    {
        [SFHFKeychainUtils storeUsername:kMHKeychainAccount andPassword:self._userName forServiceName:kMHKeychainServiceName updateExisting:YES error:nil];
        [SFHFKeychainUtils storeUsername:kMHKeychainPassword andPassword:self._passWord forServiceName:kMHKeychainServiceName updateExisting:YES error:nil];
    }
}


-(void)clearSID
{
    [self set_sid:@""];
}
@end
