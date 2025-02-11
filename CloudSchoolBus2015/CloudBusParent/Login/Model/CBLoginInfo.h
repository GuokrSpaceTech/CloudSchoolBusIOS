//
//  CBLoginInfo.h
//  CloudBusParent
//
//  Created by HELLO  on 15/11/5.
//  Copyright (c) 2015年 BeiJingYinChuang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EKRequest.h"
typedef void (^loginSuccess)(BOOL isLogin);
typedef void (^sessionNotOver)(BOOL isExist);
typedef enum {
    LoginOn,
    LoginOff,
    LoginOver
}LoginState;
@interface CBLoginInfo : NSObject<EKProtocol>
{
    
}
@property (nonatomic,strong)NSString * currentStudentId; // 当前孩子id
@property (nonatomic,copy) loginSuccess successBlock;
@property (nonatomic,copy) sessionNotOver baseInfoBlock;
@property (nonatomic,assign)LoginState state;
@property (nonatomic,copy) NSString * phone;
@property (nonatomic,copy) NSString * userid;
@property (nonatomic,copy) NSString * token;
@property (nonatomic,copy) NSString * rongToken;
@property (nonatomic,copy) NSString * sid;
@property (nonatomic,strong)NSMutableArray * schoolArr;
@property (nonatomic,strong)NSMutableArray * studentArr;

@property (nonatomic,assign)BOOL hasValidBaseInfo;
@property (nonatomic,assign)BOOL teacherVCIsLoading;
@property (nonatomic,strong) NSString *baseInfoJsonString;

+ (CBLoginInfo*)shareInstance;

-(void)loginSid:(loginSuccess)block;
-(void)baseInfoIsExist:(sessionNotOver)block; // 如果session 没有过期 调用获取最新的baseinfo 信息
-(void)connectRongYun;
@end
