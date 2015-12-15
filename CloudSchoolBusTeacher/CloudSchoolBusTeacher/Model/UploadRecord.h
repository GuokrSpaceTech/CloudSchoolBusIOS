//
//  UploadRecord.h
//  CloudSchoolBusTeacher
//
//  Created by mactop on 12/15/15.
//  Copyright © 2015 BeiJingYinChuang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UploadRecord : NSObject

@property (nonatomic,strong) NSString *pickey;
@property (nonatomic,strong) NSString *pictype;
@property (nonatomic,strong) NSString *classid;
@property (nonatomic,strong) NSString *fbody;
@property (nonatomic,strong) NSString *teacherid;
@property (nonatomic,strong) NSString *fname;
@property (nonatomic,strong) NSString *ftime;
@property (nonatomic,strong) NSString *status;
@property (nonatomic,strong) NSString *content;
@property (nonatomic,strong) NSString *tagids;
@property (nonatomic,strong) NSString *studentids;

@end
