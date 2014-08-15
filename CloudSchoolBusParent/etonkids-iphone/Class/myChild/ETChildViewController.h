

/**
 *	@file   ETChildViewController
 *  @brief  我的宝宝主界面
 *  @author
 *  @version 2.2
 *  @date   2013-09-03
 */


#import <UIKit/UIKit.h>
#import "MTCustomActionSheet.h"
#import "ETNicknameViewController.h"
#import "ETBaseMessageViewController.h"

@interface ETChildViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,MTCustomActionSheetDelegate,ETNicknameViewControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,ETBaseMessageViewControllerDelegate>
{
    
    UILabel *birthdaylabel;
    MBProgressHUD *HUD;
    UITableView *mainTV;
}

//@property (nonatomic, retain)NSArray *titleArr;
//@property (nonatomic, retain)NSArray *tImageArr;

@end
