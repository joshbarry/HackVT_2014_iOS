//
//  NetworkingController.m
//  sfHackVT
//
//  Created by Joshua Barry on 10/10/14.
//
//

#import "NetworkingController.h"
#import "CoreDataController.h"

@implementation NetworkingController

// -------------------------------------------------------------------------------
// DEFINITIONS FOR OUR WEB-API URL(s) FOR VARIOUS REQUESTS.
// AUTHOR(s): Tyler J. Sawyer
// -------------------------------------------------------------------------------

#define API_URL @"http://hackvt.sternforce.com/mobile/handler.php?bacon=yes"

#define GET_TYPE @"bacon"

// -------------------------------------------------------------------------------

static NetworkingController* theNetworkingController = nil;

+(NetworkingController*)sharedNetworkingController
{
    @synchronized([theNetworkingController class])
    {
        if (theNetworkingController == nil)
            theNetworkingController = [[self alloc] init];
        
        return theNetworkingController;
    }
    return nil;
}
#pragma mark NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // A response has been received, this is where we initialize the instance var you created
    // so that we can append data to it in the didReceiveData method
    // Furthermore, this method is called each time there is a redirect so reinitializing it
    // also serves to clear it
    self.responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // Append the new data to the instance variable you declared
    [self.responseData appendData:data];
    
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}

//------ CALL BACKS
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    if([self.requestType isEqualToString:GET_TYPE])
    {
        [self finishedGettingData];
    }
    
    self.requestType = nil;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    if([self.requestType isEqualToString:GET_TYPE])
    {
        [self failedGettingData];
    }
    
    self.requestType = nil;
}

#pragma mark - Did Received Responses / Custom sMethods

-(void)getDataFromServer
{
    self.requestType = GET_TYPE;
    NSString *getTasksUrl = API_URL;
    
    // Create the request.
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:getTasksUrl] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:10];
    
    // Specify that it will be a GET request
    [request setHTTPMethod: @"GET"];
    
    // This is how we set header fields
    [request setValue:@"application/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    // Tyler : Use the HTTP_METHOD field for displaying data.
    [request addValue:@"bacon" forHTTPHeaderField:@"METHOD"];
    
    // Create url connection and fire request
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    // Tyler : Tell console we are going to request from server.
    NSLog(@"Attempting to send request to server...");
    // Tyler : Check to make sure connection is successful
    if(!conn){
        NSLog(@"ERROR: Failed to send request!");
    } else {
        NSLog(@"SUCCESS: Sent request!");
    } // End Logging
}

-(void)finishedGettingData
{
    NSString *strData = [[NSString alloc]initWithData:self.responseData encoding:NSUTF8StringEncoding];
    
    // Parses the JSON encoded string retrieved from the server and pushes it into
    // an NSMutableDictionary. We should be able to iterate through the dictionary
    // and insert the values into CoreData from here.
    NSError *error = nil;
    if(!error)
    {
        NSData *responseData = [strData dataUsingEncoding:NSASCIIStringEncoding];
        NSMutableDictionary *jsonArray = [NSJSONSerialization JSONObjectWithData: responseData
                                                                         options:kNilOptions
                                                                           error:& error];

        //[[CoreDataController sharedInstance] wipeDatas:@"Tasks"];
        
        // Save JSON to CoreData.
        
        // Grab all the individual Tasks.
        for (NSDictionary *dict in [jsonArray valueForKeyPath:@"Tasks"])
        {
            //Tasks *newTask = [[CoreDataController sharedInstance]insertToCData:@"Tasks"];
            for(NSString *key in [dict allKeys])
            {
                NSLog(@"key=%@ value=%@", key, [dict objectForKey:key]);
                //newTask.taskID = [dict objectForKey:@"taskID"];
                //newTask.taskDesc = [dict objectForKey:@"taskDesc"];
                //newTask.responseType = [dict objectForKey:@"responseType"];
            }
        }
        
        // SAVE all of our data (commit) to CoreData.
        [[CoreDataController sharedInstance] saveContext];
    }
    
    // Tyler : Log so I can see if you're getting datas.
    NSLog(@"Request Complete, received %lu bytes of data",(unsigned long)self.responseData.length);
}

-(void)failedGettingData
{
    NSLog(@"ERROR: Failed to retrieve Data from server!");
}

@end