//
//  CYDoctor.h
//  etonkids-iphone
//
//  Created by wen peifang on 14-6-30.
//  Copyright (c) 2014年 wpf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CYDoctor : NSObject
@property (nonatomic,retain)NSString *docid;
//@property (nonatomic,assign)BOOL to_doc;
//@property (nonatomic,assign)int start;
//@property (nonatomic,assign)float price;
@property (nonatomic,retain)NSString *name;
@property (nonatomic,retain)NSString *image;
@property (nonatomic,retain)NSString *title;
//@property (nonatomic,assign)BOOL need_assess;
@property (nonatomic,retain)NSString *hospital;
//@property (nonatomic,assign)BOOL is_viewed;
@property (nonatomic,retain)NSString *level_title;
//@property (nonatomic,retain)NSString *clinic_no;
@property (nonatomic,retain)NSString *clinic;
@end
