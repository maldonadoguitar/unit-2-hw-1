//
//  APIManager.h
//  learnAPI2
//
//  Created by Christian Maldonado on 9/20/15.
//  Copyright © 2015 Christian Maldonado. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APIManager : NSObject

+(void)GETRequestWithURL:(NSURL *)URL
       completionHandler:(void(^)(NSData *, NSURLResponse *, NSError *))
completionHandler;

@end
