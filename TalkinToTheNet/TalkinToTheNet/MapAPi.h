//
//  MapAPi.h
//  TalkinToTheNet
//
//  Created by Christian Maldonado on 10/2/15.
//  Copyright © 2015 Mike Kavouras. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface MapAPi : NSObject

+ (void)searchFoursquarePlacesForTerm:(NSString *)term
                             location:(CLLocationCoordinate2D)location
                    completionHandler:(void(^)(id response, NSError *error))handler;


@end
