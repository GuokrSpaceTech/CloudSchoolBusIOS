//
//  CBMineViewController.m
//  CloudBusParent
//
//  Created by HELLO  on 15/11/5.
//  Copyright (c) 2015年 BeiJingYinChuang. All rights reserved.
//

#import "CBMineViewController.h"
#import "EKRequest.h"
#import "MineHeaderView.h"
#import "QRCodeReader.h"
#import "QRCodeReaderViewController.h"
#import "ClassSwitchTableViewController.h"
#import "CBDateBase.h"
#import "Masonry.h"
#import "CBLoginInfo.h"
#import "Teacher.h"
#import "School.h"
#import "ClassObj.h"
#import "UIImageView+WebCache.h"
#import "MineCell.h"
#import "Calculate.h"
#import "CB.h"
#import "UIColor+RCColor.h"
#import "CBWebViewController.h"
#import "UploadingTableViewController.h"
#import "KLCPopup.h"
#import <QuartzCore/QuartzCore.h>
#import "CBDateBase.h"
#import "AppDelegate.h"

@interface CBMineViewController ()<EKProtocol, UIAlertViewDelegate, QRCodeReaderDelegate>
{
    MineHeaderView * headeView;
    KLCPopup* popup;
    QRCodeReader *reader;
}
-(void)postChildSwitchNotification:(NSString *)currentStudent;
-(void)handleSingleTap:(id)sender;
-(void)changeAvatar:(id)sender;
@end

@implementation CBMineViewController
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Title
    self.navigationItem.title = @"我的";
    
    //Talbe style
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[MineCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.scrollEnabled = NO;
    self.tableView.rowHeight = 44;
    
    /*
     *Header View
     */
    headeView = [[MineHeaderView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 120)];
    [self currentTeacher];
    self.tableView.tableHeaderView  = headeView;
    
    //退出按钮
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    //button.frame = CGRectMake(0, 0, 100, 100);
    [button addTarget:self action:@selector(quit:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"退出登录" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.backgroundColor = [UIColor redColor];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(@(SCREENWIDTH-40));
        make.top.equalTo(self.view.mas_top).offset(400);
        make.height.mas_equalTo(@(40));
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeAvatar:)];
    [headeView.avatarImageView addGestureRecognizer:tapGesture];
    [headeView.avatarImageView setUserInteractionEnabled:YES];
    
    //QRCode Object
    // Create the reader object
    reader = [QRCodeReader readerWithMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
    
    // Instantiate the view controller
    QRCodeReaderViewController *vc = [QRCodeReaderViewController readerWithCancelButtonTitle:@"Cancel" codeReader:reader startScanningAtLoad:YES showSwitchCameraButton:YES showTorchButton:YES];
    
    // Set the presentation style
    vc.modalPresentationStyle = UIModalPresentationFormSheet;
    
    // Define the delegate receiver
    vc.delegate = self;
    
    // Or use blocks
    [reader setCompletionWithBlock:^(NSString *resultAsString) {
        NSLog(@"%@", resultAsString);
    }];
}
-(void)currentTeacher
{
    CBLoginInfo * info = [CBLoginInfo shareInstance];
    
    Teacher * teacher = [info findMe];
    if(teacher)
    {
        [headeView.avatarImageView sd_setImageWithURL:[NSURL URLWithString:teacher.avatar] placeholderImage:nil];
        headeView.nameLabel.text = teacher.name;
        School *school = [info.schoolArr objectAtIndex:0];
        NSString *schoolname;
        if(school)
        {
            schoolname = school.name;
            [headeView.schoolLabel setTitle:[NSString stringWithFormat:@"  %@  ",schoolname] forState:UIControlStateNormal];
            headeView.schoolLabel.titleLabel.font = [UIFont systemFontOfSize:12.0f];
            headeView.schoolLabel.layer.borderWidth = 1;
            headeView.schoolLabel.layer.borderColor = [UIColor whiteColor].CGColor;
            headeView.schoolLabel.layer.cornerRadius = 12;
            [headeView.schoolLabel setBackgroundColor:[UIColor colorWithHexString:@"#ED7426" alpha:1.0f]];

        }
        headeView.nameLabel.text = teacher.nickname;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 5;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MineCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    if(indexPath.row == 0)
    {
        cell.titleLabel.text = @"切换班级";
        cell.iconImageView.image = [UIImage imageNamed:@"ic_swap_horiz"];
        cell.iconImageView.contentMode = UIViewContentModeScaleAspectFit;
        cell.detailLabel.text = @"";
    }
    else if(indexPath.row == 1)
    {
        cell.titleLabel.text = @"扫一扫";
        cell.iconImageView.image = [UIImage imageNamed:@"ic_aspect_ratio"];
        cell.iconImageView.contentMode = UIViewContentModeScaleAspectFit;
        cell.detailLabel.text = @"";
    }
    else if(indexPath.row == 2)
    {
        cell.titleLabel.text = @"清除缓存";
        cell.iconImageView.image = [UIImage imageNamed:@"ic_settings"];
        cell.iconImageView.contentMode = UIViewContentModeScaleAspectFit;
        cell.detailLabel.text = [NSString stringWithFormat:@"%0.2fM",[Calculate checkTmpSize]];
    }
    else if(indexPath.row == 3)
    {
        cell.titleLabel.text = @"正在上传";
        cell.iconImageView.image = [UIImage imageNamed:@"ic_filter"];
        cell.iconImageView.contentMode = UIViewContentModeScaleAspectFit;
        cell.detailLabel.text = @"";
        if(_isUploadingNotifying)
            cell.redDotButton.hidden = NO;
        else
            cell.redDotButton.hidden = YES;
    }
    else
    {
        cell.titleLabel.text = @"关于我们";
        cell.iconImageView.image = [UIImage imageNamed:@"ic_info_outline"];
        cell.iconImageView.contentMode = UIViewContentModeScaleAspectFit;
        cell.detailLabel.text = @"";
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
//        UIView *contentView = [self generateChildrenSwitchView];
//        
//        // Show in popup
//        KLCPopupLayout layout = KLCPopupLayoutMake(KLCPopupHorizontalLayoutCenter, KLCPopupVerticalLayoutCenter);
//        
//        popup = [KLCPopup popupWithContentView:contentView
//                                      showType:KLCPopupShowTypeFadeIn
//                                   dismissType:KLCPopupDismissTypeFadeOut
//                                      maskType:KLCPopupMaskTypeDimmed
//                      dismissOnBackgroundTouch:YES
//                         dismissOnContentTouch:NO];
//        
//        [popup showWithLayout:layout];
        ClassSwitchTableViewController *vc = [[ClassSwitchTableViewController alloc]initWithNibName:@"ClassSwitchTableViewController" bundle:nil];
        vc.classArr = [CBLoginInfo shareInstance].classArr;
        vc.schoolArr = [CBLoginInfo shareInstance].schoolArr;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.row == 1)
    {
        QRCodeReaderViewController *vc = [QRCodeReaderViewController readerWithCancelButtonTitle:@"Cancel" codeReader:reader startScanningAtLoad:YES showSwitchCameraButton:NO showTorchButton:YES];
        vc.delegate = self;
        [self presentViewController:vc animated:YES completion:NULL];
    }
    else if(indexPath.row == 2)
    {
        [Calculate clearTmpPics:^{
            [self.tableView reloadData];
        }];
    }
    else if(indexPath.row == 3)
    {
        UploadingTableViewController *uploadVC = [[UploadingTableViewController alloc]initWithNibName:@"UploadingTableViewController" bundle:nil];
        [self.navigationController pushViewController:uploadVC animated:YES];
        _isUploadingNotifying = FALSE;
    }
    else if(indexPath.row == 4)
    {
        CBWebViewController *webVC = [[CBWebViewController alloc] init];
        webVC.titleStr = @"云中校车";
        webVC.urlStr =  @"http://www.yunxiaoche.com/about_us.html";
        
        [[self navigationController] pushViewController:webVC animated:YES];
    }
}

-(UIView *)generateChildrenSwitchView
{
    NSNumber *avatarViewWidth  = @60;
    NSNumber *avatarViewHeight = @60;
    static double   PADDING = 10;
    double left=0.0;
    double contentViewWidth=0.0;
    double contentViewHeight=0.0;
    
    UIView* contentView = [[UIView alloc] init];
    contentView.translatesAutoresizingMaskIntoConstraints = NO;
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.layer.cornerRadius = 12.0;
    
    CBLoginInfo * info = [CBLoginInfo shareInstance];
    int i = 0;
    for (ClassObj *classinfo in info.classArr) {
        
        left = left + i*([avatarViewWidth doubleValue]) + PADDING;
        
        UIButton *avatarView = [[UIButton alloc] init];
        avatarView.translatesAutoresizingMaskIntoConstraints = NO;
        avatarView.backgroundColor = [UIColor clearColor];
        [avatarView addTarget:self action:@selector(handleSingleTap:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.textColor = [UIColor blackColor];
        nameLabel.font = [UIFont boldSystemFontOfSize:12.0];
        
        [contentView addSubview:avatarView];
        [contentView addSubview:nameLabel];
        
        [avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(contentView.mas_leading).offset(left);
            make.top.equalTo(contentView.mas_top).offset(PADDING);
            make.height.equalTo(avatarViewHeight);
            make.width.equalTo(avatarViewWidth);
        }];
        
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(avatarView.mas_centerX);
            make.top.equalTo(avatarView.mas_bottom).offset(PADDING);
        }];
        
//        SDWebImageManager *manager = [SDWebImageManager sharedManager];
//        [manager downloadImageWithURL:[NSURL URLWithString:teacher.avatar]
//                              options:0
//                             progress:^(NSInteger receivedSize, NSInteger expectedSize) {
//                                 // progression tracking code
//                             }
//                            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
//                                if (image) {
//                                    [avatarView setImage:image forState:UIControlStateNormal];
//                                    [avatarView setTag:i];
//                                }
//                            }];
        
        nameLabel.text = classinfo.className;
        
        i++;
    }
    
    contentViewWidth =  i*(PADDING + [avatarViewWidth doubleValue]) + PADDING;
    contentViewHeight = PADDING*3 + [avatarViewHeight doubleValue] + 20;
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(contentViewWidth);
        make.height.mas_equalTo(contentViewHeight);
    }];
    
    return contentView;
}

#pragma mark User Actions
-(void)quit:(UIButton *)btn
{
    [[CBDateBase sharedDatabase] clearTable];
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [[delegate.window.rootViewController navigationController] popToRootViewControllerAnimated:YES];
    [delegate makeLoginViewController];
}
-(void)handleSingleTap:(id)sender
{
    UIButton *button = sender;
    int i = (int)[button tag];
    
    CBLoginInfo * info = [CBLoginInfo shareInstance];
    
    ClassObj *classinfo = [info.classArr objectAtIndex:i];
    info.currentClassId = classinfo.classid;
    
    [self postChildSwitchNotification:info.currentClassId];
    
    [popup dismiss:YES];
}
-(void)changeAvatar:(id)sender
{
    //构建图像选择器
    UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
    //设置代理为本身（实现了UIImagePickerControllerDelegate协议）
    pickerController.delegate = self;
    //是否允许对选中的图片进行编辑
    pickerController.allowsEditing = YES;
    
    //设置图像来源类型(先判断系统中哪种图像源是可用的)
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    }else if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
        pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }else {
        pickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    }
    
    pickerController.allowsEditing = true;
    
    //打开模态视图控制器选择图像
    [self presentViewController:pickerController animated:YES completion:^{
        NSLog(@"");
    }];
}

-(void)postChildSwitchNotification:(NSString *)currentStudent
{
    NSDictionary *userInfoDict = [NSDictionary dictionaryWithObjectsAndKeys:currentStudent,@"current", nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"studentswitch" object:nil userInfo:userInfoDict];
}

#pragma mark - ImagePickerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    [picker dismissModalViewControllerAnimated:YES];
    
    NSData *baseString = UIImageJPEGRepresentation(image, 0.8);
    
    NSString *studentid = [[CBLoginInfo shareInstance] currentClassId];
    
    NSDictionary *paramDict = @{@"studentid":studentid, @"fbody":baseString};
    
    [[EKRequest Instance] EKHTTPRequest:uploadAvatar parameters:paramDict requestMethod:POST forDelegate:self];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{
        NSLog(@"取消选择");
    }];
}

#pragma mark EKRequest Delegate
-(void)getEKResponse:(id)response forMethod:(RequestFunction)method resultCode:(int)code withParam:(NSDictionary *)param
{
    NSDictionary *returnDict = (NSDictionary *)response;
    NSString *filePath = [returnDict objectForKey:@"filepath"];
    
    if(code == 1 && method == uploadAvatar)
    {
        if([filePath containsString:@"://"])
        {
            //Update UI
            [headeView.avatarImageView sd_setImageWithURL:[NSURL URLWithString:filePath] placeholderImage:nil];
            
            //Update Memory
            NSMutableArray *studentArray = [[CBLoginInfo shareInstance] studentArr];
            for (int i=0; i<[studentArray count]; i++) {
//                
//                Student *student = studentArray[i];
//                NSString *current = [[CBLoginInfo shareInstance] currentClassId];
//                if([[student studentid] isEqualToString:current])
//                {
//                    [student setAvatar:filePath];
//                    
//                    [[[CBLoginInfo shareInstance] studentArr] replaceObjectAtIndex:i withObject:student];
//                    
//                    
//                    //Update DB
//                    //Json to Dict
//                    NSString *baseInfoJson = [[CBLoginInfo shareInstance] baseInfoJsonString];
//                    NSError *jsonError;
//                    NSData *objectData = [baseInfoJson dataUsingEncoding:NSUTF8StringEncoding];
//                    NSDictionary *baseInfoDict = [NSJSONSerialization JSONObjectWithData:objectData
//                                                                                 options:NSJSONReadingMutableContainers
//                                                                                   error:&jsonError];
//                    [[[baseInfoDict objectForKey:@"students"] objectAtIndex:i] setValue:filePath forKey:@"avatar"];
//                    
//                    //Dict to Json
//                    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:baseInfoDict
//                                                                       options:NSJSONWritingPrettyPrinted
//                                                                         error:&jsonError];
//                    if (! jsonData) {
//                        NSLog(@"JsonConvertion Error: %@", jsonError.localizedDescription);
//                    } else {
//                        baseInfoJson = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//                        [[CBDateBase sharedDatabase] insertDataToBaseInfoTableWithBaseinfo:baseInfoJson];
//                    }
//                }
            }
        }
    }
    else if (code == 1 && method == login)
    {
        
    }
    else if(code < 0)
    {
        //SESSION 超时
        NSDictionary *responseDict = (NSDictionary *)response;
        NSString *errorMessage = [responseDict objectForKey:@"err_message"];
        if(errorMessage!=nil && [errorMessage containsString:@"SESSION"])
        {
            NSString *mobile = [[CBLoginInfo shareInstance] phone];
            NSString *token = [[CBLoginInfo shareInstance] token];
            NSDictionary *paramDict = @{@"mobile":mobile, @"token":token};
            [[EKRequest Instance] EKHTTPRequest:login parameters:paramDict requestMethod:GET forDelegate:self];
        }
        else if(code == -1118)
        {
            UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"" message:@"检测到多用户登录，系统自动退出" delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
            [alertview show];
        }
    }
    
    
}

-(void)getErrorInfo:(NSError *)error forMethod:(RequestFunction)method
{
    NSLog(@"");
}
/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Table view delegate
 
 // In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
 - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
 // Navigation logic may go here, for example:
 // Create the next view controller.
 <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
 
 // Pass the selected object to the new view controller.
 
 // Push the view controller.
 [self.navigationController pushViewController:detailViewController animated:YES];
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma AlertView Delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self quit:nil];
}

#pragma mark - QRCodeReader Delegate Methods

- (void)reader:(QRCodeReaderViewController *)reader didScanResult:(NSString *)result
{
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"%@", result);
    }];
}

- (void)readerDidCancel:(QRCodeReaderViewController *)reader
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}
@end
