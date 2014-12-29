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

static GKSocket *currentSocket=nil;
@implementation GKSocket
@synthesize openBlock,streamBlock,cBlock;
//+(GKSocket *)instanceddns:(NSString *)ddns port:(NSString *)port block:(OpenStream)block
//{
//
//   
//    if(currentSocket==nil)
//    {
//        currentSocket=[[GKSocket alloc]init];
//    }
//    return currentSocket;
//}
-(id)init
{
    if(self=[super init])
    {
        isConnect=NO;
          ffmengQueue=dispatch_queue_create("com.guokr.mobi.ffmpeg", NULL);
        //[self createNewThread];
    }
    return self;
}
-(void)connectwithddns:(NSString *)ddns port:(NSString *)prot isConnect:(BOOL)connect block:(OpenStream)block;
{
    
    self.openBlock=block;
    isConnect=connect;
    m_pRecvBuff=(Byte *)malloc(Net_LAYER_STRUCT_LEN*sizeof(Byte));
    m_pStreamData=(Byte *)malloc(512*1024*sizeof(Byte));
    m_iPreRecvLen=0;
    m_iPackageLen=0;
    m_iFrameLen=0;
    isInputOpen=NO;
    isOutputOpen=NO;
    isConnect=connect;
    bufferdata=[[NSMutableData alloc]init];
    [self initNetworkCommunicationddns:ddns port:prot];
}
//-(id)initwithddns:(NSString *)ddns port:(NSString *)prot block:(OpenStream)block
//{
//    if(self=[super init])
//    {
//        self.openBlock=block;
//        m_pRecvBuff=(Byte *)malloc(Net_LAYER_STRUCT_LEN*sizeof(Byte));
//        m_pStreamData=(Byte *)malloc(512*1024*sizeof(Byte));
//        m_iPreRecvLen=0;
//        m_iPackageLen=0;
//        m_iFrameLen=0;
//        isOpen=NO;
//        bufferdata=[[NSMutableData alloc]init];
//        [self initNetworkCommunicationddns:ddns port:prot];
//    }
//    
//    return self;
//}

-(void)initNetworkCommunicationddns:(NSString *)ddns port:(NSString *)prot
{

    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    //CFStreamCreatePairWithSocketToHost(NULL, (CFStringRef)@"222.128.71.186", 600, &readStream, &writeStream);
    //222.128.71.186   //221.122.97.78  //123.196.114.83
    CFStreamCreatePairWithSocketToHost(NULL, (CFStringRef)ddns, [prot intValue], &readStream, &writeStream);
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
            if([theStream isEqual:inputStream])
            {
                NSLog(@"ddd");
                isInputOpen=YES;
            }
            if([theStream isEqual:outputStream])
            {
                NSLog(@"dddff");
                isOutputOpen=YES;
            }
			break;
            
		case NSStreamEventHasBytesAvailable:
            if (theStream == inputStream)
              
            dispatch_async(ffmengQueue, ^{
                [self RecvData];
            });

			break;
            
		case NSStreamEventErrorOccurred:
            //[self];
			NSLog(@"Can not connect to the host! %@",theStream.streamError.description);
            
            if(openBlock)
            {
                openBlock(NO,nil);
            }
            
//            cBlock(false,nil);
//            streamBlock(nil,0,theStream.streamError);
           // NSData *data, int length,NSError *error
            [self cleanUpStream];
			break;
            
		case NSStreamEventEndEncountered:
            NSLog(@"error socket %@",theStream.streamError);
            [self cleanUpStream];
			break;
            
		default:
            if(isConnect)
            {
                if(isOutputOpen && isInputOpen)
                {
                    openBlock(true,nil);
                }
            }

	}
    
}

//-(void)createNewThread
//{
//    //[self performSelectorInBackground:@selector(RecvData) withObject:nil];
//    [NSThread detachNewThreadSelector:@selector(RecvData:) toTarget:self withObject:nil];
//}
-(NSInteger)RecvData
{
   
    NSInteger iRecvBytes=-1;
    int iHeadLen=ALIGN_HEADLEN-ALIGNMENT;//25
    NET_LAYER *pPackage;
    int	 iDataType;
    int  iDataLen;
    NSInteger  iLeftBytes=0;
	while(1)
	{
    RecvData:
		 iRecvBytes = [inputStream read:(uint8_t *)m_pRecvBuff+m_iPreRecvLen maxLength:Net_LAYER_STRUCT_LEN-m_iPreRecvLen];
		if(iRecvBytes <= 0 )
		{
			//iRecvBytes=-1;
			goto MyEnd;
		}
		else
		{
			if(iRecvBytes+m_iPreRecvLen<iHeadLen)//–°”⁄25
			{
				m_iPreRecvLen+=iRecvBytes;
				goto RecvData;
			}
			else
			{
            ProcessData:
				pPackage=(NET_LAYER *)m_pRecvBuff;
				m_iPackageLen=pPackage->iActLength;
				if(m_iPreRecvLen+iRecvBytes>=m_iPackageLen)
				{
					iDataType=pPackage->bDataType;
					iDataLen=m_iPackageLen-ALIGN_HEADLEN;//ºı28
                    if(iDataLen==12||iDataType==9)
                    {
                        memcpy(m_pStreamData+m_iFrameLen,pPackage->cBuffer,iDataLen);//Œ¥◊ˆ◊Ó¥Ûµ•÷°–£—È......,ø…ƒ‹‘ΩΩÁ
                        m_iFrameLen+=iDataLen;
                    }
                    if(iDataType==12||iDataType==9)//DATA_TYPE_SMS_CMD,或者 DATA_TYPE_REAL_XML
                    {
                        if(pPackage->iBlockEndFlag)
                        {
                            [bufferdata appendBytes:m_pStreamData length:m_iFrameLen];
                            //[NSThread sleepForTimeInterval:40/1000.0f];
                          
                            NSStringEncoding encoding =CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
                            NSString *outxml=[[NSString alloc]initWithData:bufferdata encoding:encoding];
                             cBlock(true,outxml);
                            [bufferdata setLength:0];

                        }
                        else
                        {
                               [bufferdata appendBytes:pPackage->cBuffer length:m_iFrameLen];
                        }
                        
                        m_iFrameLen=0;

                        
                    }
					else if(iDataType==13)//“Ù ”∆µ ˝æ›
					{
						if(pPackage->byFilepercentOrFrameType==0||pPackage->byFilepercentOrFrameType==1)//BP÷°ªÚI÷°
						{
							memcpy(m_pStreamData+m_iFrameLen,pPackage->cBuffer,iDataLen);//Œ¥◊ˆ◊Ó¥Ûµ•÷°–£—È......,ø…ƒ‹‘ΩΩÁ
							m_iFrameLen+=iDataLen;
						}
						if(pPackage->iBlockEndFlag)
						{
							if(pPackage->byFilepercentOrFrameType==0||pPackage->byFilepercentOrFrameType==1)//BP÷°ªÚI÷°
							{
                                if(pPackage->iBlockEndFlag)
                                {

                                    
                                   //
                                   //  [NSThread sleepForTimeInterval:40/1000.0f];
                                    [bufferdata appendBytes:m_pStreamData length:m_iFrameLen];
                                    streamBlock(bufferdata,m_iFrameLen,nil);
                                    [bufferdata setLength:0];
                                    

                                }
                                else
                                {
                              
                                    [bufferdata appendBytes:pPackage->cBuffer length:m_iFrameLen];
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
						if(pPackage->iBlockEndFlag)//≤∞¸µƒ◊Ó∫Û“ª∞¸
						{
                            if(iDataType==13)
                            {
                                if(pPackage->byFilepercentOrFrameType==0||pPackage->byFilepercentOrFrameType==1)//BP÷°ªÚI÷°
                                {

                                }
                                else
                                {


                                }
                            }
                            else if(iDataType==12||iDataType==9)
                            {
                                
                               
                            }
                            break;

                         
						}
						else
						{
							continue;
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
							goto ProcessData;
						}
					}
				}
				else//µ•∞¸…Ÿ”⁄pPackage->iActLength
				{
					m_iPreRecvLen+=iRecvBytes;
					goto RecvData;
				}
			}
		}
	}
	return iRecvBytes;
MyEnd:
	return -1;
}

- (void)cleanUpStream
{
    if(inputStream)
    {
        [inputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        [inputStream close];
        
        inputStream = nil;
    }
    if(outputStream)
    {
        [outputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        [outputStream close];
        
        outputStream = nil;
    }

    if(currentSocket)
    {
        free(m_pRecvBuff);
        free(m_pStreamData);
        [currentSocket release];
        currentSocket=nil;
    }

}

-(int)sendData:(char *)pSrc length:(int)iLength type:(int)iDataType isConnect:(BOOL)connect block:(streamCompleteBlock)block streamBlock:(StreamBlock)strBlock
{
    isConnect=NO;
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
    self.cBlock=nil;
    self.streamBlock=nil;
    self.openBlock=nil;
    free(m_pRecvBuff);
    free(m_pStreamData);
    
    
}
@end
