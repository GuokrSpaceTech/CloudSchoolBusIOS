// ----------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// ----------------------------------------------------------------------------
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import "TodoService.h"
#import <WindowsAzureMobileServices/WindowsAzureMobileServices.h>


#pragma mark * Private interace


@interface TodoService()

@property (nonatomic, strong)   MSTable *table;
@property (nonatomic)           NSInteger busyCount;

@end


#pragma mark * Implementation


@implementation TodoService

@synthesize items;

-(TodoService *) initWithName:(NSString *)name
{
    // Initialize the Mobile Service client with your URL and key
    MSClient *newClient = [MSClient clientWithApplicationURLString:@"https://mactopms.azure-mobile.net/"
                                                withApplicationKey:@"HuyMicRWjHXVhdqpLHfclPTnftuxRr24"];
    
    // Add a Mobile Service filter to enable the busy indicator
    self.client = [newClient clientwithFilter:self];
    
    // Create an MSTable instance to allow us to work with the TodoItem table
    self.table = [_client getTable:name];
    
    NSMutableArray *arr=[[NSMutableArray alloc]init];
    
    self.items = arr;
    self.busyCount = 0;
    
    return self;
}
- (void)testQuery:(NSPredicate *)predicate msgOffset:(int)offset Limit :(int)limit  OnSuccess:(CompletionWithArrayBlock)completion{
    
    MSQuery *qurey = [[[MSQuery alloc] initWithTable:self.table withPredicate:predicate] autorelease];
    [qurey setFetchOffset:offset];
    [qurey setFetchLimit:limit];
    [qurey orderByDescending:@"SendDate"];
    
    [qurey readWithCompletion:^(NSArray *items, NSInteger totalCount, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
            completion(nil);
            return ;
        }
        completion(items);
    }];
    
}

-(void)dealloc
{
    self.items=nil;
    self.client=nil;
    [super dealloc];
}

- (void) refreshDataOnSuccess:(CompletionBlock) completion predicate:(NSPredicate *)pred;
{
    // Create a predicate that finds items where complete is false
    
    
    // Query the TodoItem table and update the items property with the results from the service
    [self.table readWhere:pred completion:^(NSArray *results, NSInteger totalCount, NSError *error) {
        
        [self logErrorIfNotNil:error];
        
        items = [results mutableCopy];
        
        // Let the caller know that we finished
        completion(error);
    }];
    
    
    
    // Create a predicate that finds active items in which complete is false
//    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"complete == NO"];
//    
//    
//    // Retrieve the MSTable's MSQuery instance with the predicate you just created.
//    MSQuery * query = [self.table queryWhere:predicate];
//    
//    
//    query.includeTotalCount = TRUE; // Request the total item count
//    
//    
//    // Start with the first item, and retrieve only three items
//    query.fetchOffset = 0;
//    query.fetchLimit = 3;
//    
//    
//    // Invoke the MSQuery instance directly, rather than using the MSTable helper methods.
//    [query readWithCompletion:^(NSArray *results, NSInteger totalCount, NSError *error) {
//        
//        
//        [self logErrorIfNotNil:error];
//        if (!error)
//        {
//            // Log total count.
//            NSLog(@"Total item count: %@",[NSString stringWithFormat:@"%zd", (ssize_t) totalCount]);
//        }
//        
//        
//        items = [results mutableCopy];
//        
//        NSLog(@"%@",items);
//        
//        
//        // Let the caller know that we finished
//        completion();
//        
//        
//    }];

}
 
-(void) addItem:(NSDictionary *)item completion:(CompletionWithIndexBlock)completion
{
    // Insert the item into the TodoItem table and add to the items array on completion
    [self.table insert:item completion:^(NSDictionary *result, NSError *error) {
        
        [self logErrorIfNotNil:error];
        
        NSUInteger index = [items count];
        [(NSMutableArray *)items insertObject:result atIndex:index];
        
        // Let the caller know that we finished
        completion(index);
    }];
}

-(void) updateItem:(NSDictionary *)item completion:(CompletionWithIndexBlock)completion
{
    // Insert the item into the TodoItem table and add to the items array on completion
    [self.table update:item completion:^(NSDictionary *result,NSError *error){
        
        [self logErrorIfNotNil:error];
        
        NSUInteger index = [items count];
        //[(NSMutableArray *)items insertObject:result atIndex:index];
        
        // Let the caller know that we finished
        completion(index);
    }];
}

-(void) completeItem:(NSDictionary *)item completion:(CompletionWithIndexBlock)completion
{
    // Cast the public items property to the mutable type (it was created as mutable)
    NSMutableArray *mutableItems = (NSMutableArray *) items;
    
    // Set the item to be complete (we need a mutable copy)
    NSMutableDictionary *mutable = [item mutableCopy];
    [mutable setObject:@(YES) forKey:@"complete"];
    
    // Replace the original in the items array
    NSUInteger index = [items indexOfObjectIdenticalTo:item];
    [mutableItems replaceObjectAtIndex:index withObject:mutable];
    
    // Update the item in the TodoItem table and remove from the items array on completion
    [self.table update:mutable completion:^(NSDictionary *item, NSError *error) {
        
        [self logErrorIfNotNil:error];
        
        NSUInteger index = [items indexOfObjectIdenticalTo:mutable];
        [mutableItems removeObjectAtIndex:index];
        
        // Let the caller know that we have finished
        completion(index);
    }];
}

- (void) busy:(BOOL) busy
{
    // assumes always executes on UI thread
    if (busy) {
        if (self.busyCount == 0 && self.busyUpdate != nil) {
            self.busyUpdate(YES);
        }
        self.busyCount ++;
    }
    else
    {
        if (self.busyCount == 1 && self.busyUpdate != nil) {
            self.busyUpdate(FALSE);
        }
        self.busyCount--;
    }
}

- (void) logErrorIfNotNil:(NSError *) error
{
    if (error) {
        NSLog(@"ERROR %@", error);
    }
}


#pragma mark * MSFilter methods


- (void) handleRequest:(NSURLRequest *)request
                onNext:(MSFilterNextBlock)onNext
            onResponse:(MSFilterResponseBlock)onResponse
{
    // A wrapped response block that decrements the busy counter
    MSFilterResponseBlock wrappedResponse = ^(NSHTTPURLResponse *response, NSData *data, NSError *error) {
        [self busy:NO];
        onResponse(response, data, error);
    };
    
    // Increment the busy counter before sending the request
    [self busy:YES];
    onNext(request, wrappedResponse);
}

@end
