
#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "EKRequest.h"
#import "ETCustomAlertView.h"

@interface ETFeedBackViewController : UIViewController<UITextFieldDelegate,UITextViewDelegate,ETCustomAlertViewDelegate,EKProtocol>
{
    MBProgressHUD *HUD;
}
@property (retain, nonatomic) IBOutlet UITextField *emailField;
@property (retain, nonatomic) IBOutlet UITextView *feedContent;
@property (retain, nonatomic) IBOutlet UIButton *sendBtn;
@property (retain, nonatomic) IBOutlet UIButton *cancelBtn;


- (IBAction)sendPressed:(id)sender;
- (IBAction)cancelPressed:(id)sender;
@end
