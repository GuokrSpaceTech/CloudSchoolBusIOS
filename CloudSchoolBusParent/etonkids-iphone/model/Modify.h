//
//  Modify.h
//  etonkids-iphone
//
//  Created by Simon on 13-6-26.
//  Copyright (c) 2013年 wpf. All rights reserved.
//

#import <Foundation/Foundation.h>
#define ModifyData [Modify getNeskyData]
@interface Modify : NSObject
{
    int  *count;
}
+(Modify*)getNeskyData;

@property(nonatomic,strong)NSString  *Age;
@property(nonatomic,strong)NSString  *Name;
@property(nonatomic,strong)NSString  *birthday;
@property(nonatomic,strong)NSString  *CNname;
@property(nonatomic,retain)NSString  *Classname;
@property(nonatomic,retain)NSString  *ENname;
@property(nonatomic,retain)NSString  *Schoolname;
@property(nonatomic,retain)NSArray *array;
@end
