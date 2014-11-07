

#import "ETClassViewController.h"
#import "ShareContent.h"
#import "AppDelegate.h"
#import "UserLogin.h"
#import "keyedArchiver.h"
#import "UIImageView+WebCache.h"
#import "ETKids.h"
#import "GTMBase64.h"
#import "Modify.h"

#import "WriteCommentsViewController.h"
#import "ETCommonClass.h"
#import "ETCoreDataManager.h"
#import "NSDate+convenience.h"
#import <MediaPlayer/MediaPlayer.h>
//#import "GKMovieCell.h"
#import "GKMovieManager.h"

@interface ETClassViewController ()

@end

@implementation ETClassViewController

@synthesize list;
@synthesize isLoading;
@synthesize shareContent,headImage;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movieDownloadCompleteNotification:) name:@"MOVIEDOWNLOADCOMPLETE" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTable:) name:@"NOTIFICELL" object:nil];
    }
    return self;
}
- (void)reloadTable:(NSNotification *)noti
{
    [_tableView reloadData];
}

- (void)movieDownloadCompleteNotification:(NSNotification *)noti
{
    [self controlVisibleCellPlay];
}

-(void) didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
-(void)dealloc
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"MOVIEDOWNLOADCOMPLETE" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"NOTIFICELL" object:nil];
    self.list=nil;
    self.shareContent=nil;
    self.headImage = nil;
    
    [super dealloc];
    
}

-(void)upDateUI
{
    isLoading = NO;
    if (theRefreshPos == EGORefreshHeader)
    {
        if (_slimeView) {
            [_slimeView endRefresh];
        }
    }
    else if (theRefreshPos == EGORefreshFooter)
    {
        if(_refreshFooterView)
        {
            [_refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:_tableView];
//            NSLog(@"%@",self._refreshFooterView);
            [self removeFooterView];
        }
    }
    [_tableView reloadData];
    
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSMutableArray * mutArr = [NSMutableArray array];
    self.list = mutArr;
    
    [self loadData];
   
}


- (void)loadData
{
    UserLogin *user = [UserLogin currentLogin];
    
    _topView.nameLabel.text = user.nickname;
    _topView.ageLabel.text = [NSString stringWithFormat:@"%@ %@", user.age,LOCAL(@"ageformat", @"")];
    _topView.classLabel.text = user.className;
    [_topView.photoImageView setImageWithURL:[NSURL URLWithString:user.avatar] placeholderImage:[UIImage imageNamed:@"headplaceholder_big.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        _topView.photoImageView.image = image;
    }];
    
    NSArray *arr = [ETCoreDataManager searchAllArticals];
    
//    if (arr.count < 15)
//    {
//        isMore = NO;
//    }else
//    {
        isMore = YES;
//    }
    
    
    [self setArticalData:arr];
    
    
    if(user.loginStatus == LOGIN_SERVER)
    {
//        [self showHUD:YES];
//        isLoading=YES;
        
        _topView.nameLabel.text = user.nickname;
        _topView.ageLabel.text = [NSString stringWithFormat:@"%@ %@", user.age,LOCAL(@"ageformat", @"")];
        _topView.classLabel.text = user.className;
        [_topView.photoImageView setImageWithURL:[NSURL URLWithString:user.avatar] placeholderImage:[UIImage imageNamed:@"headplaceholder_big.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
            _topView.photoImageView.image = image;
        }];
        
        NSDictionary * param = [NSDictionary dictionaryWithObjectsAndKeys:@"0",@"starttime",@"0",@"endtime",nil];
        
        [self requestArticalData:param];
        
    }
    else
    {
        // 如果没有登录并没出现登录页面  说明含有自动登录，当出现登录页面时，但是此页面依然存在，所以没有自动登录的值.
        
        NSUserDefaults *defaultUser=[NSUserDefaults standardUserDefaults];
        
        if ([defaultUser objectForKey:AUTOLOGIN])
        {
            // 如果是自动登录  首先加载本地缓存（学生信息，数据等等）.
            
            
            
            
        }
        else
        {
            // 应不做处理 当登录成功是再做处理.
        }
        
    }
}


///新浪微博 授权成功.
- (void)finishedWithAuth:(WeiboAuthentication *)auth error:(NSError *)error {

    if (error) {
        NSLog(@"failed to auth: %@", error);
    }
    else {
        NSLog(@"Success to auth: %@", auth.userId);
        [self shareController:1];
        [[WeiboAccounts shared]addAccountWithAuthentication:auth];
    }

}
///腾讯授权成功.
- (void)onSuccessLogin
{
    [self shareController:2];

}


///登录失败回调.
- (void)onFailureLogin:(NSError *)error
{

}


-(void)shareWeibo:(ShareContent *)info withTag:(int)tag
{
    self.shareContent=info;
    currentTag = tag;
    [self showActionSheet];
}

-(void)shareController:(NSInteger)shareType
{
    
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
            
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate=self;
            picker.allowsEditing = YES;
            picker.sourceType = sourceType;
            [self presentModalViewController:picker animated:YES];
            [picker release];
            
            
        }
        if(buttonIndex==1)
        {
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
    if(buttonIndex==0)
    {
        //新浪
        WeiboAccount *account=[[WeiboAccounts shared] currentAccount];
        if(!account || account.accessToken==nil)
        {
//            [self hidTabBar:@"0"];
            [_weiboSignIn signInOnViewController:self];
        }
        else
        {
            [self shareController:1];

        }
    }
    if(buttonIndex==1)
    {
        //腾讯
        if([[weiboEngine openId] length]>0)
        {
            if(![weiboEngine isAuthorizeExpired])
            {
//                [self hidTabBar:@"0"];
                [weiboEngine logInWithDelegate:self
                                     onSuccess:@selector(onSuccessLogin)
                                     onFailure:@selector(onFailureLogin:)];
            }
            else
            {
                [self shareController:2];
            }
         
        }
        else
        {
//            [self hidTabBar:@"0"];
            [weiboEngine logInWithDelegate:self
                                 onSuccess:@selector(onSuccessLogin)
                                 onFailure:@selector(onFailureLogin:)];

        }
    }
    if(buttonIndex==2)
    {
        //微信
        
        [self shareController:3];
        
    }
 }
    
}

- (void)loginRequest
{
    AppDelegate *delegate = SHARED_APP_DELEGATE;
    UserLogin *user = [UserLogin currentLogin];
    
    [[EKRequest Instance]clearSid];
    
    NSDictionary * param = [NSDictionary dictionaryWithObjectsAndKeys:user.regName,@"username",[MTAuthCode authEncode:user.passWord authKey:@"mactop" expiryPeriod:0],@"password", delegate.token,@"token", nil];
    reqType = loginType;
    [[EKRequest Instance] EKHTTPRequest:signin parameters:param requestMethod:POST forDelegate:self];
    
}



-(void) reloadData
{
    [self.list removeAllObjects];
    [self requestArticalData:nil];
}
-(void)LoginFailedresult:(NSString *)str
{
    [_slimeView endRefresh];
    
    ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:str delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
    [alert show];
    
}




- (void)viewWillDisappear:(BOOL)animated
{
    isVisible = NO;
    
    GKMovieManager *mm = [GKMovieManager shareManager];
//    NSLog(@"@@@@@@@@@@@@@@@@@   %@,%d",mm.playingCell,mm.playingCell.mPlayer.playbackState);
    if (mm.playingCell && mm.playingCell.mPlayer.playbackState == MPMoviePlaybackStatePlaying) {
        [mm.playingCell.mPlayer stop];
    }
}

- (void)doUpdate:(NSNotification *)noti
{
    
}


#pragma EKRequest_Delegate
-(void) requestArticalData:(NSDictionary *) param
{
    
    ETCommonClass *com = [[[ETCommonClass alloc] init] autorelease];
    [com requestLoginWithComplete:^(NSError *err){
        [[EKRequest Instance] EKHTTPRequest:article parameters:param requestMethod:GET forDelegate:self];
    }];
    
}
-(void) getErrorInfo:(NSError *)error forMethod:(RequestFunction)method
{
    [self upDateUI];
    [self performSelectorOnMainThread:@selector(LoginFailedresult:) withObject:LOCAL(@"busy", @"网络故障，请稍后重试") waitUntilDone:NO];
}
-(void)getEKResponse:(id)response forMethod:(RequestFunction)method resultCode:(int)code withParam:(NSDictionary *)param
{
    UserLogin *user = [UserLogin currentLogin];

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
            //修改userlogin avatar
            
            ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"success", @"头像上传成功") delegate:self cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil];
            alert.tag=2;
            [alert show];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UPDATEPHOTO" object:nil];
            [self.view setNeedsLayout];
            
        }
        else
        {
            [self performSelectorOnMainThread:@selector(LoginFailedresult:) withObject:LOCAL(@"busy", @"网络故障，请稍后重试") waitUntilDone:NO];
        }
    }
    else if(method ==comment)
    {

        if(code == 1)
        {
//            NSLog(@"mm=%@",[NSJSONSerialization JSONObjectWithData:response options:nil error:nil]);
//            ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"praiseSuccess",@"赞成功") delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
//            [alert show];
            
            NSString *key = [[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding] autorelease];
            
            NSString *shareId = [param objectForKey:@"itemid"];
            
            for (int i = 0; i<self.list.count; i++) {
                ShareContent *share = [self.list objectAtIndex:i];
                if ([share.shareId isEqualToString:shareId])
                {
                    share.havezan = [NSNumber numberWithInt:key.intValue];
                    share.upnum = [NSNumber numberWithInt:share.upnum.intValue + 1];
                    
                    [ETCoreDataManager updateArticalData:share ById:share.shareId];
                    
                    
                    NSIndexPath *index = [NSIndexPath indexPathForRow:i inSection:0];
                    
                    NSDictionary *fDic = [share.sharePicArr objectAtIndex:0];
                    NSString *source = [NSString stringWithFormat:@"%@",[fDic objectForKey:@"source"]];
                    //        NSString *source = @"http://yunxiaoche.blob.core.windows.net/article-source/39958_1389601724_644558.mp4";
                    NSString *ext = [[source componentsSeparatedByString:@"."] lastObject];
                    
                    if ([ext isEqualToString:@"mp4"]) {
                        GKMovieCell *cell = (GKMovieCell *)[_tableView cellForRowAtIndexPath:index];
                        [cell addPraiseNumber];
                    }
                    else
                    {
                        ClassShareCell *cell = (ClassShareCell *)[_tableView cellForRowAtIndexPath:index];
                        [cell addPraiseNumber];
                    }
                    
                    
                    
                    break;
                }
            }

        }
        else if(code==-6)
        {
//            ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"alreadypraise",@"您已经赞过了") delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
//            [alert show];
            

        }
        else
        {
            [self performSelectorOnMainThread:@selector(LoginFailedresult:) withObject:LOCAL(@"busy", @"网络故障，请稍后重试") waitUntilDone:NO];
        }
        
    }
    else if(method==delete)
    {
        if (code==1)
        {
//            ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"cancelPraiseSuccess",@"取消赞成功") delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
//            [alert show];
            
            NSString *key = [param objectForKey:@"key"];
            
            for (int i = 0; i<self.list.count; i++) {
                ShareContent *share = [self.list objectAtIndex:i];
                if (share.havezan.intValue == key.intValue)
                {
                    share.havezan = [NSNumber numberWithInt:0];
                    share.upnum = [NSNumber numberWithInt:share.upnum.intValue - 1];
                    
                    [ETCoreDataManager updateArticalData:share ById:share.shareId];
                    
                    NSIndexPath *index = [NSIndexPath indexPathForRow:i inSection:0];
                    
                    NSDictionary *fDic = [share.sharePicArr objectAtIndex:0];
                    NSString *source = [NSString stringWithFormat:@"%@",[fDic objectForKey:@"source"]];
                    //        NSString *source = @"http://yunxiaoche.blob.core.windows.net/article-source/39958_1389601724_644558.mp4";
                    NSString *ext = [[source componentsSeparatedByString:@"."] lastObject];
                    
                    if ([ext isEqualToString:@"mp4"]) {
                        GKMovieCell *cell = (GKMovieCell *)[_tableView cellForRowAtIndexPath:index];
                        [cell subPraiseNumber];
                    }
                    else
                    {
                        ClassShareCell *cell = (ClassShareCell *)[_tableView cellForRowAtIndexPath:index];
                        [cell subPraiseNumber];
                    }
                    
                    
                    
                    break;
                }
            }
            
            
        }
        else
        {
            [self performSelectorOnMainThread:@selector(LoginFailedresult:) withObject:LOCAL(@"busy", @"网络故障，请稍后重试") waitUntilDone:NO];
        }
       
    }

    else if (method == article)
    {
        NSLog(@"error code %d",code);
        
  
        if(code == 1)
        {
            
            NSDictionary *result =[NSJSONSerialization JSONObjectWithData:response options:nil error:nil];
            NSLog(@"%@",result);
            
            
            NSArray *arr = [result objectForKey:@"articlelist"];
            if (theRefreshPos == EGORefreshHeader)
            {
                
                NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:@"0",@"TYPE", nil];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"BUDGEHIDDEN" object:nil userInfo:dic];
                
                [self.list removeAllObjects];
                [ETCoreDataManager removeAllArticalData];
                [ETCoreDataManager addArticalData:arr];
                
            }
            if (arr.count <15)
            {
                isMore = NO;
            }
            else
            {
                isMore = YES;
            }
            
          
            [self setArticalData:arr];
            
            
            NSString *isCanPraise = [NSString stringWithFormat:@"%@",[result objectForKey:@"can_comment_action"]];
            NSString *isCanComment = [NSString stringWithFormat:@"%@",[result objectForKey:@"can_comment"]];
            
            user.can_comment_action = isCanPraise;
            user.can_comment = isCanComment;
            
            [ETCoreDataManager saveUser];
            
        }
        else if(code == -2)
        {
            if (theRefreshPos == EGORefreshFooter)
            {
                isMore = NO;
            }
            
        }
        [self upDateUI];
         
    }

}
- (void)alertView:(ETCustomAlertView *)alertView didSelectButtonAtIndex:(NSInteger)index
{
    if (alertView.tag==2)
    {
        if (index==0)
        {
            [_topView.photoImageView setImage:self.headImage];
            NSNotificationCenter *center=[NSNotificationCenter defaultCenter];
            [center postNotificationName:@"PHOTO" object:nil];
            
        }
        else if (index==1)
        {
            NSLog(@"22222222");
        }
    }
}
-(void) setArticalData:(NSArray *) tmpArr
{
    NSArray * arr = tmpArr;
    
    //NSLog(@"data : %@",tmpArr);
    
    for (int i=0; i<[arr count]; i++)
    {
        NSDictionary *myDic=(NSDictionary *)[arr objectAtIndex:i];
        
        ShareContent *share=[[ShareContent alloc]init];
        share.shareId=[myDic objectForKey:@"articleid"];
        
        NSArray * plists = [myDic objectForKey:@"plist"];
        if(plists.count >0)
        {
            share.sharePicArr = plists;
            NSDictionary * plist = [plists objectAtIndex:0];
            if(plist != nil && plist.count > 0)
                share.sharePic=[plist objectForKey:@"source"];
        }
        
        NSArray * tagList=[myDic objectForKey:@"taglist"];
        share.tagArr=tagList;
        share.shareContent=[myDic objectForKey:@"content"];
        share.shareTitle=[myDic objectForKey:@"title"];
        share.upnum=[myDic objectForKey:@"upnum"];
        share.shareKey = [myDic objectForKey:@"articlekey"];
        share.havezan=[myDic objectForKey:@"havezan"];
        share.commentnum=[myDic objectForKey:@"commentnum"];
        NSDateFormatter * format = [[[NSDateFormatter alloc] init] autorelease];
        [format setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSDate * date = [NSDate dateWithTimeIntervalSince1970:[[myDic objectForKey:@"publishtime"] doubleValue]];
        NSString * dateStr = [format stringFromDate:date];
        
        
        share.shareTime=dateStr;
        share.isMore=NO;
        share.publishtime = [myDic objectForKey:@"publishtime"];
        
        
        [self.list addObject:share];

        [share release];
    }

}
#pragma --

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    UserLogin *user = [UserLogin currentLogin];
//    NSLog(@"%d",user.loginStatus);
    
//    if (_tableView) {
//        [_tableView reloadData];
//    }
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doUpdate:) name:@"CommentNumberUpdate" object:nil];
    
//    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
//    if ([[userdefault objectForKey:@"AutoPlay"] isEqualToString:@"1"] || [[userdefault objectForKey:@"AutoPlay"] isEqualToString:@"2"])
//    {//如果设置自动播放
//        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(controlVisibleCellPlay) object:nil];
//        [self performSelector:@selector(controlVisibleCellPlay) withObject:nil afterDelay:0.1f];
//    }
    
    isVisible = YES;
    
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    if ([[userdefault objectForKey:SWITHGESTURE] isEqualToString:@"1"])
    {
        
    }
    
}


- (void)didTapImageWithImageArray:(NSArray *)imgArr showNumber:(int)num content:(ShareContent *)content
{
    
    if (imgArr != nil && content != nil) {
        ETShowBigImageViewController *showBigVC = [[ETShowBigImageViewController alloc] init];
        showBigVC.picArr = imgArr;
        showBigVC.showNum = num;
        showBigVC.title = content.shareTitle;
        showBigVC.content=content.shareContent;
        //[self presentModalViewController:showBigVC animated:YES];
        AppDelegate *aDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
        [aDelegate.bottomNav presentModalViewController:showBigVC animated:YES];
        [showBigVC release];
    }
    
    
}

#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell isKindOfClass:[GKMovieCell class]])
    {
        GKMovieCell *mCell = (GKMovieCell *)cell;
        [mCell.mPlayer stop];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (self.list.count == 0) {
        return 1;
    }
    
    return [self.list count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"NoDataCell";
    static NSString *CellIdentifier1 = @"classCell";
    
    
    if (self.list.count == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentView.backgroundColor = CELLCOLOR;
        UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 151, 131)];
        imgV.image = [UIImage imageNamed:@"nodata.png"];
        imgV.center = CGPointMake(160, ((iphone5 ? 548 : 460) - 46 - 57 - 135)/2);
        [cell addSubview:imgV];
        [imgV release];
        
        
        return cell;
    }
    else
    {
        ShareContent *sContent=[self.list objectAtIndex:indexPath.row];
        NSDictionary *fDic = [sContent.sharePicArr objectAtIndex:0];
        NSString *source = [NSString stringWithFormat:@"%@",[fDic objectForKey:@"source"]];
        NSString *ext = [[source componentsSeparatedByString:@"."] lastObject]; // 获取后缀名
        
        
        if ([ext isEqualToString:@"mp4"])
        {
            CellIdentifier1 = @"movieCell";
            GKMovieCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
            if(cell == nil)
            {
                cell= [[[GKMovieCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier1] autorelease];
                cell.delegate = self;
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
            }
            
            if(indexPath.row==[self.list count]-1)
            {
                if(isMore)
                    [self setFooterView];
                else
                    [self removeFooterView];
            }
            if(self.list.count > 0)
            {
                cell.tag = indexPath.row;
                ShareContent *sContent=[self.list objectAtIndex:indexPath.row];
                
                
                int calculateHeight = 0; // add up height.
                
                CGSize contentSize = [sContent.shareContent sizeWithFont:[UIFont systemFontOfSize:CONTENTFONTSIZE] constrainedToSize:CGSizeMake(300, 1000) lineBreakMode:UILineBreakModeWordWrap];
                
                // 内容高度 contentsize.height
                [cell.contentLabel setFrame:CGRectMake(10,
                                                       calculateHeight + 5, //the distance is between title and content,
                                                       contentSize.width,
                                                       contentSize.height)];
                
                if ([sContent.shareContent isEqualToString:@""] || sContent.shareContent==nil)
                    calculateHeight=0;
                else
                    calculateHeight = calculateHeight+ 5 + contentSize.height;
                

      

                cell.contentLabel.text = sContent.shareContent;
                
                
                
                // --------   加载视频   --------
                    
                cell.contentBackView.frame = CGRectMake(cell.contentBackView.frame.origin.x,
                                                    calculateHeight+5 ,
                                                    cell.contentBackView.frame.size.width,
                                                    cell.contentBackView.frame.size.height);
                [cell setMovieURL:source];
//                NSLog(@"%@",source);

                [cell.movieThumbnailImgV setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@.jpg",source]] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType)
                {
                    
                    cell.movieThumbnailImgV.image = image;
                }];
                
                calculateHeight = calculateHeight +5+ cell.contentBackView.frame.size.height ;
                
        
               // calculateHeight += 10;
                
                cell.timeLabel.frame = CGRectMake(10, calculateHeight+5, cell.timeLabel.frame.size.width, cell.timeLabel.frame.size.height);
                
                calculateHeight=calculateHeight+5+20;
                //----- calculate time -----------
                NSString *time = sContent.publishtime;
                
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
                    cell.timeLabel.text = dateStr;
                }
                
                // -----------------------
                
                int centerHeight = calculateHeight -15+ cell.timeLabel.frame.size.height/2;
                
                cell.praiseButton.frame = CGRectMake(cell.praiseButton.frame.origin.x, centerHeight - cell.praiseButton.frame.size.height/2, cell.praiseButton.frame.size.width, cell.praiseButton.frame.size.height);
                cell.commentsButton.frame = CGRectMake(cell.commentsButton.frame.origin.x, centerHeight - cell.commentsButton.frame.size.height/2, cell.commentsButton.frame.size.width, cell.commentsButton.frame.size.height);
                cell.praiseImgV.frame = CGRectMake(cell.praiseButton.frame.origin.x + 5, centerHeight - 8, 20, 16);
                if (sContent.havezan.intValue == 0)
                {
                    cell.praiseImgV.image = [UIImage imageNamed:@"cellPraise.png"];
                }
                else
                {
                    cell.praiseImgV.image = [UIImage imageNamed:@"myzan.png"];
                }
                cell.theShareCtnt = sContent;
                NSArray *languages = [NSLocale preferredLanguages];
                NSString *currentLanguage = [languages objectAtIndex:0]; //获得当期语言.
                cell.praiseLab.frame = CGRectMake(cell.praiseButton.frame.origin.x + 25, centerHeight - 7, 35, 14);
                cell.praiseLab.text = [NSString stringWithFormat:@"%@", (sContent.upnum.intValue == 0 ? LOCAL(@"upText", @"") : sContent.upnum)];
                if (sContent.upnum.intValue == 0)
                {
                    if([currentLanguage isEqualToString:@"en"])
                    {
                        cell.praiseLab.font = [UIFont systemFontOfSize:8];
                    }
                    else
                    {
                        cell.praiseLab.font = [UIFont systemFontOfSize:12];
                    }
                }
                else
                {
                    cell.praiseLab.font = [UIFont systemFontOfSize:CONTENTFONTSIZE];
                }
                cell.commentImgV.frame = CGRectMake(cell.commentsButton.frame.origin.x + 5, centerHeight - 8, 20, 16);
                cell.commentLab.frame = CGRectMake(cell.commentsButton.frame.origin.x + 25, centerHeight - 7 , 38, 14);
                cell.commentLab.text = [NSString stringWithFormat:@"%@",(sContent.commentnum.intValue == 0 ? LOCAL(@"comText", @"") : sContent.commentnum)];
                if (sContent.commentnum.intValue == 0)
                {
                    if([currentLanguage isEqualToString:@"en"])
                    {
                        cell.commentLab.font = [UIFont systemFontOfSize:8];
                    }
                    else
                    {
                        cell.commentLab.font = [UIFont systemFontOfSize:12];
                    }
                }
                else
                {
                    cell.commentLab.font = [UIFont systemFontOfSize:CONTENTFONTSIZE];
                }
                
                cell.line.frame = CGRectMake(0, calculateHeight + 5, 320, 2);
                
                
                
                UserLogin *user = [UserLogin currentLogin];
                
                if (user.can_comment != nil && [user.can_comment isEqualToString:@"1"]) {
                    //                cell.commentsButton.enabled = YES;
                    cell.commentImgV.image = [UIImage imageNamed:@"cellComment.png"];
                }else{
                    //                cell.commentsButton.enabled = NO;
                    cell.commentImgV.image = [UIImage imageNamed:@"cellComment_disable.png"];
                }
                
                if (user.can_comment_action != nil && [user.can_comment_action isEqualToString:@"1"]) {
                    //                cell.praiseButton.enabled = YES;
                }else{
                    //                cell.praiseButton.enabled = NO;
                    cell.praiseImgV.image = [UIImage imageNamed:@"cellPraise_disable.png"];
                }
                
            }
            
            
            return cell;
            
           
        }
        else
        {
            CellIdentifier1 = @"classCell";
            ClassShareCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
            if(cell == nil)
            {
                cell= [[[ClassShareCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier1 cellMode:Normal] autorelease];
                cell.delegate=self;
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
            }
            
            if(indexPath.row==[self.list count]-1)
            {
                if(isMore)
                    [self setFooterView];
                else
                    [self removeFooterView];
            }
            if(self.list.count >0)
            {
                cell.tag = indexPath.row;
                ShareContent *sContent=[self.list objectAtIndex:indexPath.row];
                float calculateHeight = 0; // add up height.
                
  
                CGSize contentSize = [sContent.shareContent sizeWithFont:[UIFont systemFontOfSize:CONTENTFONTSIZE] constrainedToSize:CGSizeMake(300, 1000) lineBreakMode:UILineBreakModeWordWrap];

//                
                [cell.contentLabel setFrame:CGRectMake(10,
                                                       calculateHeight + 5, //the distance is between title and content,
                                                       contentSize.width,
                                                       contentSize.height)];
                
                if ([sContent.shareContent isEqualToString:@""] || sContent.shareContent==nil)
                    calculateHeight=0;
                else
                    calculateHeight = calculateHeight+ 5 + contentSize.height;
                    
                

                cell.contentLabel.text = sContent.shareContent;
                
                
                
                if ([CellIdentifier1 isEqualToString:@"movieCell"]) {  // 判断是否是视频
                    
                    cell.contentView.frame = CGRectMake(cell.contentView.frame.origin.x,
                                                        calculateHeight + 10,
                                                        cell.contentView.frame.size.width,
                                                        cell.contentView.frame.size.height);

                }
                
                
                int picCount = sContent.sharePicArr.count;
         
               // __block float picHeight=0;
                if(picCount>=1)
                {
                    NSDictionary *dic = [sContent.sharePicArr objectAtIndex:0];
                    NSString *picURL=[NSString stringWithFormat:@"%@",[dic objectForKey:@"source"]];
                    picURL = [picURL stringByAppendingString:@".small.jpg"];
                    
                    [cell.picImageView setImageWithURL:[NSURL URLWithString:picURL] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                        if (error) {
                            
                            //cell.picImageView.image = [UIImage imageNamed:@"imageerror.png"];
                           //  cell.picImageView.frame = CGRectMake(5, calculateHeight + 10 , _tableView.frame.size.width-10, 150);
                        }
                        else
                        {
                           // cell.picImageView.image = image;
                
                            //  float picHeight=image.size.height*(300 /image.size.width);
                            
                         
                            if (cacheType == 0) { // request url
                                CATransition *transition = [CATransition animation];
                                transition.duration = 1.0f;
                                transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                                transition.type = kCATransitionFade;
                                
                                [cell.picImageView.layer addAnimation:transition forKey:nil];
                            }
                        }

                        
                    }];
                    
                    cell.picImageView.frame = CGRectMake(5, calculateHeight + 10 , _tableView.frame.size.width-10, 200);
                   
                }
                else
                {
                     cell.picImageView.image = nil;
                     cell.picImageView.frame = CGRectZero;

                }
                

                
                if (sContent.sharePicArr.count == 1)
                {
                    calculateHeight = calculateHeight+ 5+ 200 ;
                }
                
                

                cell.timeLabel.frame = CGRectMake(10, calculateHeight+10, cell.timeLabel.frame.size.width, cell.timeLabel.frame.size.height);
                calculateHeight = calculateHeight+ 5 +20;
                //----- calculate time -----------
                NSString *time = sContent.publishtime;
                
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
                    cell.timeLabel.text = dateStr;
                }
                
                // -----------------------
                //calculateHeight+ 5 +20
                int centerHeight = calculateHeight-15 + cell.timeLabel.frame.size.height/2;
                
                cell.praiseButton.frame = CGRectMake(cell.praiseButton.frame.origin.x, centerHeight - cell.praiseButton.frame.size.height/2, cell.praiseButton.frame.size.width, cell.praiseButton.frame.size.height);
                
                
                cell.commentsButton.frame = CGRectMake(cell.commentsButton.frame.origin.x, centerHeight - cell.commentsButton.frame.size.height/2, cell.commentsButton.frame.size.width, cell.commentsButton.frame.size.height);
                
                
                cell.praiseImgV.frame = CGRectMake(cell.praiseButton.frame.origin.x + 5, centerHeight - 8, 20, 16);
                
                if (sContent.havezan.intValue == 0)
                {
                    cell.praiseImgV.image = [UIImage imageNamed:@"cellPraise.png"];
                }
                else
                {
                    cell.praiseImgV.image = [UIImage imageNamed:@"myzan.png"];
                }
                
                
                
                NSArray *languages = [NSLocale preferredLanguages];
                NSString *currentLanguage = [languages objectAtIndex:0]; //获得当期语言.
                
                cell.praiseLab.frame = CGRectMake(cell.praiseButton.frame.origin.x + 25, centerHeight - 7, 35, 14);
                cell.praiseLab.text = [NSString stringWithFormat:@"%@", (sContent.upnum.intValue == 0 ? LOCAL(@"upText", @"") : sContent.upnum)];
                if (sContent.upnum.intValue == 0)
                {
                    if([currentLanguage isEqualToString:@"en"])
                    {
                        cell.praiseLab.font = [UIFont systemFontOfSize:8];
                    }
                    else
                    {
                        cell.praiseLab.font = [UIFont systemFontOfSize:12];
                    }
                    
                }
                else
                {
                    cell.praiseLab.font = [UIFont systemFontOfSize:CONTENTFONTSIZE];
                }
                
                cell.commentImgV.frame = CGRectMake(cell.commentsButton.frame.origin.x + 5, centerHeight - 8, 20, 16);
                cell.commentLab.frame = CGRectMake(cell.commentsButton.frame.origin.x + 25, centerHeight - 7 , 38, 14);
                cell.commentLab.text = [NSString stringWithFormat:@"%@",(sContent.commentnum.intValue == 0 ? LOCAL(@"comText", @"") : sContent.commentnum)];
                if (sContent.commentnum.intValue == 0)
                {
                    
                    if([currentLanguage isEqualToString:@"en"])
                    {
                        cell.commentLab.font = [UIFont systemFontOfSize:8];
                    }
                    else
                    {
                        cell.commentLab.font = [UIFont systemFontOfSize:12];
                    }
                    
                }
                else
                {
                    cell.commentLab.font = [UIFont systemFontOfSize:CONTENTFONTSIZE];
                }
                
                cell.line.frame = CGRectMake(0, calculateHeight + 5, 320, 2);
                
                
                cell.theShareCtnt = sContent;
                
                
                UserLogin *user = [UserLogin currentLogin];
                
                if (user.can_comment != nil && [user.can_comment isEqualToString:@"1"]) {
                    //                cell.commentsButton.enabled = YES;
                    cell.commentImgV.image = [UIImage imageNamed:@"cellComment.png"];
                }else{
                    //                cell.commentsButton.enabled = NO;
                    cell.commentImgV.image = [UIImage imageNamed:@"cellComment_disable.png"];
                }
                
                if (user.can_comment_action != nil && [user.can_comment_action isEqualToString:@"1"]) {
                    //                cell.praiseButton.enabled = YES;
                }else{
                    //                cell.praiseButton.enabled = NO;
                    cell.praiseImgV.image = [UIImage imageNamed:@"cellPraise_disable.png"];
                }
                
            }
            
            
            return cell;
            
        }
        
        
        
        
    }
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    if(self.list.count == 0) return (iphone5 ? 568 : 460) - 46 - 57 - 135;
    
    ShareContent *sContent=[self.list objectAtIndex:indexPath.row];
    
    int calculateHeight = 0; // add up height.
    
    CGSize contentSize = [sContent.shareContent sizeWithFont:[UIFont systemFontOfSize:CONTENTFONTSIZE] constrainedToSize:CGSizeMake(300, 1000) lineBreakMode:UILineBreakModeWordWrap];

    if ([sContent.shareContent isEqualToString:@""] || sContent.shareContent==nil)
        calculateHeight=0;
    else
        calculateHeight = calculateHeight+ 5 + contentSize.height;
    



    
    NSDictionary *fDic = [sContent.sharePicArr objectAtIndex:0];
    NSString *source = [NSString stringWithFormat:@"%@",[fDic objectForKey:@"source"]];
    NSString *ext = [[source componentsSeparatedByString:@"."] lastObject]; // 获取后缀名
    
    
    if ([ext isEqualToString:@"mp4"])
    {
        calculateHeight = calculateHeight+5 + 300 + 5 + 20 + 5 +2;
    }
    else
    {

        
        
       // ClassShareCell*cell=(ClassShareCell *)[tableView cellForRowAtIndexPath:indexPath];
//        
        NSDictionary *dic = [sContent.sharePicArr objectAtIndex:0];
        NSString *picURL=[NSString stringWithFormat:@"%@",[dic objectForKey:@"source"]];
        picURL = [picURL stringByAppendingString:@".small.jpg"];

        
        if (sContent.sharePicArr.count == 1)
        {
            calculateHeight = calculateHeight +5+  200 + 5 + 20 + 5+2;
        }
        
//        calculateHeight = calculateHeight + 10 + (sContent.sharePicArr.count == 0 ? 0 : ((sContent.sharePicArr.count-1)/3 + 1) * (75 + 10)) + 10 + 26;
    }
    
    
//    NSLog(@"index path %d,    %d",indexPath.row,calculateHeight);
    
    return calculateHeight;
       
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.list.count == 0)
        return;
    
    ShareContent *_shareContent=[self.list objectAtIndex:indexPath.row];
    CommentDetailViewController *detailviewcontroller=[[CommentDetailViewController alloc]init];
    detailviewcontroller.shareContent = _shareContent;
    detailviewcontroller.delegate=self;
    detailviewcontroller.shareContent.isMore = YES;
//    [self.navigationController pushViewController:detailviewcontroller animated:YES];
    AppDelegate *appDel = SHARED_APP_DELEGATE;
    [appDel.bottomNav pushViewController:detailviewcontroller animated:YES];
    
    [detailviewcontroller release];
}

-(void)setisVisiblebecomeYES
{
    isVisible=YES;
}

#pragma mark - Table view delegate

- (void)slimeRefreshStartRefresh:(SRRefreshView *)refreshView
{
    NSLog(@"start refresh");
//    [self showHUD:YES];
    NSDictionary * param = [NSDictionary dictionaryWithObjectsAndKeys:@"0",@"starttime",@"0",@"endtime",nil];
    
    theRefreshPos = EGORefreshHeader;
    [self requestArticalData:param];
}

- (void)reloadTableViewDataSource:(EGORefreshPos)aRefreshPos
{
    //获取信息
    if(aRefreshPos == EGORefreshHeader)
    {
//        isLoading = YES;
//        currentIndex=0;
//        
//        [self showHUD:YES];
//        NSDictionary * param = [NSDictionary dictionaryWithObjectsAndKeys:@"0",@"starttime",@"0",@"endtime",nil];
//        
//        theRefreshPos = EGORefreshHeader;
//        [self requestArticalData:param];
    }
    else
    {
        if(aRefreshPos == EGORefreshFooter)
        {
            //连接服务器
            isLoading = YES;
//            [self showHUD:YES];
            
            
            // 获取最后一条数据时间
            
            ShareContent *sc = [self.list lastObject];
            NSString *lastTime = sc.publishtime;
            NSDictionary * param = [NSDictionary dictionaryWithObjectsAndKeys:lastTime,@"starttime",@"0",@"endtime",nil];
            
            theRefreshPos = EGORefreshFooter;
            [self requestArticalData:param];
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

- (void)clickComment:(ShareContent *)content
{
    UserLogin *user = [UserLogin currentLogin];
    
    if (user.can_comment == nil || [user.can_comment isEqualToString:@"0"]) // pinglun
    {
        ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"nofunction", @"") delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
        [alert show];
        
        return;
    }
    
    CommentDetailViewController *detailviewcontroller=[[CommentDetailViewController alloc]init];
    detailviewcontroller.shareContent = content;
    detailviewcontroller.shareContent.isMore = YES;
    //    [self.navigationController pushViewController:detailviewcontroller animated:YES];
    AppDelegate *appDel = SHARED_APP_DELEGATE;
    [appDel.bottomNav pushViewController:detailviewcontroller animated:YES];
    
    [detailviewcontroller release];
}

- (void) clickPraise:(UITableViewCell *)cell
{
    
    UserLogin *user = [UserLogin currentLogin];
    
    if (user.can_comment_action == nil || [user.can_comment_action isEqualToString:@"0"]) // zan 
    {
        ETCustomAlertView *alert=[[ETCustomAlertView alloc]initWithTitle:LOCAL(@"alert", @"提示") message:LOCAL(@"nofunction", @"") delegate:nil cancelButtonTitle:LOCAL(@"ok", @"确定") otherButtonTitles:nil, nil];
        [alert show];
        
        return;
    }
    
    
    NSIndexPath *indexpath = [_tableView indexPathForCell:cell];
    
    ShareContent *sContent=[self.list objectAtIndex:indexpath.row];
    
    ETCommonClass *com = [[[ETCommonClass alloc] init] autorelease];
    [com requestLoginWithComplete:^(NSError *err){
        
        if([sContent.havezan integerValue]==0)
        {
            NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:sContent.shareId,@"itemid",@"article",@"itemtype", @"1",@"isup",nil];
            
            [[EKRequest Instance] EKHTTPRequest:comment parameters:dic requestMethod:POST forDelegate:self];
            
            // 没攒的情况下 操作
            
            // 没攒
        }
        else
        {
            NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:@"comment_action",@"type",sContent.havezan,@"key",nil];
            //取消赞.
            
            [[EKRequest Instance] EKHTTPRequest:delete parameters:dic requestMethod:POST forDelegate:self];
            
        }
        
    }];
    
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
-(void)photo:(NSNotification *)no
{
    
    //更新学生信息 获取头像链接  此函数请求学生信息接口   服务器返回已更改  本地更新数据库 并更新UI  以后 学生昵称，年龄，等学生信息均可使用该函数.
    
    [_topView.photoImageView setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@""] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        
        _topView.photoImageView.image = image;
    }];
    
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //[super scrollViewDidEndDecelerating:scrollView];
    
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    if ([[userdefault objectForKey:@"AutoPlay"] isEqualToString:@"1"] || [[userdefault objectForKey:@"AutoPlay"] isEqualToString:@"2"])
    {//如果设置自动播放
        
        
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(controlVisibleCellPlay) object:nil];
        [self performSelector:@selector(controlVisibleCellPlay) withObject:nil afterDelay:0.1f];
        
        
        
    }
}
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    
//
//    
//    
//    
//    
//}



- (void)controlVisibleCellPlay
{
    
    if (!isVisible) {
        return;
    }
    
    NSArray *cells = [_tableView visibleCells];
    
    GKMovieManager *mm = [GKMovieManager shareManager];
//    NSMutableArray *tempDownloadingArray = [NSMutableArray arrayWithArray:mm.downloadList];
    
//    NSLog(@"%@",cells);
    
    GKMovieCell *cell;
    
    int minDis = 1000;
    
    for (int i = cells.count - 1 ; i>=0 ; i--) {
        id obj = [cells objectAtIndex:i];
        
        if ([obj isKindOfClass:[GKMovieCell class]])
        {
            GKMovieCell *tempCell = (GKMovieCell *)obj;
            
            int dis = ABS(tempCell.frame.origin.y - (_tableView.contentOffset.y));
            if (dis < minDis) {
                minDis = dis;
                cell = tempCell;
            }

        }
        
    }
    

    
    if (minDis != 1000)
    {
        if (cell.mPlayer.playbackState == MPMoviePlaybackStateStopped || cell.mPlayer.playbackState == MPMoviePlaybackStatePaused)
        {
            
            [mm toggleMoviePlayingWithCell:cell];
        }
    }
    
    
    
}

- (BOOL)shouldAutorotate
{
    //    if ([self isKindOfClass:[ETShowBigImageViewController class]]) { // 如果是这个 vc 则支持自动旋转
    //        return YES;
    //    }
    return NO;
}



@end
