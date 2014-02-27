
#import <UIKit/UIKit.h>
#import "WXApi.h"
#import "WeiboRequest.h"
#import "MBProgressHUD.h"
#import "WeiboSignIn.h"
#import "TCWBEngine.h"
#import "WeiboAccounts.h"
#import "ETCustomAlertView.h"

@interface ETShareViewController : UIViewController<WeiboRequestDelegate,WeiboSignInDelegate>
{
    TCWBEngine          *wbEngine;
    NSString *content;
    NSString  *pic;
    NSInteger shareType;
    enum WXScene _scene;
    NSData *imageData;
    MBProgressHUD *HUD;
    
    WeiboSignIn *_weiboSignIn;
    
    
    
}

@property (nonatomic, retain) TCWBEngine    *wbEngine;
@property NSInteger shareType;
@property(nonatomic,retain)NSString *content;
@property(nonatomic,retain)NSData *imageData;
@property(nonatomic,retain)NSString *pic;



@property (retain, nonatomic) IBOutlet UIImageView *textBackGround;

@property (retain, nonatomic) IBOutlet UITextView *shareContent;
@property (retain, nonatomic) IBOutlet UIImageView *shareImageView;

@end
