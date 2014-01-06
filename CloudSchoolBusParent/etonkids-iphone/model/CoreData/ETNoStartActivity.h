//
//  ETNoStartActivity.h
//  etonkids-iphone
//
//  Created by CaiJingPeng on 13-10-23.
//  Copyright (c) 2013年 wpf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ETNoStartActivity : NSManagedObject

@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * addtime;
@property (nonatomic, retain) NSString * endtime;
@property (nonatomic, retain) NSString * eventsid;
@property (nonatomic, retain) NSString * htmlurl;
@property (nonatomic, retain) NSString * isonline;
@property (nonatomic, retain) NSString * issignup;
@property (nonatomic, retain) NSString * picurl;
@property (nonatomic, retain) NSString * schoolid;
@property (nonatomic, retain) NSString * signup;
@property (nonatomic, retain) NSString * signupendtime;
@property (nonatomic, retain) NSString * signupstarttime;
@property (nonatomic, retain) NSString * signupstatus;
@property (nonatomic, retain) NSString * starttime;
@property (nonatomic, retain) NSString * title;

@end
