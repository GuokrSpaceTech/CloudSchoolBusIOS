//
//  GKSocket.h
//  etonkids-iphone
//
//  Created by wen peifang on 14-9-16.
//  Copyright (c) 2014年 wpf. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^CompleteBlock)(BOOL success,NSString * result);

typedef void (^StreamBlock)(BOOL header, char * result);

@interface GKSocket : NSObject<NSStreamDelegate>
{
    NSInputStream * inputStream;
    NSOutputStream * outputStream;
    
    CompleteBlock cBlock;
    StreamBlock streamBlock;
    
	int				m_iPreRecvLen;
	int				m_iPackageLen;
	//CString			m_sRecvXmlData;
    
	Byte *			m_pRecvBuff;
    
    Byte*			m_pStreamData;
    int				m_iFrameLen;

}
+(GKSocket *)instance;
-(void)initNetworkCommunication;
-(int)sendData:(char *)pSrc length:(int)iLength type:(int)iDataType block:(CompleteBlock)block streamBlock:(StreamBlock)strBlock;




@end
