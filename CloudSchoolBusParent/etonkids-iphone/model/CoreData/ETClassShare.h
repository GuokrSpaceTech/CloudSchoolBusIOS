//
//  ETClassShare.h
//  etonkids-iphone
//
//  Created by wen peifang on 14-7-25.
//  Copyright (c) 2014年 wpf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ETActicalPicture, ETActicalTag;

@interface ETClassShare : NSManagedObject

@property (nonatomic, retain) NSString * articleid;
@property (nonatomic, retain) NSString * articlekey;
@property (nonatomic, retain) NSString * commentnum;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSString * havezan;
@property (nonatomic, retain) NSString * publishtime;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * upnum;
@property (nonatomic, retain) NSSet *pictures;
@property (nonatomic, retain) NSSet *tags;
@end

@interface ETClassShare (CoreDataGeneratedAccessors)

- (void)addPicturesObject:(ETActicalPicture *)value;
- (void)removePicturesObject:(ETActicalPicture *)value;
- (void)addPictures:(NSSet *)values;
- (void)removePictures:(NSSet *)values;

- (void)addTagsObject:(ETActicalTag *)value;
- (void)removeTagsObject:(ETActicalTag *)value;
- (void)addTags:(NSSet *)values;
- (void)removeTags:(NSSet *)values;

@end
