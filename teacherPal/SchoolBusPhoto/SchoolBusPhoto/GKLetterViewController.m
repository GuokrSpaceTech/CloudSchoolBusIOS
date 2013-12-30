//
//  GKLetterViewController.m
//  SchoolBusPhoto
//
//  Created by wen peifang on 13-10-28.
//  Copyright (c) 2013年 mactop. All rights reserved.
//

#import "GKLetterViewController.h"
#import "GTMBase64.h"
#import "GKLetterData.h"
#import "GKShowBigImageViewController.h"
#import "KKNavigationController.h"
#import <AssetsLibrary/AssetsLibrary.h>
@interface GKLetterViewController ()

@end

@implementation GKLetterViewController
@synthesize _tableView;
@synthesize dataArr;
@synthesize _slimeView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [(KKNavigationController *)self.navigationController setNavigationTouch:NO];
}
-(void)keyboarChange:(NSNotification *)noti
{
    NSDictionary *userInfo=[noti userInfo];
    
    CGRect rect=[[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGRect rect1=[[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    
    
    NSLog(@"%f---%f",rect1.size.width,rect1.size.height);
    
    [UIView animateWithDuration:0.2 animations:^{
        inputView.frame=CGRectMake(0, self.view.frame.size.height-rect.size.height-57, rect.size.width, rect.size.height);
        if(ios7)
            _tableView.frame=CGRectMake(0, -rect.size.height, rect.size.width,self.view.frame.size.height-navigationView.frame.size.height-navigationView.frame.origin.y+20);
        else
            _tableView.frame=CGRectMake(0, -rect.size.height, rect.size.width,self.view.frame.size.height-navigationView.frame.size.height-navigationView.frame.origin.y);
        
        
    }];
    
}
-(void)keyboarHidden:(NSNotification *)noti
{
    
    
    [UIView animateWithDuration:0.2 animations:^{
        inputView.frame=CGRectMake(0, self.view.frame.size.height-57, 320, 57);
        _tableView.frame=CGRectMake(0,navigationView.frame.size.height+navigationView.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height-navigationView.frame.size.height-navigationView.frame.origin.y-57-10);
    }];
    
}
-(void)keyboarShow:(NSNotification *)noti
{
    NSDictionary *userInfo=[noti userInfo];
    
    CGRect rect=[[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    [UIView animateWithDuration:0.2 animations:^{
         inputView.frame=CGRectMake(0, self.view.frame.size.height-rect.size.height-57, rect.size.width, rect.size.height);
        if(ios7)
        _tableView.frame=CGRectMake(0, -rect.size.height, rect.size.width,self.view.frame.size.height-navigationView.frame.size.height-navigationView.frame.origin.y+10);
        else
        _tableView.frame=CGRectMake(0, -rect.size.height, rect.size.width,self.view.frame.size.height-navigationView.frame.size.height-navigationView.frame.origin.y);
    }];
  
   
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboarChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboarHidden:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboarShow:) name:UIKeyboardWillShowNotification object:nil];
    
    
    
    UIButton *buttom=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    buttom.frame=CGRectMake(10, 5, 34, 35);
    //UIButton *buttom=[[UIButton alloc]initWithFrame:CGRectMake(10, 5, 34, 35)];
    [buttom setBackgroundImage:IMAGENAME(IMAGEWITHPATH(@"back")) forState:UIControlStateNormal];
    [buttom setBackgroundImage:IMAGENAME(IMAGEWITHPATH(@"backH")) forState:UIControlStateHighlighted];
    buttom.tag=0;
    [buttom addTarget:self action:@selector(leftClick:) forControlEvents:UIControlEventTouchUpInside];
    [navigationView addSubview:buttom];

    UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(0, navigationView.frame.origin.y+navigationView.frame.size.height, 320, self.view.frame.size.height)];
    bgView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:bgView];
    [bgView release];
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0,navigationView.frame.size.height+navigationView.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height-navigationView.frame.size.height-navigationView.frame.origin.y-57-10) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
  
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];

    
    [self.view bringSubviewToFront:navigationView];

    
    _slimeView = [[SRRefreshView alloc] init];
    _slimeView.delegate = self;
    _slimeView.upInset = 0;
    _slimeView.slimeMissWhenGoingBack = YES;
    _slimeView.slime.bodyColor = [UIColor blackColor];
    _slimeView.slime.skinColor = [UIColor blackColor];
    _slimeView.slime.lineWith = 1;
    _slimeView.slime.shadowBlur = 4;
    _slimeView.slime.shadowColor = [UIColor blackColor];
    
    [_tableView addSubview:self._slimeView];
    
    titlelabel.text=NSLocalizedString(@"message", @"");
    
    
    dataArr=[[NSMutableArray alloc]init];
    
    

   
    inputView=[[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-57, 320, 57)];
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 57)];
    imageView.image=IMAGENAME(IMAGEWITHPATH(@"inputBG"));
    [inputView addSubview:imageView];
    [imageView release];
    
    
    
    
    inputField=[[UITextField alloc]initWithFrame:CGRectMake(57, 15, 180, 27)];
    inputField.borderStyle=UITextBorderStyleRoundedRect;
    inputField.delegate=self;
    inputField.placeholder=NSLocalizedString(@"ask", @"");
    [inputView addSubview:inputField];
    
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=CGRectMake(15, 13, 32, 32);
    [button setBackgroundImage:IMAGENAME(IMAGEWITHPATH(@"pic-1"))forState:UIControlStateNormal];
    [button setBackgroundImage:IMAGENAME(IMAGEWITHPATH(@"pic-2")) forState:UIControlStateHighlighted];
    button.titleLabel.font=[UIFont systemFontOfSize:12];
    [button addTarget:self action:@selector(picClick:) forControlEvents:UIControlEventTouchUpInside];
    [inputView addSubview:button];
    
    UIButton *upbutton=[UIButton buttonWithType:UIButtonTypeCustom];
    upbutton.frame=CGRectMake(250, 13, 64, 30);
    [upbutton setTitle:NSLocalizedString(@"send", @"") forState:UIControlStateNormal];
    upbutton.titleLabel.font=[UIFont systemFontOfSize:12];
    [upbutton setBackgroundImage:IMAGENAME(IMAGEWITHPATH(@"send_23")) forState:UIControlStateNormal];
    [upbutton setBackgroundImage:IMAGENAME(IMAGEWITHPATH(@"send_24")) forState:UIControlStateHighlighted];
    [upbutton addTarget:self action:@selector(upClick:) forControlEvents:UIControlEventTouchUpInside];
    [inputView addSubview:upbutton];
    
    [self.view addSubview:inputView];
    [inputView release];
    
    
   // [imageView];
    [self.view bringSubviewToFront:_imageView11];
    
    [self loadData];
	// Do any additional setup after loading the view.
}
-(void)leftClick:(UIButton *)btn
{
    
    GKMainViewController *main=[GKMainViewController share];
    if(main.state==0)
    {
        if ([[GKMainViewController share] respondsToSelector:@selector(showSideBarControllerWithDirection:)]) {
            [[GKMainViewController share] showSideBarControllerWithDirection:SideBarShowDirectionLeft];
        }
    }
    else
    {
        if ([[GKMainViewController share] respondsToSelector:@selector(showSideBarControllerWithDirection:)]) {
            [[GKMainViewController share] showSideBarControllerWithDirection:SideBarShowDirectionNone];
        }
    }
    
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //[inputField11 resignFirstResponder];
    [inputField resignFirstResponder];
    return YES;
}
-(void)picClick:(UIButton *)btn
{
    
    
    [inputField resignFirstResponder];
    UIActionSheet *sheet=[[UIActionSheet alloc]initWithTitle:NSLocalizedString(@"pic", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", @"") destructiveButtonTitle:NSLocalizedString(@"takePhoto", @"") otherButtonTitles:NSLocalizedString(@"choose", @""), nil];
    [sheet showInView:self.view];
    [sheet release];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if(buttonIndex==0)
    {
        UIImagePickerController *pickerController=[[UIImagePickerController alloc]init];
        pickerController.delegate=self;
        pickerController.allowsEditing=YES;
        NSLog(@"paiz");
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            pickerController.sourceType=UIImagePickerControllerSourceTypeCamera;
        }
        else
        {
            pickerController.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
        }
        [self.navigationController presentViewController:pickerController animated:YES completion:^{
            
        }];
        [pickerController release];
        
    }
    if(buttonIndex==1)
    {
        UIImagePickerController *pickerController=[[UIImagePickerController alloc]init];
        pickerController.delegate=self;
        pickerController.allowsEditing=YES;
        NSLog(@"选取");
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
        {
            pickerController.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
        }
        
        [self.navigationController presentViewController:pickerController animated:YES completion:^{
            
        }];
        [pickerController release];
    }
 
  
}
-(void)upClick:(UIButton *)btn
{
    if([inputField.text isEqualToString:@""])
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"input", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        
        return;
    }
    
    
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:inputField.text,@"content",@"txt",@"lettertype", nil];
    [[EKRequest Instance]EKHTTPRequest:LetterF parameters:dic requestMethod:POST forDelegate:self];

    
}
-(void)loadData
{
    
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:@"0",@"starttime",@"0",@"endtime", nil];
    [[EKRequest Instance]EKHTTPRequest:LetterF parameters:dic requestMethod:GET forDelegate:self];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    

    UIImage *theImage;
    if ([picker allowsEditing]){
        //获取用户编辑之后的图像
        theImage = [info objectForKey:UIImagePickerControllerEditedImage];
    } else {
        // 照片的元数据参数
        theImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        
    }
    
    
    
    
//    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
//    [library assetForURL:[info objectForKey:UIImagePickerControllerReferenceURL]
//             resultBlock:^(ALAsset *asset)
//     {
//        // NSData * data = UIImageJPEGRepresentation(image, 0.5);
//         
//     }failureBlock:^(NSError *error){
//         NSLog(@"couldn't get asset: %@", error);
//     }
//     ];
//    
    
    
   // fixOrientation111()
    
    NSData *data= UIImageJPEGRepresentation(theImage, 0.5);
    
    UIImage *image=[UIImage imageWithData:data];
    NSData *dataqq=UIImageJPEGRepresentation(image, 1);
    NSString *base64=[[[NSString alloc]initWithData:[GTMBase64 encodeData:dataqq] encoding:NSUTF8StringEncoding] autorelease];
    
    int ftime=[[NSDate date]timeIntervalSince1970];

    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:@"img",@"lettertype",base64,@"fbody",[NSNumber numberWithInt:ftime],@"ftime",[NSNumber numberWithInt:[base64 length]],@"fsize",@"jpg",@"fext", nil];
    [[EKRequest Instance]EKHTTPRequest:LetterF parameters:dic requestMethod:POST forDelegate:self];
    
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
    

}

//- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
//    // 创建一个bitmap的context
//    // 并把它设置成为当前正在使用的context
//    UIGraphicsBeginImageContext(size);
//    // 绘制改变大小的图片
//    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
//    // 从当前context中创建一个改变大小后的图片
//    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
//    // 使当前的context出堆栈
//    UIGraphicsEndImageContext();
//    // 返回新的改变大小后的图片
//    return scaledImage;
//}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}
-(void)getEKResponse:(id)response forMethod:(RequestFunction)method parm:(NSDictionary *)parm resultCode:(int)code
{
    NSLog(@"%d",code);
    NSString *str=[[[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding] autorelease];
    NSLog(@"%@",str);
       [_slimeView endRefresh];
//    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"code %d",code] message:str delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//    [alert show];
//    [alert release];
//    
//    return;
    
    if(method==LetterF && code==1)
    {
 
        NSArray *parmArr= [parm allKeys];
        if([parmArr containsObject:@"starttime"] || [parmArr containsObject:@"endtime"])
        {
           if([[parm objectForKey:@"starttime"] isEqualToString:@"0"] && [[parm objectForKey:@"endtime"] isEqualToString:@"0"])
           {
               [dataArr removeAllObjects];
           }
            NSArray *arr= [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
            NSLog(@"%@",arr);
            for (int i=0; i<[arr count]; i++) {
                NSLog(@"dfdsfdsf");
                    
                Letter *letter=[[Letter alloc]init];
                letter.letterID=[NSString stringWithFormat:@"%@",[[arr objectAtIndex:i] objectForKey:@"letterid"]];
                letter.letterContent=[NSString stringWithFormat:@"%@",[[arr objectAtIndex:i] objectForKey:@"content"]];
                letter.letterTime=[NSString stringWithFormat:@"%@",[[arr objectAtIndex:i] objectForKey:@"addtime"]];;
                
                letter.letterFromRole=[NSString stringWithFormat:@"%@",[[arr objectAtIndex:i] objectForKey:@"from_role"]];
                letter.letterLetterType=[NSString stringWithFormat:@"%@",[[arr objectAtIndex:i] objectForKey:@"letter_type"]];
                NSLog(@"%@",letter.letterFromRole);
                
               // if()
                
                NSDate *date=[NSDate dateWithTimeIntervalSince1970:[letter.letterTime integerValue]];
                NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
                [formatter setDateFormat:@"yyyy-MM-dd"];
                NSString *dateStr=[formatter stringFromDate:date];
                [formatter release];
               // labeTime.text=st;
                
               // NSString *dateStr= [[NSDate dateWithTimeIntervalSince1970: [letter.letterTime integerValue]].description substringToIndex:10];;
                //NSLog(@"%@",dateStr);
                
                
                BOOL found=NO;
                for (int j=0; j<[dataArr count]; j++) {
                    GKLetterData *data=[dataArr objectAtIndex:j];
                    
                    if([data.dateKey isEqualToString:dateStr])
                    {
                        found=YES;
                        [data.letterArr addObject:letter];
                        
                        break;
                    }
                    else
                    {
                        found=NO;
                    }
                    
                    
                }
                
                if(found==YES)
                {
                    
                }
                else
                {
                    GKLetterData *data=[[GKLetterData alloc]init];
                    data.dateKey=dateStr;
                    [data.letterArr addObject:letter];
                    [dataArr addObject:data];
                    [data release];
                    
                }
                
                
               // [dataArr addObject:letter];
                [letter release];
                
            }
            
            
            
            if([[parm objectForKey:@"starttime"] isEqualToString:@"0"] && [[parm objectForKey:@"endtime"] isEqualToString:@"0"])
            {
                [self sortArr:YES];
            }
            else
            {
                 [self sortArr:NO];
            }
            
           
            
        }
        else
        {
            inputField.text=@"";
            if([dataArr count]>0)
            {
               // Letter *letter=[dataArr objectAtIndex:0];
                
                NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:@"0",@"starttime",@"0",@"endtime", nil];
                [[EKRequest Instance]EKHTTPRequest:LetterF parameters:dic requestMethod:GET forDelegate:self];
            }
           
        }
     
 
        
    }
}
-(void)sortArr:(BOOL)isbool
{


    
    NSSortDescriptor *desc=[[NSSortDescriptor alloc]initWithKey:@"dateKey" ascending:YES];
    NSArray *arr=[NSArray arrayWithObjects:desc, nil];
    [desc release];
    
    [dataArr sortUsingDescriptors:arr];
    
    
    for (int i=0; i<[dataArr count]; i++) {
        GKLetterData *data=[dataArr objectAtIndex:i];
        
        
        NSSortDescriptor *desc11=[[NSSortDescriptor alloc]initWithKey:@"letterTime" ascending:YES];
        NSArray *arr11=[NSArray arrayWithObjects:desc11, nil];
        [desc11 release];
        [data.letterArr sortUsingDescriptors:arr11];
    }
    
    [_tableView reloadData];
    if(isbool)
    {
        if([dataArr count]>0)
        {
            GKLetterData *data=[dataArr objectAtIndex:[dataArr count]-1];
            [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[data.letterArr count] inSection:[dataArr count]-1] atScrollPosition:0 animated:NO];
        }

    }

 
}
-(void)getErrorInfo:(NSError *)error forMethod:(RequestFunction)method
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"alert", @"") message:NSLocalizedString(@"network", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
      [_slimeView endRefresh];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [dataArr count];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    GKLetterData *data=[dataArr objectAtIndex:section];
    return [data.letterArr count]+1 ;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.row==0)
    {
        static NSString *cell0=@"cel0l";
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cell0];
        if(cell==nil)
        {
            cell=[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell0] autorelease];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            
            UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 10, 320, 1)];
            imageView.image=IMAGENAME(IMAGEWITHPATH(@"letterLine"));
            [cell addSubview:imageView];
            [imageView release];
            
            UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(135, 0, 120, 20)];
            label.backgroundColor=[UIColor clearColor];
            label.font=[UIFont systemFontOfSize:10];
            [cell addSubview:label];
            label.tag=1000;
            [label release];
            
         
        }
        UILabel *label=(UILabel *)[cell viewWithTag:1000];
        
        GKLetterData *data=[dataArr objectAtIndex:indexPath.section];
        label.text=data.dateKey;
        
        return cell;

    }
 
    static NSString *cellIdentifier=@"cell";
    GKLetterCell *cell=(GKLetterCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell==nil)
    {
        cell=[[[GKLetterCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.delegate=self;
    }
    
    GKLetterData *data=[dataArr objectAtIndex:indexPath.section];
    cell.letter=[data.letterArr objectAtIndex:indexPath.row-1];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  //  return 100;
    if(indexPath.row==0)
    {
        return 20;
    }
    GKLetterData *data=[dataArr objectAtIndex:indexPath.section];
    Letter *letter=[data.letterArr objectAtIndex:indexPath.row -1 ];

  
        // 左气泡
        
        //CGRectMake(35, 20, 60, 20);
     
        CGSize size=[letter.letterContent sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(250, 1000) lineBreakMode:NSLineBreakByWordWrapping];
    
    
        if([letter.letterLetterType isEqualToString:@"txt"])
        {
            return 20+ size.height+10 ;
        }
        else
        {
            return 120;
        }

        
    
    


    return 0;
}


-(void)clickImageViewLookImage:(NSString *)path
{
    GKShowBigImageViewController *show=[[GKShowBigImageViewController alloc]init];
    show.path=path;
    [self.navigationController presentViewController:show animated:YES completion:^{
        
    }];
    [show release];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    if (self._slimeView) {
        [self._slimeView scrollViewDidScroll];
    }
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (self._slimeView) {
        [self._slimeView scrollViewDidEndDraging];
    }
    
    
}
- (void)slimeRefreshStartRefresh:(SRRefreshView *)refreshView
{
    NSLog(@"start refresh");
    
    if([dataArr count]>0)
    {
        GKLetterData *data=[dataArr objectAtIndex:0];
        NSString *time=[[data.letterArr objectAtIndex:0] letterTime];
        NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:time,@"starttime",@"0",@"endtime", nil];
        [[EKRequest Instance]EKHTTPRequest:LetterF parameters:dic requestMethod:GET forDelegate:self];

    }
    else
    {
        NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:@"0",@"starttime",@"0",@"endtime", nil];
        [[EKRequest Instance]EKHTTPRequest:LetterF parameters:dic requestMethod:GET forDelegate:self];

    }

}
-(void)dealloc
{
    self._tableView=nil;
    self.dataArr=nil;
    self._slimeView= nil;
    [super dealloc];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
