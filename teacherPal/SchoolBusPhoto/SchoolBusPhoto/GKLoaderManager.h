//
//  GKLoaderManager.h
//  SchoolBusPhoto
//
//  Created by wen peifang on 13-10-21.
//  Copyright (c) 2013年 mactop. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GKUpWraper.h"
#import "UpLoader.h"
#import "GKUserLogin.h"
#import "GKUpQueue.h"
#define UPLOADING 1
#define UPDOWN 2
@interface GKLoaderManager : NSObject
{
    NSMutableArray *upArr;
}

@property (nonatomic,retain)NSMutableArray *upArr;

@property (nonatomic,retain)   NSMutableArray *commandArray;


+(GKLoaderManager *)createLoaderManager;
-(void)getLoadingPicFromCoreData;
//-(BOOL)addNewPicToCoreData:(NSString *)path name:(NSString *)name iSloading:(NSNumber *)isUploading nameId:(NSString *)nameId studentId:(NSString *)std time:(NSNumber *)time fsize:(NSNumber *)fize classID:(NSNumber *)classid intro:(NSString *)intro data:(NSData *)imageData tag:(NSString *)tag;
-(void)addWraperToArr:(NSString *)path name:(NSString *)name iSloading:(NSNumber *)isUploading nameId:(NSString *)nameId studentId:(NSString *)tid time:(NSNumber *)time fsize:(NSNumber *)fize classID:(NSNumber *)classid intro:(NSString *)intro data:(NSData *)imageData tag:(NSString *)tag;
-(void)removeWraperFromArr:(NSString *)key;
//-(void)changeCoreDataLoadingState:(NSString *)nameid;
//-(BOOL)deleteCoreDataLoadingState:(NSString *)nameid;
-(NSArray *)getAllUploaderPhotoFromCoreData;
-(void)startUpLoader;

-(void)toTail:(NSString *)key; //把上传失败的放到队尾

-(UpLoader *)getOneData:(NSString *)strId;


-(void)setQueueStop;
-(void)setQueueStart;
@end
