
#import "UserLogin.h"
#import "SFHFKeychainUtils.h"

static UserLogin *current=nil;

@implementation UserLogin

@synthesize age,
            birthday,
            cnname,
            enname,
            mobile,
            nickname,
            parent,
            sex,
            passWord,
            inClass,
            duty,
            attendancetype,
            regName,
            className,
            avatar,
            loginStatus,
            allowmutionline,
            pid,
            uid_class,
            uid_student,
            ischeck_mobile,
            skinid,
            username,
            can_comment,
            can_comment_action,
//            pull_rate,
//            company,
//            copyright,
//            phone,
//            product,
            studentId,
//website,
            schoolname,
            orderTitle,
            inactive,
            healtState,
            orderEndTime;


#pragma --

-(id)init
{
    if(self=[super init])
    {
        self.loginStatus=LOGIN_OFF;
    }
    return self;
}

+(UserLogin *)currentLogin
{
    if(current==nil)
    {
        current=[[UserLogin alloc]init];
    }

    return current;
}

+ (void)releaseCurrentUser
{
    @synchronized(self)
    {
        if (current != nil)
            [current release];
        current = nil;
    }
}

#pragma mark - Keychain related handlers

// Clear the keychain
+ (void)clearLastLogin
{
    [SFHFKeychainUtils deleteItemForUsername:kMHKeychainAccount andServiceName:kMHKeychainServiceName error:nil];
    [SFHFKeychainUtils deleteItemForUsername:kMHKeychainPassword andServiceName:kMHKeychainServiceName error:nil];
    [SFHFKeychainUtils deleteItemForUsername:kMHKeychainStudent andServiceName:kMHKeychainServiceName error:nil];
    [SFHFKeychainUtils deleteItemForUsername:kMHKeychainClass andServiceName:kMHKeychainServiceName error:nil];
}

+ (void)clearLastPassword
{
    [SFHFKeychainUtils deleteItemForUsername:kMHKeychainPassword andServiceName:kMHKeychainServiceName error:nil];
}

// Get the user name and password from keychain
- (BOOL)getLastLogin
{
    NSString* account = [SFHFKeychainUtils getPasswordForUsername:kMHKeychainAccount andServiceName:kMHKeychainServiceName error:nil];
    NSString* password = [SFHFKeychainUtils getPasswordForUsername:kMHKeychainPassword andServiceName:kMHKeychainServiceName error:nil];
    NSString* stuid = [SFHFKeychainUtils getPasswordForUsername:kMHKeychainStudent andServiceName:kMHKeychainServiceName error:nil];
    NSString* cid = [SFHFKeychainUtils getPasswordForUsername:kMHKeychainClass andServiceName:kMHKeychainServiceName error:nil];
    
    if (account == nil || password == nil)
        return NO;
    
    self.regName = account;
    self.passWord = password;
    self.uid_student = stuid;
    self.uid_class = cid;
    return YES;
}

// Save user and password to keychain
- (void)updateLastLogin
{
    if (self.regName != nil && self.passWord != nil)
    {
        [SFHFKeychainUtils storeUsername:kMHKeychainAccount andPassword:self.regName forServiceName:kMHKeychainServiceName updateExisting:YES error:nil];
        [SFHFKeychainUtils storeUsername:kMHKeychainPassword andPassword:self.passWord forServiceName:kMHKeychainServiceName updateExisting:YES error:nil];
        [SFHFKeychainUtils storeUsername:kMHKeychainStudent andPassword:self.uid_student forServiceName:kMHKeychainServiceName updateExisting:YES error:nil];
        [SFHFKeychainUtils storeUsername:kMHKeychainClass andPassword:self.uid_class forServiceName:kMHKeychainServiceName updateExisting:YES error:nil];
    }
}

-(void)dealloc
{
    self.avatar = nil;
    self.age = nil;
    self.birthday = nil;
    self.cnname = nil;
    self.enname = nil;
    self.mobile = nil;
    self.nickname = nil;
    self.parent = nil;
    self.regName=nil;
    self.sex=nil;
    self.inClass = nil;
    self.duty = nil;
    self.attendancetype = nil;
    self.passWord=nil;
    self.schoolname=nil;
    self.allowmutionline = nil;
    self.pid = nil;
    self.uid_student = nil;
    self.uid_class = nil;
    self.orderEndTime = nil;
    self.orderTitle = nil;
    self.inactive=nil;
    self.healtState=nil;
//    self.pull_rate = nil;
//    self.company = nil;
//    self.copyright = nil;
//    self.phone = nil;
//    self.product = nil;
//    self.website = nil;
    
    [super dealloc];
}
@end
