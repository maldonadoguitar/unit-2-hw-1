//
//  MapAPi.m
//  TalkinToTheNet
//
//  Created by Christian Maldonado on 10/2/15.
//  Copyright © 2015 Mike Kavouras. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "MapAPi.h"

#define kFSClientID @"UKW5E0ASWOBAOVXMI3E3B3KCL1VKOTRMRUPYDF5NKJTIDOW2"
#define kFSClientSecret @"0V35FJSA4NOW22HIECVJW0KZAVSDCSMMMGSXAKO3B1ON45D5"


@implementation MapAPi

+ (void)searchFoursquarePlacesForTerm:(NSString *)term
                             location:(CLLocationCoordinate2D)location
                    completionHandler:(void(^)(id response, NSError *error))handler {
    
    /* places search api endpoint
     https://api.foursquare.com/v2/venues/search
     ?client_id=CLIENT_ID
     &client_secret=CLIENT_SECRET
     &v=20130815
     &ll=40.7,-74
     &query=sushi
     &limit=50
     */
    
    NSString *APIBase = @"https://api.foursquare.com";
    NSString *APIVersion = @"v2";
    NSString *APIEndpoint = @"venues/search";
    
    term = [term stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    
    NSString *urlString = [NSString stringWithFormat:@"%@/%@/%@?client_id=%@&client_secret=%@&v=20150927&ll=%f,%f&query=%@&limit=50", APIBase, APIVersion, APIEndpoint, kFSClientID, kFSClientSecret, location.latitude, location.longitude, term];
    
    
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        handler(responseObject, nil);
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        handler(nil, error);
    }];
    
}

@end
