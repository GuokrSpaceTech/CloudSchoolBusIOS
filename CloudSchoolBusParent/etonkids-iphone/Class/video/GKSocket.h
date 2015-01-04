//
//  GKSocket.h
//  etonkids-iphone
//
//  Created by wen peifang on 14-9-16.
//  Copyright (c) 2014年 wpf. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^streamCompleteBlock)(BOOL success,NSString * result);

typedef void (^StreamBlock)( NSData *data, int length,NSError *error);

typedef void(^OpenStream)(BOOL success,NSString *result);
@interface GKSocket : NSObject<NSStreamDelegate>
{
    NSInputStream * inputStream;
    NSOutputStream * outputStream;
    
//    streamCompleteBlock cBlock;
//    StreamBlock streamBlock;
    
	NSUInteger				m_iPreRecvLen;
	int				m_iPackageLen;
	//CString			m_sRecvXmlData;
    
	Byte *			m_pRecvBuff;
    
    Byte*			m_pStreamData;
    //Byte*			m_xmlpStreamData;
    
    int				m_iFrameLen;
    
    NSMutableData *bufferdata;
    
    BOOL isInputOpen;
    BOOL isOutputOpen;
    BOOL isConnect;

    dispatch_queue_t ffmengQueue;
}
@property (nonatomic,copy)streamCompleteBlock cBlock;
@property (nonatomic,copy)StreamBlock streamBlock;
@property (nonatomic,copy)OpenStream openBlock;


//+(GKSocket *)instance;

- (void)cleanUpStream;
-(void)connectwithddns:(NSString *)ddns port:(NSString *)prot isConnect:(BOOL)connect block:(OpenStream)block;
-(int)sendData:(char *)pSrc length:(int)iLength type:(int)iDataType isConnect:(BOOL)connect block:(streamCompleteBlock)block streamBlock:(StreamBlock)strBlock;
//-(id)initwithddns:(NSString *)ddns port:(NSString *)prot block:(OpenStream)block;
//+(GKSocket *)instanceddns:(NSString *)ddns port:(NSString *)port block:(OpenStream)block;


@end
