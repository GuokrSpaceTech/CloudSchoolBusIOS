//
//  Photo.h
//  CloudSchoolBusTeacher
//
//  Created by HELLO  on 15/12/14.
//  Copyright © 2015年 BeiJingYinChuang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
@interface Photo : NSObject
@property (nonatomic,strong)ALAsset * asset;
@property (nonatomic,assign)BOOL isSelected;
@end
