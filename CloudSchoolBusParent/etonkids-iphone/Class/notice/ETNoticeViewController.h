

/**
 *	@file   ETNoticeViewController
 *  @brief  通知消息界面
 *  @author
 *  @version 2.2
 *  @date   2013-09-03
 */

#import <UIKit/UIKit.h>
#import "ETBaseViewController.h"
#import "NoticeCell.h"
#import "MBProgressHUD.h"
#import <MessageUI/MessageUI.h>
#import "EKRequest.h"

typedef enum
{
    AllNotice = 0,
    ImportantNotice
    
}ChooseNoticeType;

@interface ETNoticeViewController : ETBaseViewController<noticeCelldelegate,MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,ETCustomAlertViewDelegate,UIActionSheetDelegate,UIGestureRecognizerDelegate,EKProtocol>
{
    NSMutableArray *arrList;
    MBProgressHUD *HUD;
    
    int  currentIndex;
    
    EGORefreshPos theRefreshPos;
    UIImage  *headImage;
    NoticeInfo *conformInfo;
    
//    UILabel *defaultlabel;
    
    RequestType reqType;
    
    UIImageView *selImgV;
    ChooseNoticeType currentType;
    
    BOOL isMore;
    BOOL isMoreAllNotice;
    BOOL isMoreImportant;
    
    
    BOOL isFirstLoading;
}

@property (nonatomic,retain) NoticeInfo *conformInfo;
@property (nonatomic,retain)NoticeInfo *_info;
//@property(nonatomic,retain) NSMutableArray *arrList;

@property BOOL isLoading;
@property(nonatomic,retain)IBOutlet UIImage *headImage;
@property(nonatomic,retain)NSString  *string;

@property (nonatomic, retain) NSDictionary *photoParam;
@property (nonatomic, retain) NSDictionary *noticParam;
@property (nonatomic, retain) NSDictionary *getNoticeParam;


@property (nonatomic, retain) NSMutableArray *allNoticeList;
@property (nonatomic, retain) NSMutableArray *importantList;
@property (nonatomic, retain) NSMutableArray *dataList;



@end
