//
//  NetworkingController.h
//  sfHackVT
//
//  Created by Joshua Barry on 10/10/14.
//
//

#import <Foundation/Foundation.h>

// Implements an extension on the NSURLConnectionDataDelegate and NSURLConnectionDelegate
// Uses a Default NSObject subclass.
@interface NetworkingController : NSObject <NSURLConnectionDataDelegate, NSURLConnectionDelegate>

// Initialize our response and request instances
// ResponseData is a JSON encoded dictionary retrieved from the WebAPI.
@property (nonatomic, strong) NSMutableData *responseData;
// requestType is a special string/int 'code' that we will send to the
// WebAPI in order to determine the request type.
@property (nonatomic, strong) NSString *requestType;

+(NetworkingController*)sharedNetworkingController;

// Define some networking methods
-(void)getDataFromServer;

@end
