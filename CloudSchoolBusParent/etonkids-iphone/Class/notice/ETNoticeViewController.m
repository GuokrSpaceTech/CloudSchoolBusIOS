
#import "ETNoticeViewController.h"
#import "NoticeInfo.h"
#import "UserLogin.h"
#import "AppDelegate.h"
#import "keyedArchiver.h"
#import "ETKids.h"
#import "GTMBase64.h"
#import "NoticeInfo.h"
#import "ETCommonClass.h"
#import "SDWebImageManager.h"
#import "UIImageView+WebCache.h"
#import "ETCoreDataManager.h"
#import "ETShowBigImageViewController.h"
#import "NSDate+convenience.h"

@interface ETNoticeViewController ()

@end

@implementation ETNoticeViewController
@synthesize dataList,allNoticeList,importantList;
@synthesize isLoading;
@synthesize _info;
@synthesize conformInfo;
@synthesize headImage,photoParam,noticParam,getNoticeParam;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

//        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadData) name:@"UPDATEDATA" object:nil];
        
    }
    return self;
}
//-(void) reloadData
//{
//    [self.arrList removeAllObjects];
//    [self requestNoticeData:nil];
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _topView.ageBack.hidden = YES;
    [self setTopView];
    
    self.dataList = [NSMutableArray array];
    self.allNoticeList = [NSMutableArray array];
    self.importantList = [NSMutableArray array];
    
    currentType = AllNotice;
    
    isMoreAllNotice = YES;
    isMoreImportant = YES;
    
    [self loadData];
    
    isFirstLoading = YES; // 判断重要通知是否是第一次点击.
    
    
    tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, _topView.frame.size.height - _tableView.contentOffset.y, 320, HEADERHEIGHT)];
    tableHeaderView.backgroundColor = [UIColor clearColor];
    
    UIImageView *backImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, HEADERHEIGHT)];
    backImgV.image = [UIImage imageNamed:@"noticeTabBack.png"];
    [tableHeaderView addSubview:backImgV];
    [backImgV release];
    
    selImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 1, 160, HEADERHEIGHT)];
    selImgV.image = [UIImage imageNamed:@"noticeTabBtnBack.png"];
    [tableHeaderView addSubview:selImgV];
    [selImgV release];
    
    NSArray *arr = [NSArray arrayWithObjects:LOCAL(@"quanbutongzhi",@"全部通知"),LOCAL(@"zhongyaotongzhi",@"重要通知"), nil];
    for (int i = 0; i < 2; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        //        [btn setBackgroundColor:[UIColor redColor]];
        [btn setTitle:[arr objectAtIndex:i] forState:UIControlStateNormal];
        [btn setTag:333 + i];
        [btn addTarget:self action:@selector(doChoose:) forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setFrame:CGRectMake(160*i, 1, 160, HEADERHEIGHT - 2)];
        [tableHeaderView addSubview:btn];
    }
    
    if (selImgV != nil) {
        
        [UIView animateWithDuration:0.2f animations:^{
            selImgV.center = CGPointMake(80 + currentType*160, HEADERHEIGHT/2 + 1);
        }];
        
    }
    
    [self.view addSubview:tableHeaderView];
    [tableHeaderView release];
    
    
}

//- (void)setTopView
//{
//    _topView.frame = CGRectMake(_topView.frame.origin.x, _topView.frame.origin.y, _topView.frame.size.width, _topView.frame.size.height - HEADERHEIGHT );
//    _tableView.tableHeaderView = _topView;
//    
//}

- (void)loadData
{
    
    self.allNoticeList = [self setNoticeData:[ETCoreDataManager searchAllNotices]];
    self.importantList = [self setNoticeData:[ETCoreDataManager searchImportantNotices]];
    
    [self updateDataList];
    
    [_tableView reloadData];
    
    UserLogin *user = [UserLogin currentLogin];
    
    _topView.nameLabel.text = user.nickname;
    _topView.ageLabel.text = [NSString stringWithFormat:@"%@ %@", user.age,LOCAL(@"ageformat", @"")];
    _topView.classLabel.text = user.className;
    [_topView.photoImageView setImageWithURL:[NSURL URLWithString:user.avatar] placeholderImage:[UIImage imageNamed:@"headplaceholder_big.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        _topView.photoImageView.image = image;
    }];
    
    
    
    if(user.loginStatus == LOGIN_SERVER)
    {
        _topView.nameLabel.text = user.nickname;
        _topView.ageLabel.text = [NSString stringWithFormat:@"%@ %@", user.age,LOCAL(@"ageformat", @"")];
        _topView.classLabel.text = user.className;
        [_topView.photoImageView setImageWithURL:[NSURL URLWithString:user.avatar] placeholderImage:[UIImage imageNamed:@"headplaceholder_big.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
            _topView.photoImageView.image = image;
        }];
        
//        [self requestNoticeData:nil];
        [self autoDragScrollLoading];
        
    }
    else
    {
        // 如果没有登录并没出现登录页面  说明含有自动登录，当出现登录页面时，但是此页面依然存在，所以没有自动登录的值.
        
        
        NSUserDefaults *defaultUser=[NSUserDefaults standardUserDefaults];
        
        if ([defaultUser objectForKey:AUTOLOGIN])
        {
            // 如果是自动登录  首先加载本地缓存（学生信息，数据等等）.
            
            [self autoDragScrollLoading];
            
            //NSLog(@"111");
            
        }
        else
        {
            // 应不做处理 当登录成功是再做处理.
        }
        
    }
}



#pragma----button  sender

/// 修改头像.

-(void)change:(UIGestureRecognizer*)sender
{
//    UserLogin * user = [UserLogin currentLogin];
//    if(user.loginStatus==LOGIN_OFF)
//    {
//        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"localResult", @"") delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil];
//        [alert show];
//        alert.tag=2;
//        [alert release];
//        return;
//    }
    UIActionSheet *action=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:LOCAL(@"cancel", @"取消") destructiveButtonTitle:nil otherButtonTitles:LOCAL(@"takePhoto", @"拍照"),LOCAL(@"choosePhoto",@"从手机相册中选择") ,nil];
    action.tag=2;
    [action showInView:self.view.window];
    [action release];
    
}
-(void) requestNoticeData:(NSDictionary *) param
{
    
    if(param == nil)
    {
        param = [NSDictionary dictionaryWithObjectsAndKeys:@"0",@"starttime",@"0",@"endtime",nil];
    }
    
    ETCommonClass *com = [[[ETCommonClass alloc] init] autorelease];
    [com requestLoginWithComplete:^(NSError *err) {
//        if (err == nil) {
            [[EKRequest Instance] EKHTTPRequest:notice parameters:param requestMethod:GET forDelegate:self];
//        }
//        else
//        {
//            [self stopRequest];
//        }
     
    }];
    
   
}
#pragma EKRequest_Delegate
-(void)LoginFailedresult:(NSString *)str
{
    ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:str delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
    [alert show];
    
}

- (void)stopRequest
{
    [_slimeView endRefresh];
    isLoading = NO;
    
    if(_refreshFooterView)
    {
        [_refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:_tableView];
        [self removeFooterView];
    }
}

-(void) getErrorInfo:(NSError *)error
{
    
    [self stopRequest];
    
    [self LoginFailedresult:LOCAL(@"busy", @"网络故障，请稍后重试")];
}

-(void)getEKResponse:(id)response forMethod:(RequestFunction)method resultCode:(int)code withParam:(NSDictionary *)param
{
    
    [_slimeView endRefresh];
    isLoading = NO;
    
    if(_refreshFooterView)
    {
        [_refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:_tableView];
        [self removeFooterView];
    }
    
    NSLog(@"error code %d",code);

//    UserLogin *user=[UserLogin currentLogin];
    
    if(HUD)
    {
        [HUD removeFromSuperview];
        HUD=nil;
    }
    
    if (code == -1113)
    {
        ETCommonClass *com = [[[ETCommonClass alloc] init] autorelease];
        [com mutiDeviceLogin];
        
    }
    else if (code == -1115)
    {
        ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"fufei", @"") delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
        [alert show];
    }
    else if(method ==avatar)
    {
        if(code == 1)
        {
            ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"success", @"头像上传成功") delegate:self cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil];
            [alert show];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UPDATEPHOTO" object:nil];
            [self.view setNeedsLayout];
        }
    }
    else if(method==notice)
    {
        
        NSString *p = [NSString stringWithFormat:@"%@",[param objectForKey:@"noticekey"]];
        if (![p isEqualToString:@"(null)"]) { // 发送确认
           
           if (code == 1) {
//               id result = [NSJSONSerialization JSONObjectWithData:response options:nil error:nil];
//               
//               if (![result isKindOfClass:[NSArray class]]) {
//                   NSLog(@"通知列表返回格式错误");
//                   return;
//               }
//               
//               NSArray * arr = result;
//               
//               NSLog(@"%@",arr);
               
               for (int i = 0; i < self.allNoticeList.count; i++) {
                    NoticeInfo *n = [self.allNoticeList objectAtIndex:i];
                   if ([n.noticekey isEqualToString:p]) {
                       n.haveisconfirm = @"1";
                       [ETCoreDataManager updateNoticeData:@"1" ById:n.noticeId];
                       break;
                   }
               }
               for (int i = 0; i < self.importantList.count; i++) {
                   NoticeInfo *n = [self.importantList objectAtIndex:i];
                   if ([n.noticekey isEqualToString:p]) {
                       n.haveisconfirm = @"1";
                       [ETCoreDataManager updateImportantNoticeData:@"1" ById:n.noticeId];
                       break;
                   }
               }
               
               ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:nil message:LOCAL(@"confirmSuccess", @"") delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
               [alert show];
               
               
               [self updateDataList];
               [_tableView reloadData];

           }
           
        }
        else  // 获取数据
        {
            
            NSString *paraStr = [NSString stringWithFormat:@"%@",[param objectForKey:@"confirm"]];
           
            if(code == 1)
            {
               //缓存数据
                NSArray * arr=[NSJSONSerialization JSONObjectWithData:response options:nil error:nil];
               
                NSLog(@"%@",arr);
               
//               if(arr==nil)
//               {
//                   if(conformInfo)
//                   {
//                       int a= [arrList indexOfObject:conformInfo];
//                       
//                       NoticeInfo *info= [arrList objectAtIndex:a];
//                       info.haveisconfirm=@"1";
//                       [_tableView reloadData];
//                       
//                       self.conformInfo = nil;
//                   }
//                   
//                   
//                   return;
//               }
               
               
                if (theRefreshPos == EGORefreshHeader)
                {
                    if ([paraStr isEqualToString:@"1"])//重要通知
                    {
                       //清空 并加入新数据.
                        [self.importantList removeAllObjects];
                        [self parserData:arr inList:self.importantList];
                        
                        [ETCoreDataManager removeAllImportantNotices];
                        [ETCoreDataManager addImportantNoticeData:arr];
                        isMoreImportant = YES;
                    }
                    else                                 //全部通知
                    {
                        NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:@"1",@"TYPE", nil];
                        [[NSNotificationCenter defaultCenter]postNotificationName:@"BUDGEHIDDEN" object:nil userInfo:dic];
                        //清空 并加入新数据.
                        [self.allNoticeList removeAllObjects];
                        [self parserData:arr inList:self.allNoticeList];
                           
                        [ETCoreDataManager removeAllNotices];
                        [ETCoreDataManager addNoticeData:arr];
                        isMoreAllNotice = YES;
                    }
                }
                else if (theRefreshPos == EGORefreshFooter)
                {
                   if ([paraStr isEqualToString:@"1"])//重要通知
                   {
                       [self parserData:arr inList:self.importantList];
                       isMoreImportant = YES;
                   }
                   else                                //全部通知
                   {
                       [self parserData:arr inList:self.allNoticeList];
                       isMoreAllNotice = YES;
                   }
               }
                
                
                
               
               [self updateDataList];
               [_tableView reloadData];
           }
           else if(code == -2)
           {
               if (theRefreshPos == EGORefreshFooter)
               {
                   
                   if ([paraStr isEqualToString:@"1"])//重要通知
                   {
                       isMoreImportant = NO;
                   }
                   else                                //全部通知
                   {
                       isMoreAllNotice = NO;
                   }
               }
               else
               {
                   
                   if ([paraStr isEqualToString:@"1"])  //重要通知
                   {
                       [ETCoreDataManager removeAllImportantNotices];
                       [self.importantList removeAllObjects];
                   }
                   else                                 //全部通知
                   {
                       [ETCoreDataManager removeAllNotices];
                       [self.allNoticeList removeAllObjects];
                   }
                   
               }

               [self updateDataList];
               [_tableView reloadData];
               
           }
           else
           {
               ETCustomAlertView *alert = [[ETCustomAlertView alloc] initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"fail", @"") delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil] ;
               [alert show];
           }
       }
       
       
       
   }
   
   
}
#pragma mark ---alertview
- (void)alertView:(ETCustomAlertView *)alertView didSelectButtonAtIndex:(NSInteger)index
{
    
        if (index==0)
        {
            [_topView.photoImageView setImage:self.headImage];
            NSNotificationCenter *center=[NSNotificationCenter defaultCenter];
            [center postNotificationName:@"PHOTO" object:nil];
            
        }
        else  if(index==1)
        {
            NSLog(@"22222222");
        }
}
- (NSMutableArray *)setNoticeData:(NSArray *)arr
{
    
    NSMutableArray *resultArr = [NSMutableArray array];
    
    for (int i=0; i<[arr count]; i++)
    {
        NSDictionary * dic=[arr objectAtIndex:i];
        NoticeInfo *notice=[[NoticeInfo alloc]init];
        
        NSDateFormatter * format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSDate * addDate = [NSDate dateWithTimeIntervalSince1970:[[dic objectForKey:@"addtime"] doubleValue]];
        NSString * addDateStr = [format stringFromDate:addDate];
        [format release];
        
        notice.noticeTime = addDateStr;
        notice.noticeTitle = [NSString stringWithFormat:@"%@",[dic objectForKey:@"noticetitle"]];
        notice.noticeContent = [NSString stringWithFormat:@"%@",[dic objectForKey:@"noticecontent"]];
        notice.noticeId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"noticeid"]];
        notice.shortContent = [NSString stringWithFormat:@"%@",[dic objectForKey:@"noticecontent"]];
        notice.isconfirm = [NSString stringWithFormat:@"%@",[dic objectForKey:@"isconfirm"]];
        notice.noticekey = [NSString stringWithFormat:@"%@",[dic objectForKey:@"noticekey"]];
        notice.haveisconfirm = [NSString stringWithFormat:@"%@",[dic objectForKey:@"haveisconfirm"]];
        notice.addtime = [NSString stringWithFormat:@"%@",[dic objectForKey:@"addtime"]];
        notice.isMore=NO;
        NSArray * plists = [dic objectForKey:@"plist"];
        if(plists.count >0)
        {
            notice.pictures = plists;
        }
        
        [resultArr addObject:notice];
            
        [notice release];
    }
    
    return resultArr;
    
//    [self performSelectorOnMainThread:@selector(upDateUI) withObject:nil waitUntilDone:YES];
}

- (void)parserData:(NSArray *)arr inList:(NSMutableArray *)array
{
    [array addObjectsFromArray:[self setNoticeData:arr]];
}

#pragma --

- (void)updateDataList
{
    if (currentType == AllNotice)
    {
        self.dataList = self.allNoticeList;
        
        if (self.dataList.count < 15) {
            isMoreAllNotice = NO;
        }
        
        isMore = isMoreAllNotice;
    }
    else if (currentType == ImportantNotice)
    {
        self.dataList = self.importantList;
        
        if (self.dataList.count < 15) {
            isMoreImportant = NO;
        }
        
        isMore = isMoreImportant;
    }
    
    
    if(_refreshFooterView)
    {
        [_refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:_tableView];
        [self removeFooterView];
    }
}

#pragma mark --------- notice cell delegate -----------

- (void) didTapImageWithImageArray:(NSArray *)imgArr showNumber:(int)num content:(NoticeInfo *)notice
{
    if (imgArr != nil && notice != nil) {
        ETShowBigImageViewController *showBigVC = [[ETShowBigImageViewController alloc] init];
        showBigVC.picArr = imgArr;
        showBigVC.showNum = num;
//        showBigVC.title = notice.noticeTitle;
//        showBigVC.content=content.shareContent;
        //[self presentModalViewController:showBigVC animated:YES];
        AppDelegate *aDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
        [aDelegate.bottomNav presentModalViewController:showBigVC animated:YES];
        [showBigVC release];
    }
}

-(void)noticeCell:(NoticeCell *)_notice notice:(NoticeInfo *)info
{
    
//    NSIndexPath *indexPath = [self._tableView indexPathForCell:_notice];
//    NoticeInfo *noticeInfo = [self.arrList objectAtIndex:indexPath.row];
//    noticeInfo.isMore = !noticeInfo.isMore;
    
    info.isMore=!info.isMore;
    
//    [self removeFooterView];
    [_tableView reloadData];
}
- (void)clickComfirmNoticeCell:(NoticeCell *)_notice
{
    if (_notice.notice.noticekey != nil) {
        
        NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:_notice.notice.noticekey,@"noticekey",nil];
        
        ETCommonClass *com = [[[ETCommonClass alloc] init] autorelease];
        [com requestLoginWithComplete:^(NSError *err){
            [[EKRequest Instance] EKHTTPRequest:notice parameters:param requestMethod:POST forDelegate:self];
        }];
    }
    
    
}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag==2) {
        if(buttonIndex==0)
        {
            UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
            if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
            {
                //sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"nosupport", @"设备不支持该功能")  delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
                [alert show];
                
                
                return;
            }
            //TabBarHidden//0
            NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:@"0",@"Hide", nil];
            [[NSNotificationCenter  defaultCenter]postNotificationName:@"TabBarHidden" object:nil userInfo:dic];
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate=self;
            picker.allowsEditing = YES;
            picker.sourceType = sourceType;
            [self presentModalViewController:picker animated:YES];
            [picker release];
            
            
        }
        if(buttonIndex==1)
        {
            NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:@"0",@"Hide", nil];
            [[NSNotificationCenter  defaultCenter]postNotificationName:@"TabBarHidden" object:nil userInfo:dic];
            UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = YES;
            picker.sourceType = sourceType;
            [self presentModalViewController:picker animated:YES];
            [picker release];
        }
        if(buttonIndex==2)
        {
            NSLog(@"fdfdf");
        }
        
    }
    else
    {

 
    }

}


#pragma UIImagePickerController_Delegate
- (void)saveImage:(UIImage *)image
{
    
    if(HUD==nil)
    {
        AppDelegate *delegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        HUD=[[MBProgressHUD alloc]initWithView:delegate.window];
        HUD.labelText=LOCAL(@"upload", @"正在上传头像");   //@"正在上传头像";
        [delegate.window addSubview:HUD];
        [HUD show:YES];
        [HUD release];
    }
    
    NSData *mydata=UIImageJPEGRepresentation(image, 0.5);
    
    self.headImage = image;
    
    NSString *base64 = [[NSString alloc] initWithData:[GTMBase64 encodeData:mydata] encoding:NSUTF8StringEncoding];
    self.photoParam = [NSDictionary dictionaryWithObjectsAndKeys:base64,@"fbody",nil];
    [base64 release];
    
    
    ETCommonClass *com = [[[ETCommonClass alloc] init] autorelease];
    [com requestLoginWithComplete:^(NSError *err) {
        
        [[EKRequest Instance] EKHTTPRequest:avatar parameters:self.photoParam requestMethod:POST forDelegate:self];
    }];
    
    
    
    
}

-(UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    
    UIImage *newImage=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
    
}
#pragma mark Camera View Delegate Methods
- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:@"1",@"Hide", nil];
    [[NSNotificationCenter  defaultCenter]postNotificationName:@"TabBarHidden" object:nil userInfo:dic];
    [picker dismissModalViewControllerAnimated:YES];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    [self performSelector:@selector(saveImage:)
               withObject:image
               afterDelay:0.5];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissModalViewControllerAnimated:YES];
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:@"1",@"Hide", nil];
    [[NSNotificationCenter  defaultCenter]postNotificationName:@"TabBarHidden" object:nil userInfo:dic];
    
}



-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UPDATEDATA" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UPDATEPHOTO" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"BUDGEHIDDEN" object:nil];
    self.dataList=nil;
    self.conformInfo = nil;
    self._info = nil;
    self.headImage = nil;
    self.photoParam = nil;
    self.noticParam = nil;
    self.getNoticeParam = nil;
    self.allNoticeList = nil;
    self.importantList = nil;
    self.dataList = nil;
    [super dealloc];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.dataList.count == 0) {
        return 1;
    }
    return [self.dataList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    if (self.dataList.count == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentView.backgroundColor = CELLCOLOR;
//        cell.textLabel.text = LOCAL(@"defaultdata", @"");
//        cell.textLabel.font=[UIFont systemFontOfSize:28];
//        cell.textLabel.textColor=[UIColor grayColor];
//        cell.textLabel.textAlignment=UITextAlignmentCenter;
        
        UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 151, 131)];
        imgV.image = [UIImage imageNamed:@"nodata.png"];
        imgV.center = CGPointMake(160, ((iphone5 ? 548 : 460) - 46 - 57 - 135)/2);
        [cell addSubview:imgV];
        [imgV release];
        
        return cell;
    }
    
    static NSString *CellIdentifier1 = @"Cell1";
    
    NoticeCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
    if(cell==nil)
    {
        cell=[[[NoticeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier1] autorelease];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
    }
    cell.delegate=self;
    
    float calculateHeight = 0;
    
    NoticeInfo *info = [self.dataList objectAtIndex:indexPath.row];
    
    cell.notice = info;
    
    CGSize tSize;
    if ([info.isconfirm isEqualToString:@"1"] && [info.haveisconfirm isEqualToString:@"0"]) //需要确认回执
    {
        NSString *title = [NSString stringWithFormat:@"%@ %@",LOCAL(@"com", @""),info.noticeTitle];
        tSize = [title sizeWithFont:cell.noticeTitleLabel.font constrainedToSize:CGSizeMake(260, 1000) lineBreakMode:NSLineBreakByWordWrapping];
        cell.noticeTitleLabel.textColor=[UIColor redColor];
        cell.noticeTitleLabel.text = title;
        cell.noticeTitleLabel.frame = CGRectMake(cell.noticeTitleLabel.frame.origin.x,
                                                 cell.noticeTitleLabel.frame.origin.y,
                                                 tSize.width,
                                                 tSize.height);
    }
    else
    {
        tSize = [info.noticeTitle sizeWithFont:cell.noticeTitleLabel.font constrainedToSize:CGSizeMake(260, 1000) lineBreakMode:NSLineBreakByWordWrapping];
        cell.noticeTitleLabel.textColor = [UIColor blackColor];
        cell.noticeTitleLabel.text = info.noticeTitle;
        cell.noticeTitleLabel.frame = CGRectMake(cell.noticeTitleLabel.frame.origin.x,
                                                 cell.noticeTitleLabel.frame.origin.y,
                                                 tSize.width,
                                                 tSize.height);
    }
    
    calculateHeight += tSize.height + cell.noticeTitleLabel.frame.origin.y;
    
    
    CGSize ctntSize = [info.noticeContent sizeWithFont:cell.noticeContentLabel.font constrainedToSize:CGSizeMake(250, 1000) lineBreakMode:NSLineBreakByWordWrapping];
    
    if (ctntSize.height > cell.noticeContentLabel.font.lineHeight * 3 && !info.isMore)  //如果超过三行 只显示三行
    {
        cell.noticeContentLabel.text = info.noticeContent;
        cell.noticeContentLabel.frame = CGRectMake(50,
                                                   calculateHeight + 25,
                                                   ctntSize.width,
                                                   cell.noticeContentLabel.font.lineHeight * 3);
        
        calculateHeight = calculateHeight + 25 + cell.noticeContentLabel.font.lineHeight * 3;
    }
    else
    {
        
        
        cell.noticeContentLabel.text = info.noticeContent;
        cell.noticeContentLabel.frame = CGRectMake(50,
                                                   calculateHeight + 25,
                                                   ctntSize.width,
                                                   ctntSize.height);
        calculateHeight = calculateHeight + 25 + ctntSize.height;
    }

    
    for (int i = 0; i < cell.photoImgVArr.count; i++) {
        
        UIImageView *imgV = [cell.photoImgVArr objectAtIndex:i];
        int picCount = info.pictures.count;
        if (i < picCount)
        {
            NSDictionary *dic = [info.pictures objectAtIndex:i];
            if ([dic objectForKey:@"source"]) {
                NSString *picURL=[NSString stringWithFormat:@"%@",[dic objectForKey:@"source"]];
                picURL = [picURL stringByAppendingString:@".tiny.jpg"];
                
                [imgV setImageWithURL:[NSURL URLWithString:picURL] placeholderImage:[UIImage imageNamed:@"imageplaceholder.png"] options:SDWebImageRetryFailed|SDWebImageRefreshCached completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                    
                    //                        NSLog(@"%d",cacheType);
                    
                    if (error) {
                        
                        NSLog(@"Error : load image fail.");
                        imgV.image = [UIImage imageNamed:@"imageerror.png"];
                        
                    }
                    else
                    {
                        imgV.image = image;
                        
                        if (cacheType == 0) { // request url
                            CATransition *transition = [CATransition animation];
                            transition.duration = 1.0f;
                            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                            transition.type = kCATransitionFade;
                            
                            [imgV.layer addAnimation:transition forKey:nil];
                        }
                    }
                    
                    
                    
                }];
            }
            else
            {
                NSLog(@"Error : picture url error .");
            }
            
            
            
            imgV.frame = CGRectMake(58 + i%3*(75 + 5), calculateHeight + 10/*the distance is between content and image*/ + i/3*(75 + 5), 75, 75);
            
            
        }
        else
        {
            imgV.image = nil;
            imgV.frame = CGRectZero;
        }
        
    }
    
    calculateHeight = calculateHeight + 10 + (info.pictures.count == 0 ? 0 : ((info.pictures.count-1)/3 + 1) * (75 + 10));
    
//    NSLog(@"size : %f , %f",ctntSize.height,cell.noticeContentLabel.font.lineHeight * 3);
    
    
    
    if ((ctntSize.height < cell.noticeContentLabel.font.lineHeight * 3) || (ABS(cell.noticeContentLabel.font.lineHeight * 3 - ctntSize.height) < 1.0f))
    {
        cell.buttonMore.hidden = YES;
        cell.lineImgV.hidden = YES;
        calculateHeight += 5;
    }
    else
    {
        cell.buttonMore.hidden = NO;
        cell.lineImgV.hidden = NO;
        
        cell.lineImgV.frame = CGRectMake(cell.lineImgV.frame.origin.x,
                                         calculateHeight + 5,
                                         cell.lineImgV.frame.size.width,
                                         cell.lineImgV.frame.size.height);
        
        calculateHeight += 6;
        
        cell.buttonMore.frame = CGRectMake(cell.buttonMore.frame.origin.x,
                                           calculateHeight,
                                           cell.buttonMore.frame.size.width,
                                           cell.buttonMore.frame.size.height);
        
        calculateHeight += cell.buttonMore.frame.size.height;
        
        
//        NSLog(@"info ismore %d , ", cell.buttonMore.hidden);
        
        if (!info.isMore)
        {
            [cell.buttonMore setTitle:LOCAL(@"more", @"更多") forState:UIControlStateNormal];
        }
        else
        {
            [cell.buttonMore setTitle:LOCAL(@"up", @"收起") forState:UIControlStateNormal];
        }
    
    }
    
    cell.triangle.frame = CGRectMake(cell.backImgV.frame.origin.x + 15,
                                     cell.noticeTitleLabel.frame.origin.y + tSize.height,
                                     14,
                                     12);
    
    
    cell.backImgV.frame = CGRectMake(cell.backImgV.frame.origin.x, cell.noticeTitleLabel.frame.origin.y + tSize.height + 12, cell.backImgV.frame.size.width, calculateHeight - cell.noticeTitleLabel.frame.origin.y - tSize.height - 12);
    
    calculateHeight += 10;
    
    cell.noticeTimeLabel.frame = CGRectMake(50, calculateHeight, cell.noticeTimeLabel.frame.size.width, cell.noticeTimeLabel.frame.size.height);
    
    //----- calculate time -----------
    NSString *time = info.addtime;
    
    int cDate = [[NSDate date] timeIntervalSince1970];
    NSDate *pDate = [NSDate dateWithTimeIntervalSince1970:time.intValue];
    int sub = cDate - time.intValue;
    
    NSString *dateStr;
    
    if (sub < 60*60)//小于一小时
    {
        dateStr = [NSString stringWithFormat:@"%d %@",sub/60 == 0 ? 1 : sub/60,LOCAL(@"minutesago", @"")];
    }
    else if (sub < 12*60*60 && sub >= 60*60)
    {
        dateStr = [NSString stringWithFormat:@"%d %@",sub/(60*60),LOCAL(@"hoursago", @"")];
    }
    else if (pDate.year == [NSDate date].year)
    {
        NSDateFormatter *format = [[[NSDateFormatter alloc] init] autorelease];
        format.dateFormat = @"MM-dd HH:mm";
        dateStr = [NSString stringWithFormat:@"%@",[format stringFromDate:pDate]];
    }
    else if (pDate.year < [NSDate date].year)
    {
        NSDateFormatter *format = [[[NSDateFormatter alloc] init] autorelease];
        format.dateFormat = @"yyyy-MM-dd HH:mm";
        dateStr = [NSString stringWithFormat:@"%@",[format stringFromDate:pDate]];
    }
    else
    {
        dateStr = [NSString stringWithFormat:@"error time"];
    }
    
    
    if (time !=nil) {
        cell.noticeTimeLabel.text = dateStr;
    }
    
    // -----------------------
    
    
    int centerHeight = calculateHeight + cell.noticeTimeLabel.frame.size.height/2;
    
    if (([info.isconfirm isEqualToString:@"1"] && [info.haveisconfirm isEqualToString:@"0"] && info.isMore) ||
        ([info.isconfirm isEqualToString:@"1"] && [info.haveisconfirm isEqualToString:@"0"] && ctntSize.height <= cell.noticeContentLabel.font.lineHeight * 3)) //需要确认回执
    {
        cell.buttonreceipt.hidden = NO;
        cell.buttonreceipt.center = CGPointMake(320-60, centerHeight);
    }
    else
    {
        cell.buttonreceipt.hidden = YES;
    }
    
    cell.line.frame = CGRectMake(0, calculateHeight + 27, 320, 2);
    
    
    if(indexPath.row==[self.dataList count]-1)
    {
        if(isMore)
            [self setFooterView];
        else
        {
            [self removeFooterView];
        }
    }
    
    

    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.dataList.count == 0) return (iphone5 ? 568 : 460) - 46 - 57 - 135;
    NoticeInfo *info=[self.dataList objectAtIndex:indexPath.row];
    
    
    int calculateHeight = 0; // add up height.
    
    CGSize tSize;
    if ([info.isconfirm isEqualToString:@"1"] && [info.haveisconfirm isEqualToString:@"0"]) //需要确认回执
    {
        NSString *title = [NSString stringWithFormat:@"%@ %@",LOCAL(@"com", @""),info.noticeTitle];
        tSize = [title sizeWithFont:[UIFont systemFontOfSize:TITLEFONTSIZE] constrainedToSize:CGSizeMake(260, 1000) lineBreakMode:NSLineBreakByWordWrapping];
        
    }
    else
    {
        tSize = [info.noticeTitle sizeWithFont:[UIFont systemFontOfSize:TITLEFONTSIZE] constrainedToSize:CGSizeMake(260, 1000) lineBreakMode:NSLineBreakByWordWrapping];
    }
    
    calculateHeight += tSize.height + 10;
    
    
    UIFont *ctntFont = [UIFont systemFontOfSize:CONTENTFONTSIZE];
    CGSize ctntSize = [info.noticeContent sizeWithFont:ctntFont constrainedToSize:CGSizeMake(250, 1000) lineBreakMode:NSLineBreakByWordWrapping];
    
    if (ctntSize.height > ctntFont.lineHeight * 3 && !info.isMore)  //如果超过三行 只显示三行
    {
        calculateHeight = calculateHeight + 25 + ctntFont.lineHeight * 3;
    }
    else
    {
        calculateHeight = calculateHeight + 25 + ctntSize.height;
    }
    
    calculateHeight = calculateHeight + 10 + (info.pictures.count == 0 ? 0 : ((info.pictures.count-1)/3 + 1) * (75 + 10));
    
     
    
    if (ctntSize.height > ctntFont.lineHeight * 3)
    {
        calculateHeight += 6; // line height
        calculateHeight += 30;//button height
    }
    else
    {
        calculateHeight += 5;// 内容中横线与内容的距离 如果没有横线 为到气泡底部距离
    }
    calculateHeight += 10 + 29;
    
    
    return calculateHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return HEADERHEIGHT;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, HEADERHEIGHT)];
    header.backgroundColor = [UIColor clearColor];
    /*
    UIImageView *backImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, -10, 320, HEADERHEIGHT)];
    backImgV.image = [UIImage imageNamed:@"noticeTabBack.png"];
    [header addSubview:backImgV];
    [backImgV release];
    
    selImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 1, 160, HEADERHEIGHT)];
    selImgV.image = [UIImage imageNamed:@"noticeTabBtnBack.png"];
    [header addSubview:selImgV];
    [selImgV release];
    
    NSArray *arr = [NSArray arrayWithObjects:LOCAL(@"quanbutongzhi",@"全部通知"),LOCAL(@"zhongyaotongzhi",@"重要通知"), nil];
    for (int i = 0; i < 2; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        //        [btn setBackgroundColor:[UIColor redColor]];
        [btn setTitle:[arr objectAtIndex:i] forState:UIControlStateNormal];
        [btn setTag:333 + i];
        [btn addTarget:self action:@selector(doChoose:) forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setFrame:CGRectMake(160*i, 1, 160, HEADERHEIGHT - 2)];
        [header addSubview:btn];
    }
    
    if (selImgV != nil) {
        
        [UIView animateWithDuration:0.2f animations:^{
            selImgV.center = CGPointMake(80 + currentType*160, HEADERHEIGHT/2 + 1);
        }];
        
    }
    */
    
    return header;
    
}

- (void)doChoose:(UIButton *)sender
{
    if (selImgV != nil) {
        
        [UIView animateWithDuration:0.2f animations:^{
            selImgV.center = CGPointMake(80 + sender.tag%333*160, HEADERHEIGHT/2 + 1);
        }];
        
    }
    currentType = sender.tag % 333;
    
    
    [self updateDataList];
    [_tableView reloadData];
    
    //    [self requestNewData];
    
    
    if (isFirstLoading)
    {
        isFirstLoading = NO;
        [self autoDragScrollLoading];
    }
    
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [super scrollViewDidScroll:scrollView];
    tableHeaderView.frame = CGRectMake(tableHeaderView.frame.origin.x,
                                       MAX(0,_topView.frame.size.height - _tableView.contentOffset.y),
                                       tableHeaderView.frame.size.width,
                                       tableHeaderView.frame.size.height);
}

- (void)slimeRefreshStartRefresh:(SRRefreshView *)refreshView
{
    
    theRefreshPos = EGORefreshHeader;
    
    NSDictionary * param;
    
    if (currentType == ImportantNotice) {
        param = [NSDictionary dictionaryWithObjectsAndKeys:@"0",@"starttime",@"0",@"endtime",@"1",@"confirm",nil];
    }else{
        param = [NSDictionary dictionaryWithObjectsAndKeys:@"0",@"starttime",@"0",@"endtime",nil];
    }
    [self requestNoticeData:param];
    
}

- (void)reloadTableViewDataSource:(EGORefreshPos)aRefreshPos
{
    //获取信息
    if(aRefreshPos == EGORefreshHeader)
    {
        
    }
    else
    {
        if(aRefreshPos == EGORefreshFooter)
        {
            
            NoticeInfo *sc = [self.dataList lastObject];
            NSString *lastTime = sc.addtime;
            NSDictionary * param;
            
            if (currentType == ImportantNotice) {
                param = [NSDictionary dictionaryWithObjectsAndKeys:lastTime,@"starttime",@"0",@"endtime",@"1",@"confirm",nil];
            }else{
                param = [NSDictionary dictionaryWithObjectsAndKeys:lastTime,@"starttime",@"0",@"endtime",nil];
            }
      
            
            theRefreshPos = EGORefreshFooter;
            //连接服务器
            isLoading = YES;
            [self requestNoticeData:param];
        }
    }
}

- (void)egoRefreshTableDidTriggerRefresh:(EGORefreshPos)aRefreshPos
{
	[self reloadTableViewDataSource:aRefreshPos];
}


- (BOOL)egoRefreshTableDataSourceIsLoading:(UIView*)view
{
	return isLoading; // should return if data source model is reloading
    
}

//返回刷新时间的回调方法
- (NSDate*)egoRefreshTableDataSourceLastUpdated:(UIView*)view
{
	return [NSDate date]; // should return date data source was last changed
}

-(void)showHUD:(BOOL) animation
{
    if(animation)
    {
        if(HUD==nil)
        {
            AppDelegate *delegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
            HUD=[[MBProgressHUD alloc]initWithView:delegate.window];
            [delegate.window addSubview:HUD];
            [HUD show:YES];
            [HUD release];
        }
        
    }
    else
    {
        if(HUD)
        {
            [HUD removeFromSuperview];
            HUD=nil;
        }
    }
}

-(void)showAlert:(NSString *)str
{
    if(HUD)
    {
        [HUD removeFromSuperview];
        HUD=nil;
    }
    
    ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:str delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
    [alert show];
    
}




- (BOOL)shouldAutorotate
{
    return NO;
}

//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
//{
//    return NO;
//}
//
//- (NSUInteger)supportedInterfaceOrientations
//{
//    return UIInterfaceOrientationLandscapeLeft | UIInterfaceOrientationLandscapeRight | UIInterfaceOrientationPortrait;
//}


@end
