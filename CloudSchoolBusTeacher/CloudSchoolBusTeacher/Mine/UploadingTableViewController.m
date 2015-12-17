//
//  UploadingTableViewController.m
//  CloudSchoolBusTeacher
//
//  Created by macbook on 15/12/16.
//  Copyright © 2015年 BeiJingYinChuang. All rights reserved.
//

#import "UploadingTableViewController.h"
#import "UploadingTableViewCell.h"
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
    
    uploadArticles = [[NSMutableArray alloc]init];

    [self updateUploadQ];
    
    //Read the uploading Queue as the Datasource
    
    [self.tableView registerNib:[UINib nibWithNibName:@"UploadingTableViewCell" bundle:nil] forCellReuseIdentifier:@"uploadcell"];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    [cell setUploadingRecords:uploadArticles[indexPath.row]];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200;
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
@end
