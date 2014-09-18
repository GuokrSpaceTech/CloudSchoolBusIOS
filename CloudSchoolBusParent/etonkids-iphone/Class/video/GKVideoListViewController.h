//
//  GKVideoListViewController.h
//  etonkids-iphone
//
//  Created by wen peifang on 14-9-16.
//  Copyright (c) 2014年 wpf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GKVideoListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSInputStream * inputStream;
    NSOutputStream * outputStream;
    
    

	int				m_iPreRecvLen;
	int				m_iPackageLen;
	//CString			m_sRecvXmlData;

	Byte *			m_pRecvBuff;
	



}
@property (nonatomic,retain)NSMutableArray *arrList;
@property (nonatomic,retain)UITableView *_tableView;
@end
