//
//  CBLoginViewController.m
//  CloudBusParent
//
//  Created by HELLO  on 15/11/5.
//  Copyright (c) 2015年 BeiJingYinChuang. All rights reserved.
//

#import "CBLoginViewController.h"
#import "Masonry.h"
#import "EKRequest.h"
#import "CBDateBase.h"
#import "CBLoginInfo.h"


@interface CBLoginViewController ()<EKProtocol>

@end

@implementation CBLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    

    
    UIImageView * bgImageView = [[UIImageView alloc]init];
    bgImageView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:bgImageView];
    
    UIImageView * iconImageView = [[UIImageView alloc]init];
    iconImageView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:iconImageView];
    
    UILabel * label = [[UILabel alloc]init];
    label.text = @"云中校车";
    [self.view addSubview:label];
    
    
    UIView * phoneView = [[UIView alloc]init];
    phoneView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:phoneView];
   // 家长 13700000005 验证码 1111
    _usernameField = [[UITextField alloc]init];
    _usernameField.borderStyle = UITextBorderStyleNone;
    _usernameField.placeholder = @"输入手机号";
    //_usernameField.text  = @"13700000001";
    _usernameField.text = @"13700000005";
    [self.view addSubview:_usernameField];
    
    UIButton * codeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [codeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [codeButton addTarget:self action:@selector(codeClick:) forControlEvents:UIControlEventTouchUpInside];
    [codeButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.view addSubview:codeButton];

    
    UIView * passwordView = [[UIView alloc]init];
    passwordView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:passwordView];
    
    _passwordField = [[UITextField alloc]init];
    _passwordField.borderStyle = UITextBorderStyleNone;
    _passwordField.placeholder = @"输入验证码";
    _passwordField.text = @"1111";
    [self.view addSubview:_passwordField];
    
    UIButton * registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [registerButton setTitle:@"注册" forState:UIControlStateNormal];
    [registerButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [registerButton addTarget:self action:@selector(registerClick:) forControlEvents:UIControlEventTouchUpInside];
    //[registerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:registerButton];
    
    [bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.mas_top);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(50);
        make.centerX.equalTo(self.view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(100, 100));
    }];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(iconImageView.mas_bottom).offset(20);
    }];
    
    
    [phoneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(20);
        make.right.equalTo(self.view.mas_right).offset(-20);;
        make.height.mas_equalTo(40);
        make.top.equalTo(label.mas_bottom).offset(20);;
    }];
    [_usernameField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(phoneView.mas_left).offset(5);
        make.top.equalTo(phoneView.mas_top);
        make.bottom.equalTo(phoneView.mas_bottom);
        make.right.equalTo(codeButton.mas_left).offset(-10);
    }];
    [codeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(phoneView.mas_right).offset(-5);
        make.top.equalTo(phoneView.mas_top);
        make.bottom.equalTo(phoneView.mas_bottom);
    }];
    [passwordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(20);
        make.right.equalTo(self.view.mas_right).offset(-20);;
        make.height.mas_equalTo(40);
        make.top.equalTo(phoneView.mas_bottom).offset(10);;
    }];
    [_passwordField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(passwordView.mas_left).offset(5);
        make.top.equalTo(passwordView.mas_top);
        make.bottom.equalTo(passwordView.mas_bottom);
        make.right.equalTo(passwordView.mas_right).offset(-5);
    }];

    [registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(20);
        make.right.equalTo(self.view.mas_right).offset(-20);;
        make.height.mas_equalTo(30);
        make.top.equalTo(passwordView.mas_bottom).offset(10);;

    }];
}

-(void)registerClick:(id)sender
{
    if([_usernameField.text isEqualToString:@""])
    {
        return;
    }
    NSDictionary * dic = @{@"mobile":_usernameField.text,@"verifycode":_passwordField.text};
    [[EKRequest Instance] EKHTTPRequest:verify parameters:dic requestMethod:POST forDelegate:self];
}
-(void)codeClick:(id)sender
{
    //13700000005
    NSDictionary * dic = @{@"mobile":_usernameField.text};
    [[EKRequest Instance] EKHTTPRequest:REGISTER parameters:dic requestMethod:GET forDelegate:self];
}

-(void)getSid:(NSDictionary *)parm
{
    [[EKRequest Instance] EKHTTPRequest:login parameters:parm requestMethod:POST forDelegate:self];
}
-(void)getBaseInfo
{
//    [[CBDateBase sharedDatabase] selectFormTableBaseinfo];
}
-(void) getEKResponse:(id) response forMethod:(RequestFunction) method resultCode:(int) code withParam:(NSDictionary *)param
{


}
-(void) getErrorInfo:(NSError *) error forMethod:(RequestFunction) method
{
    
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
