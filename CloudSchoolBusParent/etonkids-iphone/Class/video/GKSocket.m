//
//  GKSocket.m
//  etonkids-iphone
//
//  Created by wen peifang on 14-9-16.
//  Copyright (c) 2014年 wpf. All rights reserved.
//

#import "GKSocket.h"

#import "ETKids.h"
#define NET_BUFFER_LEN			(8*1024)
#define ALIGNMENT				3
#define ALIGN_HEADLEN					(sizeof(int)+sizeof(Byte)+3*sizeof(Byte)+4*sizeof(int)+sizeof(Byte)+ALIGNMENT)	//28字节长,包含3个对齐字节




typedef struct
{
    int 	iActLength;
	Byte 	bDataType;
	Byte 	bReserved[3];
    int		iTotalSplits;
    int		iCurSplit;
    int 	iBlockHeadFlag;
    int 	iBlockEndFlag;
    Byte 	byFilepercentOrFrameType;
    char 	cBuffer[NET_BUFFER_LEN+ALIGNMENT];
}NET_LAYER;
#define Net_LAYER_STRUCT_LEN	sizeof(NET_LAYER)

static GKSocket *socket=nil;
@implementation GKSocket
+(GKSocket *)instance
{
    if(socket==nil)
    {
        socket=[[GKSocket alloc]init];
    }
    return socket;
}
-(id)init
{
    if(self=[super init])
    {
        m_pRecvBuff=(Byte *)malloc(Net_LAYER_STRUCT_LEN*sizeof(Byte));
        
         m_pStreamData=(Byte *)malloc(512*1024*sizeof(Byte));
        
        m_iPreRecvLen=0;
        m_iPackageLen=0;
        m_iFrameLen=0;
        [self initNetworkCommunication];

    }
    
    return self;
}

-(void)initNetworkCommunication
{

    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    //CFStreamCreatePairWithSocketToHost(NULL, (CFStringRef)@"222.128.71.186", 600, &readStream, &writeStream);
    //222.128.71.186   //221.122.97.78  //123.196.114.83
    CFStreamCreatePairWithSocketToHost(NULL, (CFStringRef)@"222.128.71.186", 600, &readStream, &writeStream);
    inputStream = (NSInputStream *)readStream;
    outputStream = (NSOutputStream *)writeStream;
    
    [inputStream setDelegate:self];
    [outputStream setDelegate:self];
    [inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [inputStream open];
    [outputStream open];
    
}
- (void)stream:(NSStream *)theStream handleEvent:(NSStreamEvent)streamEvent {
    
    
    
	switch (streamEvent) {
            
		case NSStreamEventOpenCompleted:
			NSLog(@"Stream opened");
			break;
            
		case NSStreamEventHasBytesAvailable:
            if (theStream == inputStream) {
                
                int iRecvBytes=-1;
                int iHeadLen=ALIGN_HEADLEN-ALIGNMENT;//25
                NET_LAYER *pPackage;
                //BOOL bTotalEnd=FALSE;
                int	 iDataType;
                int  iDataLen;
                //char *sTemp="";
                NSString * sTemp = @"";
                int  iLeftBytes=0;
                
                while ([inputStream hasBytesAvailable]) {
                    iRecvBytes = [inputStream read:(uint8_t *)m_pRecvBuff+m_iPreRecvLen maxLength:Net_LAYER_STRUCT_LEN-m_iPreRecvLen];
                    if(iRecvBytes<=0)
                    {
                        iRecvBytes=-1;
                        /// /return -1;
                    }
                    else
                    {
                        if(iRecvBytes+m_iPreRecvLen<iHeadLen)//–°”⁄25
                        {
                            m_iPreRecvLen+=iRecvBytes;
                           // goto RecvData;
                        }
                        else
                        {
                            pPackage=(NET_LAYER *)m_pRecvBuff;
                            m_iPackageLen=pPackage->iActLength;
                            if(m_iPreRecvLen+iRecvBytes>=m_iPackageLen)
                            {
                                iDataType=pPackage->bDataType;
                                iDataLen=m_iPackageLen-ALIGN_HEADLEN;
                                if(iDataType==12||iDataType==9)//DATA_TYPE_SMS_CMD,或者 DATA_TYPE_REAL_XML
                                {
                                    char * temp=pPackage->cBuffer;
                                    
                                    NSStringEncoding encoding =CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
                                    NSString *output = [[NSString alloc] initWithBytes:temp length:strlen(temp) encoding:encoding];
                                    
                                    sTemp= [sTemp stringByAppendingFormat:@"%@",output];
                                    NSLog(@"%@",sTemp);
                                    
                                    //sTemp.GetBufferSetLength(iDataLen)®;
                                    //m_sRecvXmlData+=sTemp;
                                }
                                else if(iDataType==13)//音视频数据
                                {
                                    if(pPackage->byFilepercentOrFrameType==0||pPackage->byFilepercentOrFrameType==1)////BP帧或I帧
                                    {
                                        memcpy(m_pStreamData+m_iFrameLen,pPackage->cBuffer,iDataLen);////未做最大单帧校验......,可能越界
                                        m_iFrameLen+=iDataLen;
                                    }
                                    if(pPackage->byFilepercentOrFrameType==2)
                                    {
                                           NSLog(@"byFilepercentOrFrameType:--->%d",pPackage->byFilepercentOrFrameType);
                                            char * temp=pPackage->cBuffer;
                                        
                                         streamBlock(YES,temp);
                                    }
                                    if(pPackage->iBlockEndFlag)
                                    {
                                        if(pPackage->byFilepercentOrFrameType==0||pPackage->byFilepercentOrFrameType==1)//BP÷°ªÚI÷°
                                        {
                                            NSLog(@"byFilepercentOrFrameType:--->%d",pPackage->byFilepercentOrFrameType);
                                            NSLog(@"iBlockHeadFlag:--->%d",pPackage->iBlockHeadFlag);
                                            //if(pPackage->byFilepercentOrFrameType==1)
                                            {
                                               // NSLog(@"Len:%d FrameType:%d\n",m_iFrameLen,pPackage->byFilepercentOrFrameType);
                                                
                                                 char * temp=pPackage->cBuffer;
                                               // NSData *date=[NSData dataWithBytes:temp length:strlen(temp)];
                                              //  NSLog(@"data:%@",date);
                                                
                                                streamBlock(NO,temp);
                                                                                              //pPackage->b
//                                                CString sTemp;
//                                                sTemp.Format("Len:%d FrameType:%d\n",m_iFrameLen,pPackage->byFilepercentOrFrameType);
//                                                OutputDebugString(sTemp);
//                                                int a=9;
                                            }
                           
                                            m_iFrameLen=0;
                                        }
                                    }
                                    

                                }
                                iLeftBytes=m_iPreRecvLen+iRecvBytes-m_iPackageLen;
                                if(iLeftBytes==0)
                                {
                                    
                                    m_iPreRecvLen=0;//∏¥Œª
                                    m_iPackageLen=0;
                                    
                                    if(pPackage->iBlockEndFlag)///拆包的最后一包
                                    {
                                        cBlock(true,sTemp);
                                        if(iDataType==13)
                                        {
                                            if(pPackage->byFilepercentOrFrameType==0||pPackage->byFilepercentOrFrameType==1)//BP÷°ªÚI÷°
                                            {
                                                
                                            }
                                        }
                                        break;
                                    }
                                    else
                                    {
                                        //continue;
                                    }
                                }
                                if(iLeftBytes>0)
                                {
                                    memmove((char *)m_pRecvBuff,(char *)m_pRecvBuff+m_iPackageLen,iLeftBytes);
                                    m_iPreRecvLen=iLeftBytes;
                                    m_iPackageLen=0;
                                    if(iLeftBytes<iHeadLen)
                                    {
                                        continue;
                                    }
                                    else
                                    {
                                        iRecvBytes=0;
                                        // goto ProcessData;
                                    }
                                }
                            }
                            else//单包少于pPackage->iActLength
                            {
                                m_iPreRecvLen+=iRecvBytes;
                                // goto RecvData;
                            }
                        }
                       
                        
                    }

                }
            }
			break;
            
		case NSStreamEventErrorOccurred:
            //[self];
			NSLog(@"Can not connect to the host!");
            cBlock(false,nil);
            [self cleanUpStream];
			break;
            
		case NSStreamEventEndEncountered:
			break;
            
		default:
			NSLog(@"Unknown event");
	}
    
}
- (void)cleanUpStream
{
    [inputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [inputStream close];
    
    inputStream = nil;
    
    
    [outputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [outputStream close];
    
    outputStream = nil;
    
    free(m_pRecvBuff);
    free(m_pStreamData);
}

-(int)sendData:(char *)pSrc length:(int)iLength type:(int)iDataType block:(CompleteBlock)block streamBlock:(StreamBlock)strBlock;
{
    [cBlock release];
    cBlock=[block copy];
    
    [streamBlock release];
    streamBlock=[strBlock copy];
    
    int iSendBytes=0;
	int i;
	char *pSrcOffset;
	NET_LAYER	_NetLayer;
	int iSplit;				//如果大于8K，拆分的包数
	int iLastBlockLength;	//拆分后，前面包有效数据长度为8K，最后一包的长度
	
	_NetLayer.bDataType=iDataType;
	_NetLayer.byFilepercentOrFrameType=0;//无效
	if (iLength%NET_BUFFER_LEN==0)
	{
		iSplit=iLength/NET_BUFFER_LEN;
		iLastBlockLength=NET_BUFFER_LEN;
	}
	else
	{
		iSplit=(iLength+NET_BUFFER_LEN)/NET_BUFFER_LEN;
		iLastBlockLength=iLength%NET_BUFFER_LEN;
	}
	_NetLayer.iTotalSplits=iSplit;
	for(i=0;i<iSplit;i++)
	{
		_NetLayer.iCurSplit=i;
		pSrcOffset=pSrc+i*NET_BUFFER_LEN;
		if (i==iSplit-1)//最后一包
		{
			_NetLayer.iActLength=ALIGN_HEADLEN+iLastBlockLength;
			memcpy(&_NetLayer.cBuffer,pSrcOffset,iLastBlockLength);
			if(iSplit==1)
			{
				_NetLayer.iBlockHeadFlag=TRUE;
				_NetLayer.iBlockEndFlag=TRUE;
			}
			else
			{
				_NetLayer.iBlockHeadFlag=FALSE;
				_NetLayer.iBlockEndFlag=TRUE;
			}
		}
		else//前面的包
		{
			_NetLayer.iActLength=Net_LAYER_STRUCT_LEN;
			memcpy(_NetLayer.cBuffer,pSrcOffset,NET_BUFFER_LEN);
			if(i==0)
			{
				_NetLayer.iBlockHeadFlag=TRUE;
				_NetLayer.iBlockEndFlag=FALSE;
			}
			else
			{
				_NetLayer.iBlockHeadFlag=FALSE;
				_NetLayer.iBlockEndFlag=FALSE;
			}
		}
		//iSendBytes=send(m_hSocket,(char *)&_NetLayer,_NetLayer.iActLength,0);
        [outputStream write:(uint8_t *)&_NetLayer maxLength:_NetLayer.iActLength];
        
        
        //		if(iSendBytes<=0)//2011-12-26更改，ARP冲突，有可能数据发送为0
        //		{
        //			goto MyEnd;
        //		}
	}
	return iSendBytes;
    
}

-(void)closeSocket
{
    [inputStream close];
    [outputStream close];
    free(m_pRecvBuff);
    free(m_pStreamData);
    
    
}
@end
