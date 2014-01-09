//
//  GKCoreDataManager.m
//  SchoolBusPhoto
//
//  Created by CaiJingPeng on 14-1-9.
//  Copyright (c) 2014年 mactop. All rights reserved.
//

#import "GKCoreDataManager.h"
#import "GKAppDelegate.h"
#import "MovieDraft.h"

@implementation GKCoreDataManager

+ (BOOL)saveContext{
    
    NSError *err = nil;
    GKAppDelegate* delegate = SHARED_APP_DELEGATE;
    BOOL successful = [delegate.managedObjectContext save:&err];
    if (!successful) {
        NSLog(@"Error saving : %@",[err localizedDescription]);
    }
    
    return successful;
    
}

+ (NSArray *)searchMovieDraftByUserid:(NSString *)userid
{
    NSError *err = nil;
    GKAppDelegate *delegate = SHARED_APP_DELEGATE;
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"MovieDraft" inManagedObjectContext:delegate.managedObjectContext];
    [request setEntity:entity];
    NSSortDescriptor *sortDes = [NSSortDescriptor sortDescriptorWithKey:@"createdate" ascending:NO];
    [request setSortDescriptors:[NSArray arrayWithObject:sortDes]];
    NSPredicate *searchPre = [NSPredicate predicateWithFormat:@"(userid = %@)",userid];
    [request setPredicate:searchPre];
    
    NSArray *movies = [delegate.managedObjectContext executeFetchRequest:request error:&err];
    
    if (!movies) {
        NSLog(@"!!!! search movie draft error : %@",err);
    }
    
    return movies;
    
    
}
+ (BOOL)addMovieDraftWithUserid:(NSString *)userid moviePath:(NSString *)path dateStamp:(NSString *)date
{
    GKAppDelegate* delegate = SHARED_APP_DELEGATE;
    MovieDraft *movie = [NSEntityDescription insertNewObjectForEntityForName:@"MovieDraft" inManagedObjectContext:delegate.managedObjectContext];
    movie.createdate = date;
    movie.moviepath = path;
    movie.userid = userid;
    BOOL successful = [self saveContext];
    
    return successful;
}
+ (BOOL)removeMovieDraftByUserid:(NSString *)userid moviePath:(NSString *)path
{
    NSError *err = nil;
    GKAppDelegate *delegate = SHARED_APP_DELEGATE;
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"MovieDraft" inManagedObjectContext:delegate.managedObjectContext];
    [request setEntity:entity];
    NSPredicate *searchPre = [NSPredicate predicateWithFormat:@"(userid = %@ and moviepath = %@)",userid,path];
    [request setPredicate:searchPre];
    
    
    NSArray *movies = [delegate.managedObjectContext executeFetchRequest:request error:&err];
    
    if (!movies) {
        NSLog(@"!!!! search articals error : %@",err);
    }
    
    MovieDraft *md = [movies objectAtIndex:0];
    [delegate.managedObjectContext deleteObject:md];
    BOOL successful = [self saveContext];
    
    return successful;
    
}

@end
