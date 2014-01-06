//
//  ETClassShare.h
//  etonkids-iphone
//
//  Created by CaiJingPeng on 13-9-12.
//  Copyright (c) 2013年 wpf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


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
@end

@interface ETClassShare (CoreDataGeneratedAccessors)

- (void)addPicturesObject:(NSManagedObject *)value;
- (void)removePicturesObject:(NSManagedObject *)value;
- (void)addPictures:(NSSet *)values;
- (void)removePictures:(NSSet *)values;

@end
