//
//  APIManager.m
//  learnAPI2
//
//  Created by Christian Maldonado on 9/20/15.
//  Copyright © 2015 Christian Maldonado. All rights reserved.
//

#import "APIManager.h"

@implementation APIManager

+(void)GETRequestWithURL:(NSURL *)URL
       completionHandler:(void(^)(NSData *, NSURLResponse *, NSError *))
completionHandler{
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask  *task = [session dataTaskWithURL:URL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSLog(@"%@", data);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completionHandler(data, response, error);
        });
    }];
    
    [task resume];
}


@end
