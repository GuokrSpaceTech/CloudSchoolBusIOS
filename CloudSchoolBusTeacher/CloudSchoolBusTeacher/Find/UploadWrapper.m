//
//  UploadWrapper.m
//  CloudSchoolBusTeacher
//
//  Created by macbook on 15/12/15.
//  Copyright © 2015年 BeiJingYinChuang. All rights reserved.
//

#import "UploadWrapper.h"
#import "CBDateBase.h"
#import <UIKit/UIImage.h>
#import <AssetsLibrary/ALAsset.h>
#import <AssetsLibrary/ALAssetsLibrary.h>
#import <AssetsLibrary/ALAssetsGroup.h>
#import <AssetsLibrary/ALAssetRepresentation.h>

@interface UploadWrapper()<EKProtocol>
{
    UploadRecord *currentUploadingRecord;
}
@end

static UploadWrapper * instance = nil;
@implementation UploadWrapper
+(UploadWrapper *)shareInstance
{
    if(instance == nil)
    {
        instance = [[self alloc]init];
    }
    return instance;
}

-(instancetype)init
{
    if(self = [super init])
    {
    }
    return self;
}

-(void)uploadFile
{
    [[CBDateBase sharedDatabase] fetchUploadRecord:^(UploadRecord *record) {
        ALAssetsLibrary *lib = [[ALAssetsLibrary alloc] init];
        [lib assetForURL:[NSURL URLWithString:record.fbody] resultBlock:^(ALAsset *asset)
         {
             ALAssetRepresentation *assetRepresentation =[asset defaultRepresentation];
             CGImageRef imageReference = [assetRepresentation fullScreenImage];
             //            UIImageOrientation imageOrientation = (UIImageOrientation)[assetRepresentation orientation];
             //            CGFloat imageScale = [assetRepresentation scale];
             UIImage *image =[[UIImage alloc] initWithCGImage:imageReference];
             if (image != nil){
                 NSData *imageData = UIImageJPEGRepresentation(image, 1.0);

                 NSDictionary *paramDict = @{@"pickey":record.pickey,
                                             @"pictype":record.pictype,
                                             @"fbody":imageData,
                                             @"fname":record.fname,
                                             @"ftime":record.ftime};
                 currentUploadingRecord = record;
                 [[EKRequest Instance] EKHTTPRequest:UPLOAD parameters:paramDict requestMethod:POST forDelegate:self];
                 NSLog(@"==UPLOADING== Pickey:%@ Filename:%@",record.pickey,record.fname);
             } else {
                 NSLog(@"Failed to create the image.");
             }
         }
            failureBlock:^(NSError *error)
         {}];
    }];
}
-(void) getEKResponse:(id) response forMethod:(RequestFunction) method resultCode:(int) code withParam:(NSDictionary *)param
{
    if(method == UPLOAD)
    {
        NSString *pickey = [param objectForKey:@"pickey"];
        NSString *fname  = [param objectForKey:@"fname"];
        if(code == 1)
        {
            //Mark upload Success for the upload record
            [[CBDateBase sharedDatabase] updateUploadRecordPickey:pickey fileName:fname status:@"1"]; //0,fail, 1,success, 2,waiting 3,uploading
            
            [[CBDateBase sharedDatabase] countUnsentRecordsWithPickkey:pickey completion:^(int count) {
                if(count == 0)
                {
                    NSDictionary *paramDict = @{@"pickey":currentUploadingRecord.pickey,
                                                @"pictype":currentUploadingRecord.pictype,
                                                @"classid":currentUploadingRecord.classid,
                                                @"teacherid":currentUploadingRecord.teacherid,
                                                @"content":currentUploadingRecord.content,
                                                @"studentids":currentUploadingRecord.studentids,
                                                @"tagids":currentUploadingRecord.tagids};
                    //Send OVER Message
                    [[EKRequest Instance] EKHTTPRequest:UPLOADOVER parameters:paramDict requestMethod:POST forDelegate:self];
                    NSLog(@"==UPLOADING COMPLETED, SENT OVER MESSAGE == Pickey:%@",pickey);
                } else {
                }
            }];
            
            //Continue upload
            [self uploadFile];
            
        } else {
            //Mark upload Failure for the upload record
            [[CBDateBase sharedDatabase] updateUploadRecordPickey:currentUploadingRecord.pickey fileName:currentUploadingRecord.fname status:@"0"]; //0,fail, 1,success, 2,waiting 3,uploading
            NSLog(@"==UPLOADING FAILIED== Pickey:%@ Filename:%@",pickey,fname);
            
            //Continue on next upload
            [self uploadFile];
        }
    }
    else if(method == UPLOADOVER)
    {
        NSString *pickey = [param objectForKey:@"pickey"];
        if(code == 1)
        {
            NSLog(@"==UPLOADING OVER RESPONSE SUCCESS == Pickey:%@",pickey);
            //Remove all the upload records from DB
            [[CBDateBase sharedDatabase] removeUploadRecordWithPickey:pickey];
            
            //Continue on next upload
            [self uploadFile];
        }
        else
        {
            //Retry sending Over message
            NSDictionary *paramDict = @{@"pickey":currentUploadingRecord.pickey,
                                        @"pictype":currentUploadingRecord.pictype,
                                        @"classid":currentUploadingRecord.classid,
                                        @"teacherid":currentUploadingRecord.teacherid,
                                        @"content":currentUploadingRecord.content,
                                        @"studentids":currentUploadingRecord.studentids,
                                        @"tagids":currentUploadingRecord.tagids};
            
            //Send OVER Message
            [[EKRequest Instance] EKHTTPRequest:UPLOADOVER parameters:paramDict requestMethod:POST forDelegate:self];
        }
    }
}

-(void) getErrorInfo:(NSError *) error forMethod:(RequestFunction) method
{
    if(method == UPLOAD)
    {
        //Mark upload Failure for the upload record
        [[CBDateBase sharedDatabase] updateUploadRecordPickey:currentUploadingRecord.pickey fileName:currentUploadingRecord.fname status:@"0"]; //0,fail, 1,success, 2,waiting 3,uploading
        NSLog(@"==UPLOADING FAILIED== Pickey:%@ Filename:%@",currentUploadingRecord.pickey,currentUploadingRecord.fname);
        
        //Continue on next upload
        [self uploadFile];
    }
    else if (method == UPLOADOVER)
    {
        //Retry sending Over message
        NSDictionary *paramDict = @{@"pickey":currentUploadingRecord.pickey, @"fname":currentUploadingRecord.fname, @"ftime":currentUploadingRecord.ftime, @"pictype":currentUploadingRecord.pictype};
        
        //Send OVER Message
        [[EKRequest Instance] EKHTTPRequest:UPLOADOVER parameters:paramDict requestMethod:POST forDelegate:self];
    }
}
@end
