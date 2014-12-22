

#import "EKRequest.h"
#import "SVHTTPRequest.h"
#import <CommonCrypto/CommonDigest.h>
#import "NSString+SBJSON.h"
#import "JSONKit.h"
#import "SBJSON.h"

//#define SERVERURL @"http://api.yunxiaoche.com/"
//#define SERVERURL @"http://apitest.yunxiaoche.com/"
//#define SERVERURL @"http://apitest.yunxiaoche.com/"
//#define SERVERURL @"http://222.128.71.186:81/"
#define SERVERURL @"http://api35.yunxiaoche.com:81/"
#define VERSION @"3.4.5"
@interface EKRequest()

-(NSString *) getFunction:(RequestFunction) fun;

@end

@implementation EKRequest


static EKRequest * instance = nil;


+(id) Instance
{
    if(instance == nil)
    {
        instance = [[EKRequest alloc] init];
    }
    return instance;
}
+ (NSString *)md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[32];
    CC_MD5( cStr, strlen(cStr), result );
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}
-(void) clearSid
{
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault removeObjectForKey:@"sid"];
    

    
}

- (NSString *)userSid
{
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    return [userDefault objectForKey:@"sid"];
}
- (void)saveUserSid:(NSString *)sid
{
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:sid forKey:@"sid"];
}

-(NSString *) getFunction:(RequestFunction) fun
{
    switch (fun)
    {
        case signin:
            return @"signin";
        case password:
            return @"password";
        case weather:
            return @"weather";
        case notice:
            return @"notice";
        case article:
            return @"article";
        case attendance:
            return @"attendance";
        case menu:
            return @"menu";
        case schedule:
            return @"schedule";
        case student:
            return @"student";
        case feedback:
            return @"feedback";
        case classinfo:
            return @"classinfo";
        case avatar:
            return @"avatar";
        case pull:
            return @"pull";
        case setting:
            return @"setting";
        case version:
            return @"version";
        case events:
            return @"events";
        case advertorial:
            return @"advertorial";
        case status:
            return @"status";
        case eventslist:
            return @"eventslist";
        case advertoriallist:
            return @"advertoriallist";
        case ad:
            return @"ad";
        case comment:
            return @"comment";
        case forgot:
            return @"forgot";
        case delete:
            return @"delete";
        case push:
            return @"push";
        case unit:
            return @"unit";
        case bindTel:
            return @"bind";
        case forgetpwd:
            return @"forgetpwd";
        case bindreplace:
            return @"bindreplace";
        case skinid:
            return @"skinid";
        case attendancemanager:
            return @"attendancemanager";
        case childreceiver:
            return @"childreceiver";
        case deletereceiver:
            return @"deletereceiver";
        case report:
            return @"report";
        case search:
            return @"search";
        case order:
            return @"order";
        case geofenceparents:
            return @"geofenceparents";
        case price:
            return @"price";
        case personalorder:
            return @"personalorder";
        case lastestletter:
            return @"lastestletter";
        case messageletter:
            return @"messageletter";
        default:
            
            return nil;
    }
}
-(void) EKHTTPRequest:(RequestFunction) function parameters:(NSDictionary *) param requestMethod:(HTTPMethod) method forDelegate:(id<EKProtocol>)delegate
{
    NSArray * header = nil;
    
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    //登录方法不加入Sid
    if((function == signin || function == unit || function==personalorder || function==price) && param != nil)
    {
        header = [NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:@"mactoprestphone",@"apikey",VERSION,@"Version", nil], nil];
    }
    else
    {
        NSString * sid = [userDefault objectForKey:@"sid"];
        header = [NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:@"mactoprestphone",@"apikey",sid,@"sid",VERSION,@"Version",nil], nil];
    }
    
    NSString * address = [SERVERURL stringByAppendingFormat:@"%@",[self getFunction:function]];
    //GET请求
    if(method == GET)
    {
        [SVHTTPRequest GET:address parameters:param customHeader:header completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error)
         {
             if(error != nil)
             {
                 [delegate getErrorInfo:error forMethod:function];
                 return;
             }
             
             NSDictionary * allHeaderInfo = [urlResponse allHeaderFields];
             int code = [[allHeaderInfo objectForKey:@"Code"] intValue];
             if(code==-2000)
             {
                 [self addPostNotification];
             }
             [delegate getEKResponse:response forMethod:function resultCode:code withParam:param];
         }];
    }
    //POST请求
    if(method == POST)
    {
        [SVHTTPRequest POST:address parameters:param customHeader:header completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error)
         {
             if(error != nil)
             {
                   NSLog(@"%@",error);
                 [delegate getErrorInfo:error forMethod:function];
                 return;
             }
             
           
             NSDictionary * allHeaderInfo = [urlResponse allHeaderFields];
             int code = [[allHeaderInfo objectForKey:@"Code"] intValue];
             if(code==-2000)
             {
                 [self addPostNotification];
             }
             id json = [NSJSONSerialization JSONObjectWithData:response options:nil error:nil];
             if(json != nil && [json isKindOfClass:[NSDictionary class]])
             {
                     id sid = [json objectForKey:@"sid"];
                     if(sid != nil)
                         [userDefault setObject:sid forKey:@"sid"];
             }
             [delegate getEKResponse:response forMethod:function resultCode:code withParam:param];
         }];
    }
    //DELETE请求
    if(method == DELETE)
    {
        [SVHTTPRequest DELETE:address parameters:param customHeader:header completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error)
         {
             if(error != nil)
             {
                 [delegate getErrorInfo:error forMethod:function];
                 return;
             }
             NSDictionary * allHeaderInfo = [urlResponse allHeaderFields];
             int code = [[allHeaderInfo objectForKey:@"Code"] intValue];
             if(code==-2000)
             {
                 [self addPostNotification];
             }
             [delegate getEKResponse:response forMethod:function resultCode:code withParam:param];
         }];
    }
    
    
    
}


-(void)addPostNotification
{
    NSNotificationCenter *center=[NSNotificationCenter defaultCenter];
    [center postNotificationName:@"PERSIONALALIPAY" object:nil];
}

@end
