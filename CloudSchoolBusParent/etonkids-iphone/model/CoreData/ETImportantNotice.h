//
//  ETImportantNotice.h
//  etonkids-iphone
//
//  Created by CaiJingPeng on 13-10-24.
//  Copyright (c) 2013年 wpf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ETNoticPicture;

@interface ETImportantNotice : NSManagedObject

@property (nonatomic, retain) NSString * addtime;
@property (nonatomic, retain) NSString * haveisconfirm;
@property (nonatomic, retain) NSString * isconfirm;
@property (nonatomic, retain) NSString * isteacher;
@property (nonatomic, retain) NSString * noticecontent;
@property (nonatomic, retain) NSString * noticeid;
@property (nonatomic, retain) NSString * noticekey;
@property (nonatomic, retain) NSString * noticetitle;
@property (nonatomic, retain) NSSet *importantpic;
@end

@interface ETImportantNotice (CoreDataGeneratedAccessors)

- (void)addImportantpicObject:(ETNoticPicture *)value;
- (void)removeImportantpicObject:(ETNoticPicture *)value;
- (void)addImportantpic:(NSSet *)values;
- (void)removeImportantpic:(NSSet *)values;

@end
