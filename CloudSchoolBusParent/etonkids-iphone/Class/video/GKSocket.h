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

@interface GKSocket : NSObject<NSStreamDelegate>
{
    NSInputStream * inputStream;
    NSOutputStream * outputStream;
    
    streamCompleteBlock cBlock;
    StreamBlock streamBlock;
    
	int				m_iPreRecvLen;
	int				m_iPackageLen;
	//CString			m_sRecvXmlData;
    
	Byte *			m_pRecvBuff;
    
    Byte*			m_pStreamData;
    //Byte*			m_xmlpStreamData;
    
    int				m_iFrameLen;
    
    NSMutableData *bufferdata;


}

+(GKSocket *)instance;
-(void)initNetworkCommunication;
- (void)cleanUpStream;
-(int)sendData:(char *)pSrc length:(int)iLength type:(int)iDataType block:(streamCompleteBlock)block streamBlock:(StreamBlock)strBlock;

+(GKSocket *)instanceddns:(NSString *)ddns port:(NSString *)port;


@end
