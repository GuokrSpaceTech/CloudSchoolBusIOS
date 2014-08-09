//
//  ETCoreDataManager.m
//  etonkids-iphone
//
//  Created by CaiJingPeng on 13-9-12.
//  Copyright (c) 2013年 wpf. All rights reserved.
//

#import "ETCoreDataManager.h"

#import "ETEvents.h"
#import "ETActicalTag.h"
#import "ETNoticPicture.h"


@implementation ETCoreDataManager


+ (void)saveUser
{
    UserLogin* login = [UserLogin currentLogin];
    
//    if (login.loginStatus == LOGIN_OFF)
//        return;
    
    AppDelegate *delegate = SHARED_APP_DELEGATE;
    
    
    NSLog(@"%@---%@",login.uid_class,login.uid_student);
    
    NSFetchRequest* request = [[[NSFetchRequest alloc] init] autorelease];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ETUser" inManagedObjectContext:delegate.managedObjectContext];
    NSPredicate* pred = [NSPredicate predicateWithFormat:@"(account = %@ and uid_student = %@ and uid_class = %@)", login.regName, login.uid_student, login.uid_class];
    [request setEntity:entity];
    [request setPredicate:pred];
    
    NSError* error;
    NSArray* users = [delegate.managedObjectContext executeFetchRequest:request error:&error];
    for (int i=0 ;i<users.count; i++) {
    
         ETUser *test = (ETUser *)[users objectAtIndex:i];
        NSLog(@"%@",test.nikename);
        
    }
    ETUser *user;
    if (users == nil)
    {
        NSLog(@"Can't fetch user from core data: %@", error);
    }
    
    if (users == nil || [users count] == 0)
    {
        user = [NSEntityDescription insertNewObjectForEntityForName:@"ETUser"inManagedObjectContext:delegate.managedObjectContext];
    }
    else
        user = (ETUser *)[users objectAtIndex:0];
    
    if (user != nil)
    {
        user.account = login.regName;
        user.password = login.passWord;
        user.age = login.age;
        user.birthday = login.birthday;
        user.sex = login.sex;
        user.classname = login.className;
        user.mobile = login.mobile;
        user.cnname = login.cnname;
        user.enname = login.enname;
        user.avatar = login.avatar;
        user.nikename = login.nickname;
        user.studentid = login.studentId;
        user.allowmutionline = login.allowmutionline;
        user.schoolname = login.schoolname;
        user.pid = login.pid;
        user.uid_class = login.uid_class;
        user.uid_student = login.uid_student;
        user.ischeck_mobile = login.ischeck_mobile;
        user.skinid = login.skinid;
        user.username = login.username;
        user.can_comment = login.can_comment;
        user.can_comment_action = login.can_comment_action;
        user.orderenddate = login.orderEndTime;
        user.ordertitle = login.orderTitle;
        user.healthstate=login.healtState;
        user.tuition_time=login.tuition_time;
        BOOL success = [delegate.managedObjectContext save:&error];
        NSLog(@"user save success: %d",success);
    }
}

+ (UserLogin*)cachedUser:(NSString*)userName withPass:(NSString*)password andStudent:(NSString *)stuid
{
    [UserLogin releaseCurrentUser];
    
    AppDelegate* delegate = SHARED_APP_DELEGATE;
    
    NSFetchRequest* request = [[[NSFetchRequest alloc] init] autorelease];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ETUser" inManagedObjectContext:delegate.managedObjectContext];
    NSPredicate* pred = [NSPredicate predicateWithFormat:@"(account = %@ and uid_student = %@)", userName,stuid];
    [request setEntity:entity];
    [request setPredicate:pred];
    
    NSError* error;
    NSArray* users = [delegate.managedObjectContext executeFetchRequest:request error:&error];
    
    if (users == nil || [users count] == 0)
    {
        return nil;
    }
    
    ETUser* user = [users objectAtIndex:0];
    NSLog(@"%@",user.account);
    NSLog(@"%@",user.classname);
    NSLog(@"%@",user.healthstate);
    NSLog(@"%@",user.cnname);
    
    NSLog(@"%@",user.password);
    if ([password compare:user.password] != NSOrderedSame)
    {
        return nil;
    }
    
    UserLogin* login = [UserLogin currentLogin];
    if (login == nil)
    {
        return nil;
    }
    
    login.regName = user.account;
    login.passWord = user.password;
    login.age = user.age;
    login.birthday = user.birthday;
    login.sex = user.sex;
    login.className = user.classname;
    login.mobile = user.mobile;
    login.cnname = user.cnname;
    login.enname = user.enname;
    login.avatar = user.avatar;
    login.nickname = user.nikename;
    login.studentId = user.studentid;
    login.allowmutionline = user.allowmutionline;
    login.schoolname = user.schoolname;
    login.pid = user.pid;
    login.uid_student = user.uid_student;
    login.uid_class = user.uid_class;
    login.ischeck_mobile = user.ischeck_mobile;
    login.skinid = user.skinid;
    login.username = user.username;
    login.can_comment_action = user.can_comment_action;
    login.can_comment = user.can_comment;
    login.orderTitle = user.ordertitle;
    login.healtState=user.healthstate;
    login.orderEndTime = user.orderenddate;
    login.tuition_time=user.tuition_time;
    return login;
}
+ (void)updateUserInfo:(NSDictionary *)userInfo{
    //    MHUserLogin* login = [MHUserLogin currentLogin];
    
    AppDelegate* delegate = SHARED_APP_DELEGATE;
    NSFetchRequest* request = [[[NSFetchRequest alloc] init] autorelease];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ETUser" inManagedObjectContext:delegate.managedObjectContext];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"password = %@",[userInfo objectForKey:@"password"]];
    [request setPredicate:predicate];
    [request setEntity:entity];
    NSArray *userArr = [delegate.managedObjectContext executeFetchRequest:request error:nil];
    if (userArr) {
        //        [delegate.managedObjectContext deleteObject:user.lastObject];
        
//        ETUser *user = userArr.lastObject;
//        user.name = [userInfo objectForKey:@"name"];
//        user.gender = [NSNumber numberWithInt:[[userInfo objectForKey:@"gender"] intValue]];
//        user.birthday = [userInfo objectForKey:@"birthday"];
//        user.city = [userInfo objectForKey:@"city"];
//        user.mobile = [userInfo objectForKey:@"mobile"];
//        user.email = [userInfo objectForKey:@"email"];
//        BOOL success = [self saveContext];
//        NSLog(@"save userinfo success : %d",success);
    }
    
}


+ (ETUser *)getUserInfo:(NSString *)account andStudent:(NSString *)stuid{
    AppDelegate* delegate = SHARED_APP_DELEGATE;
    NSFetchRequest* request = [[[NSFetchRequest alloc] init] autorelease];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ETUser" inManagedObjectContext:delegate.managedObjectContext];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"account = %@ and uid_student = %@",account,stuid];
    [request setPredicate:predicate];
    [request setEntity:entity];
    NSArray *userArr = [delegate.managedObjectContext executeFetchRequest:request error:nil];
    return userArr.lastObject;
}


+ (NSArray *)getUsers:(NSString *)userName
{
    AppDelegate* delegate = SHARED_APP_DELEGATE;
    NSFetchRequest* request = [[[NSFetchRequest alloc] init] autorelease];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ETUser" inManagedObjectContext:delegate.managedObjectContext];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"account = %@",userName];
    [request setPredicate:predicate];
    [request setEntity:entity];
    NSArray *userArr = [delegate.managedObjectContext executeFetchRequest:request error:nil];
    return userArr;
}

+ (BOOL)saveUserChildren:(NSArray *)children ByAccount:(NSString *)username
{
    AppDelegate *delegate = SHARED_APP_DELEGATE;
    NSError* error;
    UserLogin *userLogin=[UserLogin currentLogin];
    for (int i = 0; i < children.count; i++) {
        NSDictionary *dic = [children objectAtIndex:i];
        NSString *stuid = [dic objectForKey:@"uid_student"];
        NSString *cid = [dic objectForKey:@"uid_class"];
        
        NSFetchRequest* request = [[[NSFetchRequest alloc] init] autorelease];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"ETUser" inManagedObjectContext:delegate.managedObjectContext];
        NSPredicate* pred = [NSPredicate predicateWithFormat:@"(account = %@ and uid_student = %@ and uid_class = %@)", username, stuid, cid];
        [request setEntity:entity];
        [request setPredicate:pred];
        
        NSArray* users = [delegate.managedObjectContext executeFetchRequest:request error:&error];
        
        ETUser *user;
        if (users == nil)
        {
            NSLog(@"Can't fetch user from core data: %@", error);
        }
        
        if (users == nil || [users count] == 0)
        {
            user = [NSEntityDescription insertNewObjectForEntityForName:@"ETUser"inManagedObjectContext:delegate.managedObjectContext];
        }
        else
            user = (ETUser *)[users objectAtIndex:0];
        
        if (user != nil)
        {
            user.account = username;
            user.password = userLogin.passWord;
//            user.age = login.age;
//            user.birthday = login.birthday;
//            user.sex = login.sex;
            user.classname = [NSString stringWithFormat:@"%@",[dic objectForKey:@"classname"]];
//            user.mobile = login.mobile;
            user.cnname = [NSString stringWithFormat:@"%@",[dic objectForKey:@"cnname"]];
//            user.enname = login.enname;
//            user.avatar = login.avatar;
            user.nikename = [NSString stringWithFormat:@"%@",[dic objectForKey:@"nikename"]];
//            user.studentid = login.studentId;
//            user.allowmutionline = login.allowmutionline;
//            user.schoolname = login.schoolname;
//            user.pid = login.pid;
            user.uid_class = [NSString stringWithFormat:@"%@",[dic objectForKey:@"uid_class"]];
            user.uid_student = [NSString stringWithFormat:@"%@",[dic objectForKey:@"uid_student"]];
            user.inactive=[NSString stringWithFormat:@"%@",[dic objectForKey:@"inactive"]];
            
        }
    }
    
    BOOL success = [delegate.managedObjectContext save:&error];
    NSLog(@"user save success: %d",success);
    
    return success;

}


+ (BOOL)saveContext{
    
    NSError *err = nil;
    AppDelegate* delegate = SHARED_APP_DELEGATE;
    BOOL successful = [delegate.managedObjectContext save:&err];
    if (!successful) {
        NSLog(@"Error saving : %@",[err localizedDescription]);
    }
    
    return successful;
    
}


+ (BOOL)removeAllArticalData
{
    NSError *err = nil;
    AppDelegate *delegate = SHARED_APP_DELEGATE;
    NSFetchRequest* request = [[[NSFetchRequest alloc] init] autorelease];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ETClassShare" inManagedObjectContext:delegate.managedObjectContext];
    [request setEntity:entity];
    
    NSArray *articals = [delegate.managedObjectContext executeFetchRequest:request error:&err];
    if (!articals) {
        NSLog(@"!!!! remove articals error : %@",err);
    }
    
    for (ETClassShare *obj in articals) {
        
        NSFetchRequest* request = [[[NSFetchRequest alloc] init] autorelease];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"ETActicalPicture" inManagedObjectContext:delegate.managedObjectContext];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"articalid = %@",obj.articleid];
        [request setPredicate:predicate];
        [request setEntity:entity];
        NSArray *picArr = [delegate.managedObjectContext executeFetchRequest:request error:nil];
        
        for (NSManagedObject *mo in picArr) {
            [delegate.managedObjectContext deleteObject:mo];
        }
        
        
        
        NSFetchRequest* request1 = [[[NSFetchRequest alloc] init] autorelease];
        NSEntityDescription *entity1 = [NSEntityDescription entityForName:@"ETActicalTag" inManagedObjectContext:delegate.managedObjectContext];
        NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"articleid = %@",obj.articleid];
        [request1 setPredicate:predicate1];
        [request1 setEntity:entity1];
        NSArray *tagArr = [delegate.managedObjectContext executeFetchRequest:request1 error:nil];
        
        for (NSManagedObject *mo in tagArr) {
            [delegate.managedObjectContext deleteObject:mo];
        }
        
        [delegate.managedObjectContext deleteObject:obj];
    }
    
    BOOL successful = [self saveContext];
    
    return successful;
    
}


+ (BOOL)addArticalData:(NSArray *)infoArray
{
    for (int i = 0; i < infoArray.count; i++) {
        NSDictionary *infoDic = [infoArray objectAtIndex:i];
//        NSError *err = nil;
        AppDelegate* delegate = SHARED_APP_DELEGATE;
        ETClassShare *classshare = [NSEntityDescription insertNewObjectForEntityForName:@"ETClassShare" inManagedObjectContext:delegate.managedObjectContext];
        classshare.articleid = [NSString stringWithFormat:@"%@",[infoDic objectForKey:@"articleid"]];
        classshare.articlekey = [NSString stringWithFormat:@"%@",[infoDic objectForKey:@"articlekey"]];
        classshare.commentnum = [NSString stringWithFormat:@"%@",[infoDic objectForKey:@"commentnum"]];
        classshare.content = [NSString stringWithFormat:@"%@",[infoDic objectForKey:@"content"]];
        classshare.havezan = [NSString stringWithFormat:@"%@",[infoDic objectForKey:@"havezan"]];
        classshare.publishtime = [NSString stringWithFormat:@"%@",[infoDic objectForKey:@"publishtime"]];
        classshare.title = [NSString stringWithFormat:@"%@",[infoDic objectForKey:@"title"]];
        classshare.upnum = [NSString stringWithFormat:@"%@",[infoDic objectForKey:@"upnum"]];
        
        NSArray *picArr = [infoDic objectForKey:@"plist"];
        
        for (int i = 0; i < picArr.count; i++) {
            
            NSDictionary *picDic = [picArr objectAtIndex:i];
            
//            NSError *err = nil;
            AppDelegate* delegate = SHARED_APP_DELEGATE;
            ETActicalPicture *pic = [NSEntityDescription insertNewObjectForEntityForName:@"ETActicalPicture" inManagedObjectContext:delegate.managedObjectContext];
            pic.articalid = classshare.articleid;
            pic.num = [NSString stringWithFormat:@"%d",i];
            pic.pictureurl = [NSString stringWithFormat:@"%@",[picDic objectForKey:@"source"]];
            
            [classshare addPicturesObject:pic];
        }
        
        
        
        
        NSArray *tagArr=[infoDic objectForKey:@"taglist"];
        for (int i=0; i<tagArr.count; i++) {
            NSDictionary *dic=[tagArr objectAtIndex:i];
            
            ETActicalTag *tag=[NSEntityDescription insertNewObjectForEntityForName:@"ETActicalTag" inManagedObjectContext:delegate.managedObjectContext];
            
            tag.articleid=classshare.articleid;
            tag.tagname=[dic objectForKey:@"tagname"];
            tag.tagname_en=[dic objectForKey:@"tagname_en"];
            tag.tagnamedesc=[dic objectForKey:@"tagnamedesc"];
            tag.tagnamedesc_en=[dic objectForKey:@"tagnamedesc_en"];
            
            [classshare addTagsObject:tag];
        }

    }
    
    BOOL successful = [self saveContext];
    
    return successful;
}

+ (BOOL)removeArticalDataById:(NSString *)articalId
{
    NSError *err = nil;
    AppDelegate *delegate = SHARED_APP_DELEGATE;
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ETClassShare" inManagedObjectContext:delegate.managedObjectContext];
    [request setEntity:entity];
    NSPredicate *searchPre = [NSPredicate predicateWithFormat:@"(articleid = %@)",articalId];
    [request setPredicate:searchPre];
    
    
    NSArray *articals = [delegate.managedObjectContext executeFetchRequest:request error:&err];
    
    if (!articals) {
        NSLog(@"!!!! search articals error : %@",err);
    }
    
    for (ETClassShare *obj in articals) {
        
        NSFetchRequest* request = [[[NSFetchRequest alloc] init] autorelease];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"ETActicalPicture" inManagedObjectContext:delegate.managedObjectContext];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"articalid = %@",obj.articleid];
        [request setPredicate:predicate];
        [request setEntity:entity];
        NSArray *picArr = [delegate.managedObjectContext executeFetchRequest:request error:nil];
        
        for (NSManagedObject *mo in picArr) {
            [delegate.managedObjectContext deleteObject:mo];
        }
        
        [delegate.managedObjectContext deleteObject:obj];
    }
    
    BOOL successful = [self saveContext];
    
    return successful;

}
+ (BOOL)addSingleArticalData:(ShareContent *)share
{
//    NSError *err = nil;
    AppDelegate* delegate = SHARED_APP_DELEGATE;
    ETClassShare *classshare = [NSEntityDescription insertNewObjectForEntityForName:@"ETClassShare" inManagedObjectContext:delegate.managedObjectContext];
    classshare.articleid = share.shareId;
    classshare.articlekey = share.shareKey;
    classshare.commentnum = [NSString stringWithFormat:@"%@",share.commentnum];
    classshare.content = [NSString stringWithFormat:@"%@",share.shareContent];
    classshare.havezan = [NSString stringWithFormat:@"%@",share.havezan];
    classshare.publishtime = [NSString stringWithFormat:@"%@",share.publishtime];
    classshare.title = [NSString stringWithFormat:@"%@",share.shareTitle];
    classshare.upnum = [NSString stringWithFormat:@"%@",share.upnum];
    
    NSArray *picArr = share.sharePicArr;
    
    for (int i = 0; i < picArr.count; i++) {
        
        NSDictionary *picDic = [picArr objectAtIndex:i];
        
//        NSError *err = nil;
        AppDelegate* delegate = SHARED_APP_DELEGATE;
        ETActicalPicture *pic = [NSEntityDescription insertNewObjectForEntityForName:@"ETActicalPicture" inManagedObjectContext:delegate.managedObjectContext];
        pic.articalid = classshare.articleid;
        pic.pictureurl = [NSString stringWithFormat:@"%@",[picDic objectForKey:@"source"]];
        
        [classshare addPicturesObject:pic];
    }
    BOOL successful = [self saveContext];
    
    return successful;

}

+ (BOOL)updateArticalData:(ShareContent *)share ById:(NSString *)articalId
{
    [ETCoreDataManager removeArticalDataById:articalId];
    return [ETCoreDataManager addSingleArticalData:share];
}


+ (NSArray *)searchAllArticals
{
    NSError *err = nil;
    AppDelegate *delegate = SHARED_APP_DELEGATE;
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ETClassShare" inManagedObjectContext:delegate.managedObjectContext];
    [request setEntity:entity];
    NSSortDescriptor *sortDes = [NSSortDescriptor sortDescriptorWithKey:@"publishtime" ascending:NO];
    [request setSortDescriptors:[NSArray arrayWithObject:sortDes]];
    
    
    NSArray *articals = [delegate.managedObjectContext executeFetchRequest:request error:&err];
    
    if (!articals) {
        NSLog(@"!!!! search articals error : %@",err);
    }
    
    NSMutableArray *resultArr = [NSMutableArray array];
    for (int i = 0; i < articals.count; i++) {
        
        ETClassShare *info = [articals objectAtIndex:i];
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:info.articleid forKey:@"articleid"];
        [dic setObject:info.articlekey forKey:@"articlekey"];
        [dic setObject:info.commentnum forKey:@"commentnum"];
        [dic setObject:info.content forKey:@"content"];
        [dic setObject:info.havezan forKey:@"havezan"];
        [dic setObject:info.publishtime forKey:@"publishtime"];
        [dic setObject:info.title forKey:@"title"];
        [dic setObject:info.upnum forKey:@"upnum"];
        
        NSFetchRequest* request = [[[NSFetchRequest alloc] init] autorelease];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"ETActicalPicture" inManagedObjectContext:delegate.managedObjectContext];
        [request setEntity:entity];
        NSPredicate *searchPre = [NSPredicate predicateWithFormat:@"(articalid = %@)",info.articleid];
        [request setPredicate:searchPre];
        NSSortDescriptor *sortDes = [NSSortDescriptor sortDescriptorWithKey:@"num" ascending:YES];
        [request setSortDescriptors:[NSArray arrayWithObject:sortDes]];
        
        NSArray *picArr = [delegate.managedObjectContext executeFetchRequest:request error:&err];
        if (!picArr) {
            NSLog(@"!!!! search pic error : %@",err);
        }
        
        NSMutableArray *tempPic = [NSMutableArray array];
        for (int i = 0; i < picArr.count; i++)
        {
            ETActicalPicture *ap = [picArr objectAtIndex:i];
            NSDictionary *tempDic = [NSDictionary dictionaryWithObjectsAndKeys:ap.pictureurl,@"source", nil];
            [tempPic addObject:tempDic];
        }
        [dic setObject:tempPic forKey:@"plist"];

      //  [resultArr addObject:dic];
        
        
        

        
        NSFetchRequest* request1 = [[[NSFetchRequest alloc] init] autorelease];
        NSEntityDescription *entity1 = [NSEntityDescription entityForName:@"ETActicalTag" inManagedObjectContext:delegate.managedObjectContext];
        [request1 setEntity:entity1];
        NSPredicate *searchPre1 = [NSPredicate predicateWithFormat:@"(articleid = %@)",info.articleid];
        [request1 setPredicate:searchPre1];
        NSError *error1=nil;
        NSArray *tagArr = [delegate.managedObjectContext executeFetchRequest:request1 error:&error1];

        if(!tagArr)
        {
             NSLog(@"!!!! search pic error : %@",error1);
        }
        
        
        NSMutableArray *tempTag = [NSMutableArray array];
        for (int i = 0; i < tagArr.count; i++)
        {
            ETActicalTag *ap = [tagArr objectAtIndex:i];
            NSDictionary *tempDic = [NSDictionary dictionaryWithObjectsAndKeys:ap.tagname,@"tagname",ap.tagname_en,@"tagname_en",ap.tagnamedesc,@"tagnamedesc",ap.tagnamedesc_en,@"tagnamedesc_en", nil];
            [tempTag addObject:tempDic];
        }
        [dic setObject:tempTag forKey:@"taglist"];
        
        [resultArr addObject:dic];

        
        
        
    }
    
    
    
    return resultArr;
    
}


+ (NSArray *)searchAllNotices
{
    NSError *err = nil;
    AppDelegate *delegate = SHARED_APP_DELEGATE;
    NSFetchRequest* request = [[[NSFetchRequest alloc] init] autorelease];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ETNotice" inManagedObjectContext:delegate.managedObjectContext];
    [request setEntity:entity];
    NSSortDescriptor *sortDes = [NSSortDescriptor sortDescriptorWithKey:@"addtime" ascending:NO];
    [request setSortDescriptors:[NSArray arrayWithObject:sortDes]];
    
    NSArray *notices = [delegate.managedObjectContext executeFetchRequest:request error:&err];
    if (!notices) {
        NSLog(@"!!!! remove articals error : %@",err);
    }
    NSMutableArray *resultArr = [NSMutableArray array];
    for (int i = 0; i < notices.count; i++) {
        
        ETNotice *info = [notices objectAtIndex:i];
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:info.addtime forKey:@"addtime"];
        [dic setObject:info.haveisconfirm forKey:@"haveisconfirm"];
        [dic setObject:info.isconfirm forKey:@"isconfirm"];
        [dic setObject:info.isteacher forKey:@"isteacher"];
        [dic setObject:info.noticecontent forKey:@"noticecontent"];
        [dic setObject:info.noticeid forKey:@"noticeid"];
        [dic setObject:info.noticekey forKey:@"noticekey"];
        [dic setObject:info.noticetitle forKey:@"noticetitle"];
        
        NSFetchRequest* request = [[[NSFetchRequest alloc] init] autorelease];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"ETNoticPicture" inManagedObjectContext:delegate.managedObjectContext];
        [request setEntity:entity];
        NSPredicate *searchPre = [NSPredicate predicateWithFormat:@"(noticeid = %@)",info.noticeid];
        [request setPredicate:searchPre];
        NSSortDescriptor *sortDes = [NSSortDescriptor sortDescriptorWithKey:@"num" ascending:YES];
        [request setSortDescriptors:[NSArray arrayWithObject:sortDes]];
        
        NSArray *picArr = [delegate.managedObjectContext executeFetchRequest:request error:&err];
        if (!picArr) {
            NSLog(@"!!!! search pic error : %@",err);
        }
        
        NSMutableArray *tempPic = [NSMutableArray array];
        for (int i = 0; i < picArr.count; i++)
        {
            ETNoticPicture *ap = [picArr objectAtIndex:i];
            NSDictionary *tempDic = [NSDictionary dictionaryWithObjectsAndKeys:ap.pictureurl,@"source", nil];
            [tempPic addObject:tempDic];
        }
        [dic setObject:tempPic forKey:@"plist"];
        
        [resultArr addObject:dic];
    }
    
    
    return resultArr;
}
+ (BOOL)removeAllNotices
{
    NSError *err = nil;
    AppDelegate *delegate = SHARED_APP_DELEGATE;
    NSFetchRequest* request = [[[NSFetchRequest alloc] init] autorelease];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ETNotice" inManagedObjectContext:delegate.managedObjectContext];
    [request setEntity:entity];
    
    NSArray *notices = [delegate.managedObjectContext executeFetchRequest:request error:&err];
    if (!notices) {
        NSLog(@"!!!! remove articals error : %@",err);
    }
    
    for (ETNotice *obj in notices) {
        
        NSFetchRequest* request = [[[NSFetchRequest alloc] init] autorelease];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"ETNoticPicture" inManagedObjectContext:delegate.managedObjectContext];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"noticeid = %@",obj.noticeid];
        [request setPredicate:predicate];
        [request setEntity:entity];
        NSArray *picArr = [delegate.managedObjectContext executeFetchRequest:request error:nil];
        
        for (NSManagedObject *mo in picArr) {
            [delegate.managedObjectContext deleteObject:mo];
        }
        
        [delegate.managedObjectContext deleteObject:obj];
    }

    
    BOOL successful = [self saveContext];
    
    return successful;
}
+ (BOOL)addNoticeData:(NSArray *)noticeArray
{
    for (int i = 0; i < noticeArray.count; i++) {
        NSDictionary *infoDic = [noticeArray objectAtIndex:i];
//        NSError *err = nil;
        AppDelegate* delegate = SHARED_APP_DELEGATE;
        ETNotice *notice = [NSEntityDescription insertNewObjectForEntityForName:@"ETNotice" inManagedObjectContext:delegate.managedObjectContext];
        notice.addtime = [NSString stringWithFormat:@"%@",[infoDic objectForKey:@"addtime"]];
        notice.haveisconfirm = [NSString stringWithFormat:@"%@",[infoDic objectForKey:@"haveisconfirm"]];
        notice.isconfirm = [NSString stringWithFormat:@"%@",[infoDic objectForKey:@"isconfirm"]];
        notice.isteacher = [NSString stringWithFormat:@"%@",[infoDic objectForKey:@"isteacher"]];
        notice.noticecontent = [NSString stringWithFormat:@"%@",[infoDic objectForKey:@"noticecontent"]];
        notice.noticeid = [NSString stringWithFormat:@"%@",[infoDic objectForKey:@"noticeid"]];
        notice.noticekey = [NSString stringWithFormat:@"%@",[infoDic objectForKey:@"noticekey"]];
        notice.noticetitle = [NSString stringWithFormat:@"%@",[infoDic objectForKey:@"noticetitle"]];
        NSArray *picArr = [infoDic objectForKey:@"plist"];
        
        for (int i = 0; i < picArr.count; i++) {
            
            NSDictionary *picDic = [picArr objectAtIndex:i];
            
//            NSError *err = nil;
            AppDelegate* delegate = SHARED_APP_DELEGATE;
            ETNoticPicture *pic = [NSEntityDescription insertNewObjectForEntityForName:@"ETNoticPicture" inManagedObjectContext:delegate.managedObjectContext];
            pic.noticeid = notice.noticeid;
            pic.pictureurl = [NSString stringWithFormat:@"%@",[picDic objectForKey:@"source"]];
            pic.num = [NSString stringWithFormat:@"%d",i];
            
            [notice addPicturesObject:pic];
        }
        
    }
    
    BOOL successful = [self saveContext];
    
    return successful;
}


+ (BOOL)updateNoticeData:(NSString *)isconfirm ById:(NSString *)noticeid
{
    NSError *err = nil;
    AppDelegate *delegate = SHARED_APP_DELEGATE;
    NSFetchRequest* request = [[[NSFetchRequest alloc] init] autorelease];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ETNotice" inManagedObjectContext:delegate.managedObjectContext];
    [request setEntity:entity];
    NSPredicate *searchPre = [NSPredicate predicateWithFormat:@"(noticeid = %@)",noticeid];
    [request setPredicate:searchPre];
    
    NSArray *notices = [delegate.managedObjectContext executeFetchRequest:request error:&err];
    if (!notices) {
        NSLog(@"!!!! remove articals error : %@",err);
    }
    
    ETNotice *n = [notices objectAtIndex:0];
    n.haveisconfirm = isconfirm;
    
    BOOL successful = [self saveContext];
    return successful;
    
}


+ (NSArray *)searchImportantNotices
{
    NSError *err = nil;
    AppDelegate *delegate = SHARED_APP_DELEGATE;
    NSFetchRequest* request = [[[NSFetchRequest alloc] init] autorelease];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ETImportantNotice" inManagedObjectContext:delegate.managedObjectContext];
    [request setEntity:entity];
    NSSortDescriptor *sortDes = [NSSortDescriptor sortDescriptorWithKey:@"addtime" ascending:NO];
    [request setSortDescriptors:[NSArray arrayWithObject:sortDes]];
    
    NSArray *notices = [delegate.managedObjectContext executeFetchRequest:request error:&err];
    if (!notices) {
        NSLog(@"!!!! remove articals error : %@",err);
    }
    NSMutableArray *resultArr = [NSMutableArray array];
    for (int i = 0; i < notices.count; i++) {
        
        ETImportantNotice *info = [notices objectAtIndex:i];
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:info.addtime forKey:@"addtime"];
        [dic setObject:info.haveisconfirm forKey:@"haveisconfirm"];
        [dic setObject:info.isconfirm forKey:@"isconfirm"];
        [dic setObject:info.isteacher forKey:@"isteacher"];
        [dic setObject:info.noticecontent forKey:@"noticecontent"];
        [dic setObject:info.noticeid forKey:@"noticeid"];
        [dic setObject:info.noticekey forKey:@"noticekey"];
        [dic setObject:info.noticetitle forKey:@"noticetitle"];
        
        NSFetchRequest* request = [[[NSFetchRequest alloc] init] autorelease];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"ETNoticPicture" inManagedObjectContext:delegate.managedObjectContext];
        [request setEntity:entity];
        NSPredicate *searchPre = [NSPredicate predicateWithFormat:@"(noticeid = %@)",info.noticeid];
        [request setPredicate:searchPre];
        
        NSArray *picArr = [delegate.managedObjectContext executeFetchRequest:request error:&err];
        if (!picArr) {
            NSLog(@"!!!! search pic error : %@",err);
        }
        
        NSMutableArray *tempPic = [NSMutableArray array];
        for (int i = 0; i < picArr.count; i++)
        {
            ETNoticPicture *ap = [picArr objectAtIndex:i];
            NSDictionary *tempDic = [NSDictionary dictionaryWithObjectsAndKeys:ap.pictureurl,@"source", nil];
            [tempPic addObject:tempDic];
        }
        [dic setObject:tempPic forKey:@"plist"];
        
        [resultArr addObject:dic];
    }
    
    
    return resultArr;
}
+ (BOOL)removeAllImportantNotices
{
    NSError *err = nil;
    AppDelegate *delegate = SHARED_APP_DELEGATE;
    NSFetchRequest* request = [[[NSFetchRequest alloc] init] autorelease];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ETImportantNotice" inManagedObjectContext:delegate.managedObjectContext];
    [request setEntity:entity];
    
    NSArray *notices = [delegate.managedObjectContext executeFetchRequest:request error:&err];
    if (!notices) {
        NSLog(@"!!!! remove articals error : %@",err);
    }
    
    for (ETImportantNotice *obj in notices) {
        
        NSFetchRequest* request = [[[NSFetchRequest alloc] init] autorelease];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"ETNoticPicture" inManagedObjectContext:delegate.managedObjectContext];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"noticeid = %@",obj.noticeid];
        [request setPredicate:predicate];
        [request setEntity:entity];
        NSArray *picArr = [delegate.managedObjectContext executeFetchRequest:request error:nil];
        
        for (NSManagedObject *mo in picArr) {
            [delegate.managedObjectContext deleteObject:mo];
        }
        
        [delegate.managedObjectContext deleteObject:obj];
    }
    
    
    BOOL successful = [self saveContext];
    
    return successful;
}
+ (BOOL)addImportantNoticeData:(NSArray *)noticeArray
{
    for (int i = 0; i < noticeArray.count; i++) {
        NSDictionary *infoDic = [noticeArray objectAtIndex:i];
//        NSError *err = nil;
        AppDelegate* delegate = SHARED_APP_DELEGATE;
        ETImportantNotice *notice = [NSEntityDescription insertNewObjectForEntityForName:@"ETImportantNotice" inManagedObjectContext:delegate.managedObjectContext];
        notice.addtime = [NSString stringWithFormat:@"%@",[infoDic objectForKey:@"addtime"]];
        notice.haveisconfirm = [NSString stringWithFormat:@"%@",[infoDic objectForKey:@"haveisconfirm"]];
        notice.isconfirm = [NSString stringWithFormat:@"%@",[infoDic objectForKey:@"isconfirm"]];
        notice.isteacher = [NSString stringWithFormat:@"%@",[infoDic objectForKey:@"isteacher"]];
        notice.noticecontent = [NSString stringWithFormat:@"%@",[infoDic objectForKey:@"noticecontent"]];
        notice.noticeid = [NSString stringWithFormat:@"%@",[infoDic objectForKey:@"noticeid"]];
        notice.noticekey = [NSString stringWithFormat:@"%@",[infoDic objectForKey:@"noticekey"]];
        notice.noticetitle = [NSString stringWithFormat:@"%@",[infoDic objectForKey:@"noticetitle"]];
        NSArray *picArr = [infoDic objectForKey:@"plist"];
        
        for (int i = 0; i < picArr.count; i++) {
            
            NSDictionary *picDic = [picArr objectAtIndex:i];
            
//            NSError *err = nil;
            AppDelegate* delegate = SHARED_APP_DELEGATE;
            ETNoticPicture *pic = [NSEntityDescription insertNewObjectForEntityForName:@"ETNoticPicture" inManagedObjectContext:delegate.managedObjectContext];
            pic.noticeid = notice.noticeid;
            pic.pictureurl = [NSString stringWithFormat:@"%@",[picDic objectForKey:@"source"]];
            
            [notice addImportantpicObject:pic];
        }
        
    }
    
    BOOL successful = [self saveContext];
    
    return successful;
}
+ (BOOL)updateImportantNoticeData:(NSString *)isconfirm ById:(NSString *)noticeid
{
    NSError *err = nil;
    AppDelegate *delegate = SHARED_APP_DELEGATE;
    NSFetchRequest* request = [[[NSFetchRequest alloc] init] autorelease];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ETImportantNotice" inManagedObjectContext:delegate.managedObjectContext];
    [request setEntity:entity];
    NSPredicate *searchPre = [NSPredicate predicateWithFormat:@"(noticeid = %@)",noticeid];
    [request setPredicate:searchPre];
    
    NSArray *notices = [delegate.managedObjectContext executeFetchRequest:request error:&err];
    if (!notices) {
        NSLog(@"!!!! remove articals error : %@",err);
    }
    
    ETImportantNotice *n = [notices objectAtIndex:0];
    n.haveisconfirm = isconfirm;
    
    BOOL successful = [self saveContext];
    return successful;
}



+ (NSArray *)searchAllActivity
{
    NSError *err = nil;
    AppDelegate *delegate = SHARED_APP_DELEGATE;
    NSFetchRequest* request = [[[NSFetchRequest alloc] init] autorelease];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ETActivity" inManagedObjectContext:delegate.managedObjectContext];
    [request setEntity:entity];
    NSSortDescriptor *sortDes = [NSSortDescriptor sortDescriptorWithKey:@"addtime" ascending:NO];
    [request setSortDescriptors:[NSArray arrayWithObject:sortDes]];
    
    NSArray *activities = [delegate.managedObjectContext executeFetchRequest:request error:&err];
    if (!activities) {
        NSLog(@"!!!! remove articals error : %@",err);
    }
    
    NSMutableArray *resultArr = [NSMutableArray array];
    for (int i = 0; i < activities.count; i++) {
        
        ETActivity *act = [activities objectAtIndex:i];
        
        ETEvents *events=[[ETEvents alloc]init];
        events.SignupStatus = act.signupstatus;
        events.address = act.address;
        events.addtime = act.addtime;
        events.end_time = act.endtime;
        events.events_id = act.eventsid;
        events.htmlurl = act.htmlurl;
        events.isSignup = act.issignup;
        events.isonline = act.isonline;
        events.picUrl = act.picurl;
        events.shool_id = act.schoolid;
        events.sign_up = act.signup;
        events.sign_up_end_time = act.signupendtime;
        events.sign_up_start_time = act.signupstarttime;
        events.start_time = act.starttime;
        events.title = act.title;
        
        [resultArr addObject:events];
        [events release];
    }
    
    return resultArr;
    
}

+ (BOOL)removeAllActivity
{
    NSError *err = nil;
    AppDelegate *delegate = SHARED_APP_DELEGATE;
    NSFetchRequest* request = [[[NSFetchRequest alloc] init] autorelease];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ETActivity" inManagedObjectContext:delegate.managedObjectContext];
    [request setEntity:entity];
    
    NSArray *activities = [delegate.managedObjectContext executeFetchRequest:request error:&err];
    if (!activities) {
        NSLog(@"!!!! remove articals error : %@",err);
    }
    
    for (ETActivity *obj in activities) {
        [delegate.managedObjectContext deleteObject:obj];
    }
    BOOL successful = [self saveContext];
    
    return successful;
}

+ (BOOL)addActivityData:(NSArray *)activityArray
{
    for (int i = 0; i < activityArray.count; i++) {
        ETEvents *events = [activityArray objectAtIndex:i];
//        NSError *err = nil;
        AppDelegate* delegate = SHARED_APP_DELEGATE;
        ETActivity *act = [NSEntityDescription insertNewObjectForEntityForName:@"ETActivity" inManagedObjectContext:delegate.managedObjectContext];
        
        act.signupstatus = events.SignupStatus;
        act.address = events.address;
        act.addtime = events.addtime;
        act.endtime = events.end_time;
        act.eventsid = events.events_id;
        act.htmlurl = events.htmlurl;
        act.issignup = events.isSignup;
        act.isonline = events.isonline;
        act.picurl = events.picUrl;
        act.schoolid = events.shool_id;
        act.signup = events.sign_up;
        act.signupendtime = events.sign_up_end_time;
        act.signupstarttime = events.sign_up_start_time;
        act.starttime = events.start_time;
        act.title = events.title;
        
    }
    
    BOOL successful = [self saveContext];
    
    return successful;
}

+ (BOOL)removeActivity:(ETEvents *)active
{
    NSError *err = nil;
    AppDelegate *delegate = SHARED_APP_DELEGATE;
    NSFetchRequest* request = [[[NSFetchRequest alloc] init] autorelease];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ETActivity" inManagedObjectContext:delegate.managedObjectContext];
    [request setEntity:entity];
    NSPredicate *searchPre = [NSPredicate predicateWithFormat:@"(eventsid = %@)",active.events_id];
    [request setPredicate:searchPre];
    
    NSArray *act = [delegate.managedObjectContext executeFetchRequest:request error:&err];
    if (!act) {
        NSLog(@"!!!! remove calendar error : %@",err);
        return NO;
    }
    
    for (ETActivity *obj in act) {
        [delegate.managedObjectContext deleteObject:obj];
    }
    
    
    BOOL successful = [self saveContext];
    
    return successful;
}
+ (BOOL)updateActivity:(ETEvents *)active
{
    if ([ETCoreDataManager removeActivity:active]) {
        return [ETCoreDataManager addActivityData:[NSArray arrayWithObjects:active, nil]];
    }
    
    return nil;
}


+ (NSArray *)searchAllMyActivity
{
    NSError *err = nil;
    AppDelegate *delegate = SHARED_APP_DELEGATE;
    NSFetchRequest* request = [[[NSFetchRequest alloc] init] autorelease];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"MyActivity" inManagedObjectContext:delegate.managedObjectContext];
    [request setEntity:entity];
    NSSortDescriptor *sortDes = [NSSortDescriptor sortDescriptorWithKey:@"addtime" ascending:NO];
    [request setSortDescriptors:[NSArray arrayWithObject:sortDes]];
    
    NSArray *activities = [delegate.managedObjectContext executeFetchRequest:request error:&err];
    if (!activities) {
        NSLog(@"!!!! remove articals error : %@",err);
    }
    
    NSMutableArray *resultArr = [NSMutableArray array];
    for (int i = 0; i < activities.count; i++) {
        
        MyActivity *act = [activities objectAtIndex:i];
        
        ETEvents *events=[[ETEvents alloc]init];
        events.SignupStatus = act.signupstatus;
        events.address = act.address;
        events.addtime = act.addtime;
        events.end_time = act.endtime;
        events.events_id = act.eventsid;
        events.htmlurl = act.htmlurl;
        events.isSignup = act.issignup;
        events.isonline = act.isonline;
        events.picUrl = act.picurl;
        events.shool_id = act.schoolid;
        events.sign_up = act.signup;
        events.sign_up_end_time = act.signupendtime;
        events.sign_up_start_time = act.signupstarttime;
        events.start_time = act.starttime;
        events.title = act.title;
        
        [resultArr addObject:events];
        [events release];
    }
    
    return resultArr;
}
+ (BOOL)removeAllMyActivity
{
    NSError *err = nil;
    AppDelegate *delegate = SHARED_APP_DELEGATE;
    NSFetchRequest* request = [[[NSFetchRequest alloc] init] autorelease];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"MyActivity" inManagedObjectContext:delegate.managedObjectContext];
    [request setEntity:entity];
    
    NSArray *activities = [delegate.managedObjectContext executeFetchRequest:request error:&err];
    if (!activities) {
        NSLog(@"!!!! remove articals error : %@",err);
    }
    
    for (MyActivity *obj in activities) {
        [delegate.managedObjectContext deleteObject:obj];
    }
    BOOL successful = [self saveContext];
    
    return successful;
}

+ (BOOL)removeMyActivity:(ETEvents *)active
{
    NSError *err = nil;
    AppDelegate *delegate = SHARED_APP_DELEGATE;
    NSFetchRequest* request = [[[NSFetchRequest alloc] init] autorelease];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"MyActivity" inManagedObjectContext:delegate.managedObjectContext];
    [request setEntity:entity];
    NSPredicate *searchPre = [NSPredicate predicateWithFormat:@"(eventsid = %@)",active.events_id];
    [request setPredicate:searchPre];
    
    NSArray *act = [delegate.managedObjectContext executeFetchRequest:request error:&err];
    if (!act) {
        NSLog(@"!!!! remove calendar error : %@",err);
        return NO;
    }
    
    for (MyActivity *obj in act) {
        [delegate.managedObjectContext deleteObject:obj];
    }
    
    
    BOOL successful = [self saveContext];
    
    return successful;
}

+ (BOOL)addMyActivityData:(NSArray *)activityArray
{
    for (int i = 0; i < activityArray.count; i++) {
        ETEvents *events = [activityArray objectAtIndex:i];
        //        NSError *err = nil;
        AppDelegate* delegate = SHARED_APP_DELEGATE;
        MyActivity *act = [NSEntityDescription insertNewObjectForEntityForName:@"MyActivity" inManagedObjectContext:delegate.managedObjectContext];
        
        act.signupstatus = events.SignupStatus;
        act.address = events.address;
        act.addtime = events.addtime;
        act.endtime = events.end_time;
        act.eventsid = events.events_id;
        act.htmlurl = events.htmlurl;
        act.issignup = events.isSignup;
        act.isonline = events.isonline;
        act.picurl = events.picUrl;
        act.schoolid = events.shool_id;
        act.signup = events.sign_up;
        act.signupendtime = events.sign_up_end_time;
        act.signupstarttime = events.sign_up_start_time;
        act.starttime = events.start_time;
        act.title = events.title;
        
    }
    
    BOOL successful = [self saveContext];
    
    return successful;
}

+ (NSArray *)searchAllNoStartActivity
{
    NSError *err = nil;
    AppDelegate *delegate = SHARED_APP_DELEGATE;
    NSFetchRequest* request = [[[NSFetchRequest alloc] init] autorelease];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ETNoStartActivity" inManagedObjectContext:delegate.managedObjectContext];
    [request setEntity:entity];
    NSSortDescriptor *sortDes = [NSSortDescriptor sortDescriptorWithKey:@"addtime" ascending:NO];
    [request setSortDescriptors:[NSArray arrayWithObject:sortDes]];
    
    NSArray *activities = [delegate.managedObjectContext executeFetchRequest:request error:&err];
    if (!activities) {
        NSLog(@"!!!! remove activity error : %@",err);
    }
    
    NSMutableArray *resultArr = [NSMutableArray array];
    for (int i = 0; i < activities.count; i++) {
        
        ETNoStartActivity *act = [activities objectAtIndex:i];
        
        ETEvents *events=[[ETEvents alloc]init];
        events.SignupStatus = act.signupstatus;
        events.addtime = act.addtime;
        events.address = act.address;
        events.end_time = act.endtime;
        events.events_id = act.eventsid;
        events.htmlurl = act.htmlurl;
        events.isSignup = act.issignup;
        events.isonline = act.isonline;
        events.picUrl = act.picurl;
        events.shool_id = act.schoolid;
        events.sign_up = act.signup;
        events.sign_up_end_time = act.signupendtime;
        events.sign_up_start_time = act.signupstarttime;
        events.start_time = act.starttime;
        events.title = act.title;
        
        [resultArr addObject:events];
        [events release];
    }
    
    return resultArr;
}
+ (BOOL)removeAllNoStartActivity
{
    NSError *err = nil;
    AppDelegate *delegate = SHARED_APP_DELEGATE;
    NSFetchRequest* request = [[[NSFetchRequest alloc] init] autorelease];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ETNoStartActivity" inManagedObjectContext:delegate.managedObjectContext];
    [request setEntity:entity];
    
    NSArray *activities = [delegate.managedObjectContext executeFetchRequest:request error:&err];
    if (!activities) {
        NSLog(@"!!!! remove articals error : %@",err);
    }
    
    for (ETNoStartActivity *obj in activities) {
        [delegate.managedObjectContext deleteObject:obj];
    }
    BOOL successful = [self saveContext];
    
    return successful;
}

+ (BOOL)removeNoStartActivity:(ETEvents *)active
{
    NSError *err = nil;
    AppDelegate *delegate = SHARED_APP_DELEGATE;
    NSFetchRequest* request = [[[NSFetchRequest alloc] init] autorelease];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ETNoStartActivity" inManagedObjectContext:delegate.managedObjectContext];
    [request setEntity:entity];
    NSPredicate *searchPre = [NSPredicate predicateWithFormat:@"(eventsid = %@)",active.events_id];
    [request setPredicate:searchPre];
    
    NSArray *act = [delegate.managedObjectContext executeFetchRequest:request error:&err];
    if (!act) {
        NSLog(@"!!!! remove calendar error : %@",err);
        return NO;
    }
    
    for (ETNoStartActivity *obj in act) {
        [delegate.managedObjectContext deleteObject:obj];
    }
    
    
    BOOL successful = [self saveContext];
    
    return successful;
}


+ (BOOL)addNoStartActivityData:(NSArray *)activityArray
{
    for (int i = 0; i < activityArray.count; i++) {
        ETEvents *events = [activityArray objectAtIndex:i];
        //        NSError *err = nil;
        AppDelegate* delegate = SHARED_APP_DELEGATE;
        ETNoStartActivity *act = [NSEntityDescription insertNewObjectForEntityForName:@"ETNoStartActivity" inManagedObjectContext:delegate.managedObjectContext];
        
        act.signupstatus = events.SignupStatus;
        act.address = events.address;
        act.endtime = events.end_time;
        act.addtime = events.addtime;
        act.eventsid = events.events_id;
        act.htmlurl = events.htmlurl;
        act.issignup = events.isSignup;
        act.isonline = events.isonline;
        act.picurl = events.picUrl;
        act.schoolid = events.shool_id;
        act.signup = events.sign_up;
        act.signupendtime = events.sign_up_end_time;
        act.signupstarttime = events.sign_up_start_time;
        act.starttime = events.start_time;
        act.title = events.title;
        
    }
    
    BOOL successful = [self saveContext];
    
    return successful;

}

+ (BOOL)updateNoStartActivity:(ETEvents *)active
{
    
    if ([ETCoreDataManager removeNoStartActivity:active]) {
        return [ETCoreDataManager addNoStartActivityData:[NSArray arrayWithObjects:active, nil]];
    }
    return NO;
    
}







+ (NSArray *)searchAttendanceByMonth:(NSString *)month
{
    NSError *err = nil;
    AppDelegate *delegate = SHARED_APP_DELEGATE;
    NSFetchRequest* request = [[[NSFetchRequest alloc] init] autorelease];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ETAttendance" inManagedObjectContext:delegate.managedObjectContext];
    [request setEntity:entity];
    NSPredicate *searchPre = [NSPredicate predicateWithFormat:@"(yearmonth = %@)",month];
    [request setPredicate:searchPre];
    
    NSArray *attendance = [delegate.managedObjectContext executeFetchRequest:request error:&err];
    if (!attendance) {
        NSLog(@"!!!! remove attendance error : %@",err);
        return nil;
    }
    
    NSMutableArray *attArr = [NSMutableArray array];
    for (int i = 0; i < attendance.count ; i++ ) {
        ETAttendance *att = [attendance objectAtIndex:i];
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:att.attendanceday forKey:@"attendaceday"];
        [dic setObject:att.attendancetypeid forKey:@"attendancetypeid"];
        [dic setObject:att.reason forKey:@"reason"];
        [attArr addObject:dic];
    }
    
    return attArr;
    
    
}
+ (BOOL)removeAttendanceByMonth:(NSString *)month
{
    NSError *err = nil;
    AppDelegate *delegate = SHARED_APP_DELEGATE;
    NSFetchRequest* request = [[[NSFetchRequest alloc] init] autorelease];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ETAttendance" inManagedObjectContext:delegate.managedObjectContext];
    [request setEntity:entity];
    NSPredicate *searchPre = [NSPredicate predicateWithFormat:@"(yearmonth = %@)",month];
    [request setPredicate:searchPre];
    
    NSArray *attendance = [delegate.managedObjectContext executeFetchRequest:request error:&err];
    if (!attendance) {
        NSLog(@"!!!! remove attendance error : %@",err);
        return NO;
    }
    
    for (ETAttendance *obj in attendance) {
        [delegate.managedObjectContext deleteObject:obj];
    }
    
    
    BOOL successful = [self saveContext];
    
    return successful;

    
}
+ (BOOL)addAttendance:(NSArray *)attArr withMonth:(NSString *)month
{
    for (int i = 0; i < attArr.count; i++) {
        NSDictionary *dic = [attArr objectAtIndex:i];
        //        NSError *err = nil;
        AppDelegate* delegate = SHARED_APP_DELEGATE;
        ETAttendance *att = [NSEntityDescription insertNewObjectForEntityForName:@"ETAttendance" inManagedObjectContext:delegate.managedObjectContext];
        
        att.yearmonth = month;
        att.attendanceday = [dic objectForKey:@"attendaceday"];
        att.attendancetypeid = [NSString stringWithFormat:@"%@",[dic objectForKey:@"attendancetypeid"]];
        att.reason = [NSString stringWithFormat:@"%@",[dic objectForKey:@"reason"]];
        
    }
    
    BOOL successful = [self saveContext];
    
    return successful;
}

+ (BOOL)removeAllAttendance
{
    NSError *err = nil;
    AppDelegate *delegate = SHARED_APP_DELEGATE;
    NSFetchRequest* request = [[[NSFetchRequest alloc] init] autorelease];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ETAttendance" inManagedObjectContext:delegate.managedObjectContext];
    [request setEntity:entity];
    
    NSArray *attendance = [delegate.managedObjectContext executeFetchRequest:request error:&err];
    if (!attendance) {
        NSLog(@"!!!! remove attendance error : %@",err);
        return NO;
    }
    
    for (ETAttendance *obj in attendance) {
        [delegate.managedObjectContext deleteObject:obj];
    }
    
    BOOL successful = [self saveContext];
    
    return successful;
}


+ (NSArray *)searchCalendarByMonth:(NSString *)month
{
    NSError *err = nil;
    AppDelegate *delegate = SHARED_APP_DELEGATE;
    NSFetchRequest* request = [[[NSFetchRequest alloc] init] autorelease];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ETCalendar" inManagedObjectContext:delegate.managedObjectContext];
    [request setEntity:entity];
    NSPredicate *searchPre = [NSPredicate predicateWithFormat:@"(yearmonth = %@)",month];
    [request setPredicate:searchPre];
    
    NSArray *calArr = [delegate.managedObjectContext executeFetchRequest:request error:&err];
    if (!calArr) {
        NSLog(@"!!!! remove calendar error : %@",err);
        return nil;
    }
    
    NSMutableArray *result = [NSMutableArray array];
    for (int i = 0; i < calArr.count ; i++ ) {
        ETCalendar *c = [calArr objectAtIndex:i];
    
        NSString *str = [NSString stringWithFormat:@"%@,%@",c.date,c.festival];
        [result addObject:str];
    }
    
    return result;
}
+ (BOOL)removeCalendarByMonth:(NSString *)month
{
    NSError *err = nil;
    AppDelegate *delegate = SHARED_APP_DELEGATE;
    NSFetchRequest* request = [[[NSFetchRequest alloc] init] autorelease];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ETCalendar" inManagedObjectContext:delegate.managedObjectContext];
    [request setEntity:entity];
    NSPredicate *searchPre = [NSPredicate predicateWithFormat:@"(yearmonth = %@)",month];
    [request setPredicate:searchPre];
    
    NSArray *attendance = [delegate.managedObjectContext executeFetchRequest:request error:&err];
    if (!attendance) {
        NSLog(@"!!!! remove calendar error : %@",err);
        return NO;
    }
    
    for (ETCalendar *obj in attendance) {
        [delegate.managedObjectContext deleteObject:obj];
    }
    
    
    BOOL successful = [self saveContext];
    
    return successful;
}

+ (BOOL)removeAllCalendar
{
    NSError *err = nil;
    AppDelegate *delegate = SHARED_APP_DELEGATE;
    NSFetchRequest* request = [[[NSFetchRequest alloc] init] autorelease];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ETCalendar" inManagedObjectContext:delegate.managedObjectContext];
    [request setEntity:entity];
    
    NSArray *attendance = [delegate.managedObjectContext executeFetchRequest:request error:&err];
    if (!attendance) {
        NSLog(@"!!!! remove calendar error : %@",err);
        return NO;
    }
    
    for (ETCalendar *obj in attendance) {
        [delegate.managedObjectContext deleteObject:obj];
    }
    
    
    BOOL successful = [self saveContext];
    
    return successful;
}

+ (BOOL)addCalendar:(NSArray *)calArr withMonth:(NSString *)month
{
    AppDelegate* delegate = SHARED_APP_DELEGATE;
    
//    NSArray *festivalsKey = [NSArray arrayWithObjects:@"New_Year_Day",@"Spring_Festival",@"Tomb_Sweeping_Day",@"May_Holiday",@"Dragon_Boat_Festival",@"Professional_Devlopment_Day",@"Moon_Festival",@"National_Day",@"Summer_Holiday",@"prodevtime", nil];
    
    
    if (calArr != nil && calArr.count != 0) {
        
//        NSArray *keys = [calDic allKeys];
        for (int i = 0; i<calArr.count; i++) {
            
//            NSString *keyStr = [keys objectAtIndex:i];
//            
//            if ([festivalsKey containsObject:keyStr]) {
//                NSArray *cArr = [calDic objectForKey:keyStr];
            NSString *str = [calArr objectAtIndex:i];
            NSString *fdateStr = [[str componentsSeparatedByString:@","] objectAtIndex:0];
            NSString *fname = [[str componentsSeparatedByString:@","] objectAtIndex:1];
                
            ETCalendar *cal = [NSEntityDescription insertNewObjectForEntityForName:@"ETCalendar" inManagedObjectContext:delegate.managedObjectContext];
            cal.yearmonth = month;
            cal.date = fdateStr;
            cal.festival = fname;
                
//            NSLog(@"add calendar : %@ , %@ , %@",month,[cArr componentsJoinedByString:@","],keyStr);
            
            
        }
    }
    
    
    BOOL successful = [self saveContext];
    
    return successful;
    
}





+ (NSArray *)searchScheduleByDate:(NSString *)date
{
    NSError *err = nil;
    AppDelegate *delegate = SHARED_APP_DELEGATE;
    NSFetchRequest* request = [[[NSFetchRequest alloc] init] autorelease];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ETSchedule" inManagedObjectContext:delegate.managedObjectContext];
    [request setEntity:entity];
    NSPredicate *searchPre = [NSPredicate predicateWithFormat:@"(date = %@)",date];
    [request setPredicate:searchPre];
    NSSortDescriptor *sortDes = [NSSortDescriptor sortDescriptorWithKey:@"snum" ascending:YES];
    [request setSortDescriptors:[NSArray arrayWithObject:sortDes]];
    
    NSArray *schArr = [delegate.managedObjectContext executeFetchRequest:request error:&err];
    if (!schArr) {
        NSLog(@"!!!! search schedule error : %@",err);
        return nil;
    }
    
    NSMutableArray *tempArr = [NSMutableArray array];
    for (int i = 0 ; i < schArr.count; i++) {
        ETSchedule *s = [schArr objectAtIndex:i];
        NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
        [tempDic setObject:s.course forKey:@"cnname"];
        [tempDic setObject:s.scheduletime forKey:@"scheduletime"];
        
        [tempArr addObject:tempDic];
    }
    
    return tempArr;
    
    
}
+ (BOOL)removeAllSchedule
{
    NSError *err = nil;
    AppDelegate *delegate = SHARED_APP_DELEGATE;
    NSFetchRequest* request = [[[NSFetchRequest alloc] init] autorelease];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ETSchedule" inManagedObjectContext:delegate.managedObjectContext];
    [request setEntity:entity];
    
    NSArray *schArr = [delegate.managedObjectContext executeFetchRequest:request error:&err];
    if (!schArr) {
        NSLog(@"!!!! search schedule error : %@",err);
        return nil;
    }
    
    for (id obj in schArr) {
        [delegate.managedObjectContext deleteObject:obj];
    }
    
    BOOL successful = [self saveContext];
    
    return successful;
    
}
+ (BOOL)removeScheduleByDate:(NSString *)date
{
    NSError *err = nil;
    AppDelegate *delegate = SHARED_APP_DELEGATE;
    NSFetchRequest* request = [[[NSFetchRequest alloc] init] autorelease];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ETSchedule" inManagedObjectContext:delegate.managedObjectContext];
    [request setEntity:entity];
    NSPredicate *searchPre = [NSPredicate predicateWithFormat:@"(date = %@)",date];
    [request setPredicate:searchPre];
    
    NSArray *schedule = [delegate.managedObjectContext executeFetchRequest:request error:&err];
    if (!schedule) {
        NSLog(@"!!!! remove schedule error : %@",err);
        return NO;
    }
    
    for (ETSchedule *obj in schedule) {
        [delegate.managedObjectContext deleteObject:obj];
    }
    
    
    BOOL successful = [self saveContext];
    
    return successful;
}
+ (BOOL)addSchedule:(NSArray *)schArr withDate:(NSString *)date
{
    for (int i = 0; i < schArr.count; i++) {
        NSDictionary *dic = [schArr objectAtIndex:i];
        //        NSError *err = nil;
        AppDelegate* delegate = SHARED_APP_DELEGATE;
        ETSchedule *schedule = [NSEntityDescription insertNewObjectForEntityForName:@"ETSchedule" inManagedObjectContext:delegate.managedObjectContext];
        
        schedule.scheduletime = [dic objectForKey:@"scheduletime"];
        schedule.date = date;
        schedule.snum = [NSNumber numberWithInt:i + 1];
        schedule.course = [NSString stringWithFormat:@"%@",[dic objectForKey:@"cnname"]];
        
    }
    
    BOOL successful = [self saveContext];
    
    return successful;
}



+ (NSArray *)searchFoodByDate:(NSString *)date
{
    NSError *err = nil;
    AppDelegate *delegate = SHARED_APP_DELEGATE;
    NSFetchRequest* request = [[[NSFetchRequest alloc] init] autorelease];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ETFood" inManagedObjectContext:delegate.managedObjectContext];
    [request setEntity:entity];
    NSPredicate *searchPre = [NSPredicate predicateWithFormat:@"(date = %@)",date];
    [request setPredicate:searchPre];
    NSSortDescriptor *sortDes = [NSSortDescriptor sortDescriptorWithKey:@"type" ascending:YES];
    [request setSortDescriptors:[NSArray arrayWithObject:sortDes]];
    
    NSArray *foodArr = [delegate.managedObjectContext executeFetchRequest:request error:&err];
    if (!foodArr) {
        NSLog(@"!!!! search food error : %@",err);
        return nil;
    }
    
    NSMutableArray *tempArr = [NSMutableArray array];
    for (int i = 0 ; i < foodArr.count; i++) {
        ETFood *s = [foodArr objectAtIndex:i];
        NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
        [tempDic setObject:s.date forKey:@"menu_day"];
        [tempDic setObject:s.name forKey:@"menu_name"];
        [tempDic setObject:s.type forKey:@"menu_type"];
        [tempDic setObject:s.typename forKey:@"menu_type_name"];
        [tempArr addObject:tempDic];
    }
    
    return tempArr;
}
+ (BOOL)removeAllFood
{
    NSError *err = nil;
    AppDelegate *delegate = SHARED_APP_DELEGATE;
    NSFetchRequest* request = [[[NSFetchRequest alloc] init] autorelease];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ETFood" inManagedObjectContext:delegate.managedObjectContext];
    [request setEntity:entity];
    
    NSArray *foodArr = [delegate.managedObjectContext executeFetchRequest:request error:&err];
    if (!foodArr) {
        NSLog(@"!!!! search food error : %@",err);
        return nil;
    }
    
    for (id obj in foodArr) {
        [delegate.managedObjectContext deleteObject:obj];
    }
    
    BOOL successful = [self saveContext];
    
    return successful;
}
+ (BOOL)removeFoodByDate:(NSString *)date
{
    NSError *err = nil;
    AppDelegate *delegate = SHARED_APP_DELEGATE;
    NSFetchRequest* request = [[[NSFetchRequest alloc] init] autorelease];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ETFood" inManagedObjectContext:delegate.managedObjectContext];
    [request setEntity:entity];
    NSPredicate *searchPre = [NSPredicate predicateWithFormat:@"(date = %@)",date];
    [request setPredicate:searchPre];
    
    NSArray *food = [delegate.managedObjectContext executeFetchRequest:request error:&err];
    if (!food) {
        NSLog(@"!!!! remove calendar error : %@",err);
        return NO;
    }
    
    for (ETFood *obj in food) {
        [delegate.managedObjectContext deleteObject:obj];
    }
    
    
    BOOL successful = [self saveContext];
    
    return successful;
}
+ (BOOL)addFood:(NSArray *)foodArr;
{
    for (int i = 0; i < foodArr.count; i++) {
        NSDictionary *dic = [foodArr objectAtIndex:i];
        //        NSError *err = nil;
        AppDelegate* delegate = SHARED_APP_DELEGATE;
        ETFood *food = [NSEntityDescription insertNewObjectForEntityForName:@"ETFood" inManagedObjectContext:delegate.managedObjectContext];
        
        food.type = [NSString stringWithFormat:@"%@",[dic objectForKey:@"menu_type"]];
        food.name = [dic objectForKey:@"menu_name"];
        food.date = [dic objectForKey:@"menu_day"];
        food.typename = [dic objectForKey:@"menu_type_name"];
        
    }
    
    BOOL successful = [self saveContext];
    
    return successful;
}



@end
