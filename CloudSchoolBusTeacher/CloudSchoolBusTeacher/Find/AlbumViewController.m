//
//  AlbumViewController.m
//  CloudSchoolBusTeacher
//
//  Created by HELLO  on 15/12/14.
//  Copyright © 2015年 BeiJingYinChuang. All rights reserved.
//

#import "AlbumViewController.h"
#import "AlbumViewCell.h"
#import "PhotoViewController.h"
@interface AlbumViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    ALAssetsLibrary * _assetsLibrary;
    UITableView * _tableView;
}
@end

@implementation AlbumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //Cameral Button
    UIButton * nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextButton setBackgroundImage:[UIImage imageNamed:@"ic_list_white"] forState:UIControlStateNormal];
    nextButton.frame = CGRectMake(0, 0, 30, 30);
    [nextButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [nextButton addTarget:self action:@selector(camButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * nextItem = [[UIBarButtonItem alloc]initWithCustomView:nextButton];
    self.navigationItem.rightBarButtonItem = nextItem;
    
    _listArr = [[NSMutableArray alloc]init];
    // Do any additional setup after loading the view.
    _assetsLibrary = [[ALAssetsLibrary alloc]init];
    
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    [_tableView registerClass:[AlbumViewCell class] forCellReuseIdentifier:@"cell"];
    
    [_assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if(group)
        {
            [_listArr addObject:group];
        }
        else
        {
            [_tableView reloadData];
        }
    } failureBlock:^(NSError *error) {
        
    }];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _listArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AlbumViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    ALAssetsGroup * grop = _listArr[indexPath.row];
    cell.photoImageView.image = [UIImage imageWithCGImage:grop.posterImage];
    cell.albumNameLabel.text = [grop valueForProperty:ALAssetsGroupPropertyName];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     ALAssetsGroup * grop = _listArr[indexPath.row];
    PhotoViewController * photoVC = [[PhotoViewController alloc]init];
    photoVC.grop = grop;
    [self.navigationController pushViewController:photoVC animated:YES];
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

#pragma mark
#pragma mark == User Action
-(void)nextButton:(id)sender
{
    
}

@end
