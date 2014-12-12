

#import "EKRequest.h"
#import "SVHTTPRequest.h"
#import "GKUserLogin.h"
#import <CommonCrypto/CommonDigest.h>
//#import "NSString+SBJSON.h"
//#import "JSONKit.h"
//#import "SBJSON.h"

//#define SERVERURL @"http://apitest.yunxiaoche.com/"

//#define SERVERURL @"http://192.168.2.18:81/"
//#define SERVERURL @"http://v33.service.yunxiaoche.com/"
//#define SERVERURL @"http://222.128.71.186:81/"

#define SERVERURL @"http://api34.yunxiaoche.com/"
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
-(NSString *) getFunction:(RequestFunction) fun
{
    switch (fun)
    {
        case LetterF:
            return @"Letter";
        case tsignin:
            return @"tsignin";
        case password:
            return @"password";
        case weather:
            return @"weather";
        case notice:
            return @"notice";
        case article:
            return @"article";
        case absence:
            return @"Absence";
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
        case setting:
            return @"setting";
        case version:
            return @"version";
        case events:
            return @"events";
        case status:
            return @"status";
        case ad:
            return @"ad";
        case teacher:
            return @"teacher";
        case pic:
            return @"pic";
        case tnotice:
            return @"tnotice";
            
        case verify:
            return @"verify";
        case deleteF:
            return @"delete";
        case snotice:
            return @"snotice";
        case tpassword:
            return @"tpassword";
        case comment:
            return @"comment";
        case calendar:
            return @"calendar";
        case push:
            return @"push";
        case forward:
            return @"forward";
        case Creditshop:
            return @"creditshop";
        case Credit:
            return @"credit";
        case source:
            return @"source";
        case test:
            return @"test";
        case uploadimg:
            return @"uploadimg";
        case addStudent:
            return @"addStudent";
        case searchStudent:
            return @"searchStudent";
        case inclass:
            return @"inclass";
        case mobileStudent:
            return @"mobileStudent";
        case relationship:
            return @"relationship";
        case resetpassword:
            return @"resetpassword";
        case attendancemanager:
            return @"attendancemanager";
        case studenthealth:
            return @"studenthealth";
        case report:
            return @"report";
        case search:
            return @"search";
        case teachereventslist:
            return @"teachereventslist";
        default:
            return nil;
    }
}

-(void) EKHTTPRequest:(RequestFunction) function parameters:(NSDictionary *) param requestMethod:(HTTPMethod) method forDelegate:(id<EKProtocol>)delegate
{
    __block NSArray * header = nil;
    //NSLog(@"%@",param);
//    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    //登录方法不加入Sid
    if(function == tsignin && param != nil)
    {
        header = [NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:@"mactoprest",@"apikey",CURRENTVERSION,@"Version", nil], nil];
    }

    else
    {
        GKUserLogin *user=[GKUserLogin currentLogin];
        NSString *sid = user._sid;
       // NSString * sid = [userDefault objectForKey:@"sid"];
        header = [NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:@"mactoprest",@"apikey",sid,@"sid",CURRENTVERSION,@"Version",nil], nil];
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
             
           //  NSLog(@"%@",allHeaderInfo);
             
             int code = [[allHeaderInfo objectForKey:@"Code"] intValue];
             if(code==-1113)
             {
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"LOGINOUTNOTI" object:nil];
             }
          
            // NSDictionary * json = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
             
             NSLog(@"code:=%d",code);
             
             [delegate getEKResponse:response forMethod:function parm:param resultCode:code];
         }];
        
//        [SVHTTPRequest GET:address parameters:param completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
//             if(error != nil)
//             {
//                 [delegate getErrorInfo:error forMethod:function];
//                 return;
//             }
//        }];
    }
    //POST请求
    if(method == POST)
    {
        GKUserLogin *user=[GKUserLogin currentLogin];
   
        if(function==source)
            address=[NSString stringWithFormat:@"http://%@/source",user.upIP];
        [SVHTTPRequest POST:address parameters:param customHeader:header completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error)
         {
             
           //  NSLog(@"%@",response.);
              
             if(error != nil)
             {
                   NSLog(@"%@",error);
                 [delegate getErrorInfo:error forMethod:function];
                 return;
             }
             
           
             NSDictionary * allHeaderInfo = [urlResponse allHeaderFields];
             int code = [[allHeaderInfo objectForKey:@"Code"] intValue];
            NSLog(@"code:=%d",code);
             
            if(code==-1113)
             {
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"LOGINOUTNOTI" object:nil];
             }

             [delegate getEKResponse:response forMethod:function parm:param resultCode:code];
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
            if(code==-1113)
             {
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"LOGINOUTNOTI" object:nil];
             }
             // NSString *str=[[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
            // NSDictionary * json = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
             [delegate getEKResponse:response forMethod:function parm:param  resultCode:code];
         }];
    }
    
}


@end
