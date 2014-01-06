
/**
 *	@file   ETFoodView
 *  @brief  食谱页面
 *  @author
 *  @version 2.2
 *  @date   2013-09-03
 */

#import <UIKit/UIKit.h>
#import "ETKids.h"
#import "MBProgressHUD.h"
#import "EKRequest.h"
#import "keyedArchiver.h"
#import "MTCustomActionSheet.h"
#import "ETBoardSideView.h"

@interface ETFoodView : ETBoardSideView<EKProtocol,UITableViewDataSource,UITableViewDelegate,MTCustomActionSheetDelegate>
{
    CGPoint prePoint;
    int beginX;
    CGFloat CellHeight;
    
    float distence;
    MBProgressHUD *HUD;
    NSMutableArray * bigers;
    
    NSDateFormatter *dateFormat;
    
    CGFloat HightLabel;
    CGFloat HightTableview;
    
    UIButton *todayBtn;
}
@property(nonatomic,retain)NSArray *dataArray;


//@property(nonatomic,retain)IBOutlet UIDatePicker  * datapick;
@property(nonatomic,retain)IBOutlet UIButton      *datebutton;
@property(nonatomic,retain)IBOutlet UITableView  *tableview;


@end
