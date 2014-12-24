//
//  DBManager.m
//  pocCameraMap
//
//  Created by Tang Xiaoping on 6/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

//nsconditionlock reference http://www.cocoadev.com/index.pl?ProducersAndConsumerModel

#import "DBManager.h"
#import "GKAppDelegate.h"
#import "UpLoader.h"
@interface DBManager (Private)

- (void)performanceDB;

- (void)insertData:(updateBlock)iBlock toEntity:(NSString *)name success:(successBlock)sBlock failed:(failedBlock)fBlock;
- (void)updateData:(updateBlock)uBlock request:(NSFetchRequest *)request success:(successBlock)sBlock failed:(failedBlock)fBlock;
- (void)deleteData:(NSFetchRequest *)request success:(successBlock)sBlock failed:(failedBlock)fBlock;
- (void)retriveData:(NSFetchRequest *)request finish:(retriveBlock)sBlock failed:(failedBlock)fBlock;

- (NSURL *)applicationDocumentsDirectory;
- (void)saveContext;

@end



@implementation DBManager

@synthesize coreDataThread;
@synthesize syCondition;
@synthesize commandArray;

+(DBManager *)shareInstance {
	static dispatch_once_t pred;
	static DBManager *shared = nil;
	
	dispatch_once(&pred, ^{
		shared = [[DBManager alloc] init];
        
	});
	
	return shared;
}

+ (void)clearInstance
{
    DBManager *shared = [DBManager shareInstance];
    [shared release];
    shared    = nil;
}

- (void)run
{
    while (YES) 
    {
        
        //NSLog(@"yesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyes");
        [syCondition lockWhenCondition:LOCK_CONDITION_HAVEDATA];
        
        
        if ([commandArray count] > 0) 
        {
            NSDictionary *commandDic = [commandArray objectAtIndex:0];
            
            if (commandArray) 
            {
                NSNumber *command_type = [commandDic objectForKey:COMMAND_TYPE_KEY];
                
                switch ([command_type intValue]) 
                {
                    case COMMAND_INSERT:
                    {
                        updateBlock  uBlock      = [commandDic objectForKey:UPDATE_BLOCK_KEY];
                        successBlock sBlock      = [commandDic objectForKey:SUCCESS_BLOCK_KEY];
                        failedBlock  fBlock      = [commandDic objectForKey:FAILED_BLOCK_KEY];
                        NSString     *entityName = [commandDic objectForKey:ENTITY_NAME_KEY];
                        
                        [self insertData:uBlock toEntity:entityName success:sBlock failed:fBlock];
                        break;
                    }
                    case COMMAND_UPDATE:
                    {
                        updateBlock  uBlock      = [commandDic objectForKey:UPDATE_BLOCK_KEY];
                        successBlock sBlock      = [commandDic objectForKey:SUCCESS_BLOCK_KEY];
                        failedBlock  fBlock      = [commandDic objectForKey:FAILED_BLOCK_KEY];
                        NSFetchRequest *request  = [commandDic objectForKey:COMMAND_REQUEST_KEY];
                        
                        [self updateData:uBlock request:request success:sBlock failed:fBlock];
                        
                        break;
                    }
                    case COMMAND_RETRIVE:
                    {
                        retriveBlock rBlock      = [commandDic objectForKey:RETRIVE_BLOCK_KEY];
                        failedBlock  fBlock      = [commandDic objectForKey:FAILED_BLOCK_KEY];
                        NSFetchRequest *request  = [commandDic objectForKey:COMMAND_REQUEST_KEY];
                        
                        [self retriveData:request finish:rBlock failed:fBlock];
                        
                        break;
                    }
                    case COMMAND_DELETE:
                    {
                        retriveBlock sBlock      = [commandDic objectForKey:SUCCESS_BLOCK_KEY];
                        failedBlock  fBlock      = [commandDic objectForKey:FAILED_BLOCK_KEY];
                        NSFetchRequest *request  = [commandDic objectForKey:COMMAND_REQUEST_KEY];
                        
                        [self deleteData:request success:sBlock failed:fBlock];
                        
                        break;
                    }
                    default:
                        break;
                }
            }
            
            
            [commandArray removeObjectAtIndex:0];
            
        }
        
        NSInteger count = [commandArray count];
       // NSLog(@"count %d",count);
        [syCondition unlockWithCondition:(count > 0)?LOCK_CONDITION_HAVEDATA : LOCK_CONDITION_NODATA];
    }
}

- (id) init{
	
	if (self = [super init])
	{
        GKAppDelegate *delegate=APPDELEGATE;
		NSManagedObjectContext *context = delegate.managedObjectContext;
		if (!context) {
			// Handle the error.
			NSLog(@"managedObjectContext Initialization Failed!");
		}
        
        //[context setStalenessInterval:0.0];
        
        self.commandArray    = [[[NSMutableArray alloc] init] autorelease];
        self.syCondition     = [[[NSConditionLock alloc] initWithCondition:LOCK_CONDITION_NODATA] autorelease];
        self.coreDataThread  = [[[NSThread alloc] initWithTarget:self selector:@selector(run) object:nil] autorelease];
        [self.coreDataThread start];

	}
	return self;
}



- (void)dealloc {
    [super dealloc];

	//[logicTimer invalidate];
    
    [coreDataThread release]; coreDataThread = nil;
    [syCondition    release]; syCondition    = nil;
    [commandArray   release]; commandArray   = nil;
}


#pragma mark --
#pragma mark action

#pragma mark - private methord
- (void)insertData:(updateBlock)iBlock toEntity:(NSString *)name success:(successBlock)sBlock failed:(failedBlock)fBlock
{
    
    NSError *error = nil;
    GKAppDelegate *delegate=APPDELEGATE;
    NSManagedObjectModel   *moModel      = delegate.managedObjectModel;//  [self managedObjectModel];
    NSManagedObjectContext *moContext    = delegate.managedObjectContext;//[self managedObjectContext];
    NSEntityDescription    *EntityDec    = [[moModel entitiesByName] objectForKey:name];
    
    Class EntityObject = NSClassFromString(name);
    if (EntityObject) {
        NSManagedObject *insertValue = [NSEntityDescription insertNewObjectForEntityForName:[EntityDec name] inManagedObjectContext:moContext];
        
        if (insertValue) 
        {
            
            iBlock(insertValue);
            
            if (![moContext save: &error]) {
                fBlock(error);
            }
            else
            {
                sBlock();
            }
            
        }
    }
}

- (void)updateData:(updateBlock)uBlock request:(NSFetchRequest *)request success:(successBlock)sBlock failed:(failedBlock)fBlock
{
    NSError *error = nil;
    GKAppDelegate *delegate=APPDELEGATE;
    NSManagedObjectContext *moContext = delegate.managedObjectContext;;
    
    if (moContext) 
    {
        NSArray *fetchedObjects = [moContext executeFetchRequest:request error:&error];
        
        if (error) 
        {
            fBlock(error);
        }
        else
        {
            for (NSManagedObject *info in fetchedObjects) 
            {
                
               // NSLog(@"")
                
                UpLoader *loader=(UpLoader *)info;
                NSLog(@"%@",loader.isUploading);
                
                uBlock(info);
            }
            
            if (![moContext save: &error]) 
            {
                fBlock(error);
            }
            else
            {
                sBlock();
            }
        }
    }
}

- (void)deleteData:(NSFetchRequest *)request success:(successBlock)sBlock failed:(failedBlock)fBlock
{
    NSError *error = nil;
    GKAppDelegate *delegate=APPDELEGATE;
    NSManagedObjectContext *moContext = delegate.managedObjectContext;;
    //NSManagedObjectContext *moContext    = [self managedObjectContext];
    if (moContext) 
    {
        NSArray *fetchedObjects = [moContext executeFetchRequest:request error:&error];
        
        if (error) 
        {
            fBlock(error);
        }
        else
        {
            
            for (NSManagedObject *info in fetchedObjects) 
            {
                [moContext deleteObject:info];
            }
            
            if (![moContext save: &error]) 
            {
                fBlock(error);
            }
            else
            {
                sBlock();
            }
        }
    }
}

- (void)retriveData:(NSFetchRequest *)request finish:(retriveBlock)sBlock failed:(failedBlock)fBlock
{
    NSError *error = nil;
    GKAppDelegate *delegate=APPDELEGATE;
    NSManagedObjectContext *moContext = delegate.managedObjectContext;;
    //NSManagedObjectContext *moContext = [self managedObjectContext];
    
    if (moContext) 
    {
        NSArray *fetchedObjects = [moContext executeFetchRequest:request error:&error];
        
        if (error) 
        {
            fBlock(error);
        }
        else
        {
            sBlock(fetchedObjects);
        }
    }
}

#pragma mark - For user to use
- (void)insertObject:(updateBlock)iBlock entityName:(NSString *)name success:(successBlock)sBlock failed:(failedBlock)fBlock
{
    updateBlock  iB = [iBlock copy];
    successBlock sB = [sBlock copy];
    failedBlock  fB = [fBlock copy];
    
    NSNumber *type = [NSNumber numberWithInt:COMMAND_INSERT];
    NSDictionary *command = [NSDictionary dictionaryWithObjectsAndKeys:type,COMMAND_TYPE_KEY, iB, UPDATE_BLOCK_KEY, sB, SUCCESS_BLOCK_KEY, fB, FAILED_BLOCK_KEY, name, ENTITY_NAME_KEY, nil];
    
    [syCondition lock];
    [commandArray addObject:command];
    [syCondition unlockWithCondition:LOCK_CONDITION_HAVEDATA];
    
    [iB release];
    [sB release];
    [fB release];
}

- (void)updateObject:(updateBlock)uBlock request:(NSFetchRequest *)request success:(successBlock)sBlock failed:(failedBlock)fBlock
{
    updateBlock  uB = [uBlock copy];
    successBlock sB = [sBlock copy];
    failedBlock  fB = [fBlock copy];
    
    NSNumber *type = [NSNumber numberWithInt:COMMAND_UPDATE];
    
    NSDictionary *command = [NSDictionary dictionaryWithObjectsAndKeys:type, COMMAND_TYPE_KEY, uB, UPDATE_BLOCK_KEY, sB, SUCCESS_BLOCK_KEY, fB, FAILED_BLOCK_KEY, request, COMMAND_REQUEST_KEY, nil];
    
    [syCondition lock];
    [commandArray addObject:command];
    [syCondition unlockWithCondition:LOCK_CONDITION_HAVEDATA];
    
    [uB release];
    [sB release];
    [fB release];
}

- (void)deleteObject:(NSFetchRequest *)request success:(successBlock)sBlock failed:(failedBlock)fBlock
{
    successBlock sB = [sBlock copy];
    failedBlock  fB = [fBlock copy];
    
    NSNumber *type = [NSNumber numberWithInt:COMMAND_DELETE];
    
    NSDictionary *command = [NSDictionary dictionaryWithObjectsAndKeys:type, COMMAND_TYPE_KEY, sB, SUCCESS_BLOCK_KEY, fB, FAILED_BLOCK_KEY, request, COMMAND_REQUEST_KEY, nil];
    
    [syCondition lock];
    [commandArray addObject:command];
    [syCondition unlockWithCondition:LOCK_CONDITION_HAVEDATA];
    
    [sB release];
    [fB release];
}

- (void)retriveObject:(NSFetchRequest *)request success:(retriveBlock)rBlock failed:(failedBlock)fBlock
{
  
    retriveBlock rB  = [rBlock copy];
    failedBlock  fB  = [fBlock copy];
    NSNumber *type = [NSNumber numberWithInt:COMMAND_RETRIVE];
    NSDictionary *command = [NSDictionary dictionaryWithObjectsAndKeys:type, COMMAND_TYPE_KEY, rB, RETRIVE_BLOCK_KEY, fB, FAILED_BLOCK_KEY, request, COMMAND_REQUEST_KEY, nil];
    
    [rB release];
    [fB release];

    NSLog(@"~~~~~~~~~~ %d",[syCondition tryLock]);
//    [syCondition lock];
    [commandArray addObject:command];
    [syCondition unlockWithCondition:LOCK_CONDITION_HAVEDATA];
}

@end
