
#import <Foundation/Foundation.h>

enum HTTPMethod
{
    GET = 0,
    POST,
    DELETE,
};
typedef NSUInteger HTTPMethod;

enum RequestFunction
{
    tsignin = 0,
    password,
    weather,
    notice,
    article,
    absence,
    menu,
    schedule,
    student,
    feedback,
    avatar,
    classinfo,
    setting,
    version,
    events,
    status,
    teacher,
    ad,
    pic,
    tnotice,
    verify,
    deleteF,
    snotice,
    tpassword,
    comment,
    calendar,
    push,
    forward,
    LetterF,
    Creditshop,
    Credit,
    source,
    test,
    uploadimg,
    addStudent,
    searchStudent,
    inclass,
    mobileStudent,
    relationship,
    resetpassword,
    smartcard,
    attendancemanager
};
typedef NSUInteger RequestFunction;

/*
 Code返回:
  1 成功
 -1 sid错误
 -2 数据为空
 -3 传入数据格式不正确
 -4 其他未知错误
 -5 数据操作失败
 -100 权限错误
 -1010 账号不存在
 -1011 密码错误
 -1012 老密码错误
 -1013 密码不符合规范
 -1014 上传失败
 -1015 该学员不在这个班级里
 -1016 权限错误
 -1111 apikey 错误
 -1112 sid 错误
 -1113 sid 未登录
*/


@protocol EKProtocol <NSObject>
@required

-(void) getEKResponse:(id) response forMethod:(RequestFunction) method parm:(NSDictionary *)parm resultCode:(int) code;
-(void) getErrorInfo:(NSError *) error forMethod:(RequestFunction) method;

@end


@interface EKRequest : NSObject
{
    
}

+(id) Instance;
+ (NSString *)md5:(NSString *)str;
-(void) clearSid;
-(void) EKHTTPRequest:(RequestFunction) function parameters:(NSDictionary *) param requestMethod:(HTTPMethod) method forDelegate:(id<EKProtocol>) delegate;

@end
