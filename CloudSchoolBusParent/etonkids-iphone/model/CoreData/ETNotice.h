//
//  ETNotice.h
//  etonkids-iphone
//
//  Created by CaiJingPeng on 13-9-29.
//  Copyright (c) 2013年 wpf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ETNoticPicture;

@interface ETNotice : NSManagedObject

@property (nonatomic, retain) NSString * addtime;
@property (nonatomic, retain) NSString * haveisconfirm;
@property (nonatomic, retain) NSString * isconfirm;
@property (nonatomic, retain) NSString * isteacher;
@property (nonatomic, retain) NSString * noticecontent;
@property (nonatomic, retain) NSString * noticeid;
@property (nonatomic, retain) NSString * noticekey;
@property (nonatomic, retain) NSString * noticetitle;
@property (nonatomic, retain) NSSet *pictures;
@end

@interface ETNotice (CoreDataGeneratedAccessors)

- (void)addPicturesObject:(ETNoticPicture *)value;
- (void)removePicturesObject:(ETNoticPicture *)value;
- (void)addPictures:(NSSet *)values;
- (void)removePictures:(NSSet *)values;

@end
