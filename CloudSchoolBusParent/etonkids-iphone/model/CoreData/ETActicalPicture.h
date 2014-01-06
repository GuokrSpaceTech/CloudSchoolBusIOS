//
//  ETActicalPicture.h
//  etonkids-iphone
//
//  Created by CaiJingPeng on 13-10-28.
//  Copyright (c) 2013年 wpf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ETClassShare;

@interface ETActicalPicture : NSManagedObject

@property (nonatomic, retain) NSString * articalid;
@property (nonatomic, retain) NSString * pictureurl;
@property (nonatomic, retain) NSString * num;
@property (nonatomic, retain) ETClassShare *pictures;

@end
