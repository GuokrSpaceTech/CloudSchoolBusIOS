//
//  UploadWrapper.h
//  CloudSchoolBusTeacher
//
//  Created by macbook on 15/12/15.
//  Copyright © 2015年 BeiJingYinChuang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UploadWrapper : NSObject

+(UploadWrapper *)shareInstance;
-(void)uploadFile;
@end
