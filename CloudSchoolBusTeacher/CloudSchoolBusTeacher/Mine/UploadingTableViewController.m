//
//  UploadingTableViewController.m
//  CloudSchoolBusTeacher
//
//  Created by macbook on 15/12/16.
//  Copyright © 2015年 BeiJingYinChuang. All rights reserved.
//

#import "UploadingTableViewController.h"
#import "UploadingTableViewCell.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "UploadRecord.h"
#import "CBDateBase.h"

@interface UploadingTableViewController ()
{
    NSMutableArray   *uploadArticles;
}

-(void)updateUploadQ;

@end

@implementation UploadingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Title
    self.navigationItem.title = @"正在上传";

    
    //Read the uploading Queue as the Datasource
    uploadArticles = [[NSMutableArray alloc]init];
    [self updateUploadQ];
    
    if(uploadArticles.count == 0)
        _uploadingStatus.text = [NSString stringWithFormat:@"所有文件都已上传"];
    else
        _uploadingStatus.text = [NSString stringWithFormat:@"有%lu个帖子正在上传",(unsigned long)uploadArticles.count];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"UploadingTableViewCell" bundle:nil] forCellReuseIdentifier:@"uploadcell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.fd_debugLogEnabled = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uploadSuccess:) name:@"uploadSuccess" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [uploadArticles count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UploadingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"uploadcell" forIndexPath:indexPath];
    
    // Configure the cell with content for the given indexPath
    [cell setUploadingRecords:uploadArticles[indexPath.row]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *recordArr = [uploadArticles objectAtIndex:indexPath.row];
    if(recordArr==0)
        return 0;
    UploadRecord *uploadRecord = recordArr[0];
    NSString *cacheKey = uploadRecord.pickey;
    
    return [tableView fd_heightForCellWithIdentifier:@"uploadcell" cacheByKey:cacheKey configuration:^(UploadingTableViewCell * cell)
            {
                //Ｃｅｌｌ中包含ＣｏｌｌｅｃｔｉｏｎＶｉｅｗ，自动布局计算ＣｏｌｌｅｃｔｉｏｎＶｉｅｗ失效
                cell.fd_enforceFrameLayout = YES;
                [cell setUploadingRecords:recordArr];
            }];
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


#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
//    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
//    [self.navigationController pushViewController:detailViewController animated:YES];
 }

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)updateUploadQ
{
    [uploadArticles removeAllObjects];

    [[CBDateBase sharedDatabase] readUploadQueue:^(NSMutableArray *recordList) {
        
        if(recordList.count == 0)
        {
            return;
        }
        
        //初始化key和Object
        NSString *pickey= ((UploadRecord *)recordList[0]).pickey;
        NSMutableArray *picArrOfArticle = [[NSMutableArray alloc]init];
    

        //开始遍历数组
        for(int i=0; i<recordList.count; i++)
        {
            UploadRecord *record = recordList[i];
            [picArrOfArticle addObject:record];
            
            //如果发现pickey变化或者遍历结束，就增加字典的一条记录
            if((![record.pickey isEqualToString:pickey]) || (i==recordList.count-1))
            {
                [uploadArticles addObject:picArrOfArticle];
            
                //更新key
                pickey = record.pickey;
                
                //更新key对应的Object
                picArrOfArticle = [[NSMutableArray alloc]init];
            }
        }
    }];
}

-(void)uploadSuccess:(NSNotification *)notification
{
    [self updateUploadQ];
    
    [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
    
    if(uploadArticles.count == 0)
        _uploadingStatus.text = [NSString stringWithFormat:@"所有文件都已上传"];
    else
        _uploadingStatus.text = [NSString stringWithFormat:@"有%lu个文件正在上传",(unsigned long)uploadArticles.count];
}
@end
