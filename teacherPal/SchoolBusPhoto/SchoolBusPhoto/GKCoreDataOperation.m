//
//  GKCoreDataOperation.m
//  SchoolBusPhoto
//
//  Created by wen peifang on 14-1-20.
//  Copyright (c) 2014年 mactop. All rights reserved.
//

#import "GKCoreDataOperation.h"
#import "GKAppDelegate.h"
@implementation GKCoreDataOperation
@synthesize managedObjectContext;
@synthesize entryStr;
@synthesize type;
- (id)initWithData:(NSMutableArray *)parseData  entry:(NSString *)entry
{
    self = [super init];
    if (self) {

        
  
        self.entryStr=entryStr;
    
    }
    return self;

}
-(void)operationCoreData
{
    if(type==Insert)
    {
        
    }
    if(type==Delete)
    {
        
    }
}

- (void)main {
    
    
    GKAppDelegate *delegate=APPDELEGATE;
    // Creating context in main function here make sure the context is tied to current thread.
    // init: use thread confine model to make things simpler.
    managedObjectContext = [[NSManagedObjectContext alloc] init];
    self.managedObjectContext.persistentStoreCoordinator =delegate.persistentStoreCoordinator;
    
    
    
    
    [self operationCoreData];
    
    
    /*
     It's also possible to have NSXMLParser download the data, by passing it a URL, but this is not desirable because it gives less control over the network, particularly in responding to connection errors.
     */

    /*
     Depending on the total number of earthquakes parsed, the last batch might not have been a "full" batch, and thus not been part of the regular batch transfer. So, we check the count of the array and, if necessary, send it to the main thread.
     */

}

-(void)dealloc
{
    self.managedObjectContext=nil;

    self.entryStr=nil;
    [super dealloc];
}
@end
