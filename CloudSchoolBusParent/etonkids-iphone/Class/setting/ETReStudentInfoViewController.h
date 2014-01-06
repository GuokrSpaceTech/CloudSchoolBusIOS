

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "EKRequest.h"
#import "ETCustomAlertView.h"

@interface ETReStudentInfoViewController : UIViewController<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,ETCustomAlertViewDelegate,EKProtocol>
{
    MBProgressHUD *HUD;
    
    NSString *originName;
    NSString *originDate;
    
}
@property (retain, nonatomic) IBOutlet UIButton *headerBtn;
@property (retain, nonatomic) IBOutlet UITextField *nickName;
@property (retain, nonatomic) IBOutlet UITextField *age;
@property (retain, nonatomic) UIImage * headImage;
@property (retain, nonatomic) IBOutlet UIButton *okBtn;

@property (retain, nonatomic) IBOutlet UIButton *cancelBtn;

- (IBAction)confirm:(id)sender;
- (IBAction)cancel:(id)sender;
- (IBAction)changeHeader:(id)sender;
@property (retain, nonatomic) IBOutlet UILabel *LabelClickHeader;
@property (retain, nonatomic) IBOutlet UILabel *birthday;
@property (retain, nonatomic) IBOutlet UILabel *studentInfoL;

@property (retain, nonatomic) IBOutlet UILabel *NickNameLabel;

@property(retain,nonatomic)IBOutlet  UIDatePicker  *datepick;

@property (nonatomic, retain) NSString *originName;
@property (nonatomic, retain) NSString *originDate;

@end
