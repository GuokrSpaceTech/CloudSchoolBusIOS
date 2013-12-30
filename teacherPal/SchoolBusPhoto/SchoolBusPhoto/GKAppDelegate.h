//
//  GKAppDelegate.h
//  SchoolBusPhoto
//
//  Created by mactop on 10/19/13.
//  Copyright (c) 2013 mactop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
#import "BPush.h"
#import "EKRequest.h"


#import "GKLoginViewController.h"
@interface GKAppDelegate : UIResponder <UIApplicationDelegate,EKProtocol,UIAlertViewDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic,retain) GKLoginViewController *loginVC;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
-(BOOL)connectedToNetWork;
@end
