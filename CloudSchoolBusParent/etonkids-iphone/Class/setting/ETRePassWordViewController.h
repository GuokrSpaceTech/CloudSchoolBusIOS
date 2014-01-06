

/**
 *	@file   ETRePassWordViewController
 *  @brief  更改密码界面
 *  @author
 *  @version 2.2
 *  @date   2013-09-03
 */

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "EKRequest.h"
#import "ETCustomAlertView.h"

@interface ETRePassWordViewController : UIViewController<ETCustomAlertViewDelegate,UITextFieldDelegate,EKProtocol>
{
    MBProgressHUD *HUD;
    UIImageView *navigationBackView;
    UIButton *leftButton;
    UIButton *rightButton;
    UIView  *middleView;
    UILabel  *middleLabel;
}
@property (retain, nonatomic) IBOutlet UITextField *conformPassWord;
@property (retain, nonatomic) IBOutlet UITextField *newPassWord;
@property (retain, nonatomic) IBOutlet UITextField *oldPassWord;


@end
