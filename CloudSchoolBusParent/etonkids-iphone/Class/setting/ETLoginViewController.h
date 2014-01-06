

/**
 *	@file   ETLoginViewController
 *  @brief  用户登录主界面
 *  @author
 *  @version 2.2
 *  @date   2013-09-03
 */


#import <UIKit/UIKit.h>
#import "EKRequest.h"
#import "MBProgressHUD.h"
#import "ETCoreDataManager.h"
#import "ETCustomAlertView.h"

#define AUTOTAG 101    //自动登陆tag
#define REMEMBERP 102  //记住密码tag
@class TodoService;
@class LeveyTabBarController;

@interface ETLoginViewController : UIViewController<UITextFieldDelegate,UITextViewDelegate,ETCustomAlertViewDelegate,EKProtocol>//<WeiboSignInDelegate>
{
    MBProgressHUD *HUD;
    BOOL isExcute;
//    IBOutlet UILabel *remPwdLabel;
//    IBOutlet UILabel *autoLabel;
    
    NSArray *resultSelectChild;
    IBOutlet UIImageView *titleImgV;
    IBOutlet UIImageView *versionImgV;
    IBOutlet UIImageView *loginBackImgV;
    IBOutlet UIImageView *accountImgV;
    IBOutlet UIImageView *pwdImgV;
}

/// 程序主界面TabBar
@property (nonatomic, retain) LeveyTabBarController *leveyTabBarController;

/// 控制我的宝宝界面 Navigation
@property(nonatomic,retain)UINavigationController *childNavigation;
/// 控制班级分享界面 Navigation
@property(nonatomic,retain)UINavigationController *shareNavigation;
/// 控制通知消息界面 Navigation
@property(nonatomic,retain)UINavigationController *noticeNavigation;
/// 控制我的设置界面 Navigation
@property(nonatomic,retain)UINavigationController *setNavigation;

@property (retain, nonatomic) IBOutlet UITextField *userNameField;
@property (retain, nonatomic) IBOutlet UITextField *passWordField;


@property (retain, nonatomic) IBOutlet UIButton *loginBtn;


@property(retain,nonatomic)IBOutlet ETCustomAlertView   *Timealertview;
@property (nonatomic, retain) NSArray *resultSelectChild;
@property (nonatomic, retain) IBOutlet UIButton *forgetBt;


/// 登录按钮事件
- (IBAction)loginButonPressed:(id)sender;



/// 忘记密码按钮事件
- (IBAction)forget:(UIButton*)sender;

@end
