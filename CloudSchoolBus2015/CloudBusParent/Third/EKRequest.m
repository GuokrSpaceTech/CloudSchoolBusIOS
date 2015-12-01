

#import "EKRequest.h"
#import <CommonCrypto/CommonDigest.h>
#import "CBLoginInfo.h"
#import "SVHTTPRequest.h"
//#define SERVERURL @"http://api.yunxiaoche.com/"
//#define SERVERURL @"http://apitest.yunxiaoche.com/"
//#define SERVERURL @"http://apitest.yunxiaoche.com/"
//#define SERVERURL @"http://222.128.71.186:81/"
#define SERVERURLHOST @"http://api36.yunxiaoche.com/api/parent/"
#define VERSION @"4.0.0"
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
    CC_MD5( cStr, (CC_LONG)strlen(cStr), result );
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
        case REGISTER:
            return @"register";
        case verify:
            return @"verify";
        case login:
            return @"login";
        case baseinfo:
            return @"baseinfo";
        case getmessage:
            return @"getmessage";
        case uploadAvatar:
            return @"setStudentAvatar";
        default:
            
            return nil;
    }
}
-(void) EKHTTPRequest:(RequestFunction) function parameters:(NSDictionary *) param requestMethod:(HTTPMethod) method forDelegate:(id<EKProtocol>)delegate
{
    NSArray * header = nil;
    
    //登录方法不加入Sid
    if((function == REGISTER || function == verify || function == login) && param != nil)
    {
        header = [NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:@"mactoprestphone",@"apikey",VERSION,@"VerVersionsion", nil], nil];
    }
    else
    {
        CBLoginInfo * info = [CBLoginInfo shareInstance];
        header = [NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:@"mactoprestphone",@"apikey",info.sid,@"sid",VERSION,@"VerVersionsion",nil], nil];
        
        
    }
    
    NSString * address = [SERVERURLHOST stringByAppendingFormat:@"%@",[self getFunction:function]];
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
//             id json = [NSJSONSerialization JSONObjectWithData:response options:nil error:nil];
//             if(json != nil && [json isKindOfClass:[NSDictionary class]])
//             {
//                     id sid = [json objectForKey:@"sid"];
//                     if(sid != nil)
//                         [userDefault setObject:sid forKey:@"sid"];
//             }
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
