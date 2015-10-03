//
//  ViewController.m
//  TalkinToTheNet
//
//  Created by Michael Kavouras on 9/20/15.
//  Copyright © 2015 Mike Kavouras. All rights reserved.
//

#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "ViewController.h"
#import "MapAPi.h"

@interface ViewController ()
<
UITextFieldDelegate,
MKMapViewDelegate
>


@property (weak, nonatomic) IBOutlet UITextField *searchTextField;

@property (strong, nonatomic) IBOutlet MKMapView *mapView;

//@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic) NSMutableArray *searchResults;

@property (nonatomic) CLLocationManager *locationManager;

@property (nonatomic) BOOL firstTime;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.firstTime = YES;
    
    self.mapView.delegate = self;
    
    // set the delegate of `self.searchTextField` to `self`
    self.searchTextField.delegate = self;
    
    self.locationManager = [[CLLocationManager alloc] init];
    
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
}

- (void)performSearch {
    [self.view endEditing:YES];
    
    MKUserLocation *userLocation = self.mapView.userLocation;
    [MapAPi searchFoursquarePlacesForTerm:self.searchTextField.text
                                 location:userLocation.coordinate
                        completionHandler:^(id response, NSError *error) {
                                          
                                          self.searchResults = response[@"response"][@"venues"];
                                          [self updateMap];
                                          
                                      }];
}

- (void)updateMap {
    
    // removes all previous pins
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    for (NSDictionary *venue in self.searchResults) {
        [self addMapAnnotationForVenue:venue];
    }
}

- (void)addMapAnnotationForVenue:(NSDictionary *)venue {
    
    MKPointAnnotation *mapPin = [[MKPointAnnotation alloc] init];
    
    double lat = [venue[@"location"][@"lat"] doubleValue];
    double lng = [venue[@"location"][@"lng"] doubleValue];
    CLLocationCoordinate2D latLng = CLLocationCoordinate2DMake(lat, lng);
    
    mapPin.coordinate = latLng;
    mapPin.title = venue[@"name"];
    
    NSArray *categories = venue[@"categories"];
    if (categories.count > 0) {
        NSDictionary *firstCategory = categories[0]; // grab the first category
        mapPin.subtitle = firstCategory[@"name"]; // grab the name for the first category
    }
    
    [self.mapView addAnnotation:mapPin];
}

# pragma mark - IBAction

// called when the user taps the search button
- (IBAction)searchButtonTapped:(id)sender {
    [self performSearch];
}

#pragma mark - Text field delegate

// called when the user taps the return key on the keyboard
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self performSearch];
    return YES;
}

#pragma mark - Map view delegate

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    if (self.firstTime) {
        self.firstTime = NO;
        MKCoordinateSpan span = MKCoordinateSpanMake(0.1, 0.1);
        [self.mapView setRegion:MKCoordinateRegionMake(userLocation.coordinate, span)];
    }
}

@end
