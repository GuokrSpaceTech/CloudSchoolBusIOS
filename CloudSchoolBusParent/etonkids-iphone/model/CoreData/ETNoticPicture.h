//
//  ETNoticPicture.h
//  etonkids-iphone
//
//  Created by CaiJingPeng on 13-10-28.
//  Copyright (c) 2013年 wpf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ETImportantNotice, ETNotice;

@interface ETNoticPicture : NSManagedObject

@property (nonatomic, retain) NSString * noticeid;
@property (nonatomic, retain) NSString * pictureurl;
@property (nonatomic, retain) NSString * num;
@property (nonatomic, retain) ETImportantNotice *importantpic;
@property (nonatomic, retain) ETNotice *pictures;

@end
