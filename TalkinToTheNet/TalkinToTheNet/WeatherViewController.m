//
//  WeatherViewController.m
//  TalkinToTheNet
//
//  Created by Christian Maldonado on 9/22/15.
//  Copyright © 2015 Mike Kavouras. All rights reserved.
//

#import "WeatherViewController.h"
#import "APIManager.h"
#import "WeatherSearchResults.h"

@interface WeatherViewController ()
<
UITableViewDataSource,
UITableViewDelegate,
UITextFieldDelegate
>

//@property (strong, nonatomic) IBOutlet UIView *viewThisShit;
@property (strong, nonatomic) IBOutlet UITextField *searchTextField;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic) NSMutableArray *searchResults;

@end

@implementation WeatherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.searchTextField.delegate = self;
    
}


-(void)makeRequestToWeather:(NSString *)searchTerm
           callBackBlock:(void(^)())block{
    
    
   // url (media=musoc term=searchTerm)
    NSString *urlString = [NSString stringWithFormat:@"http://api.wunderground.com/api/958e4651cb1799db/conditions/q/CA/%@.json", searchTerm];
    
//    NSString *urlString = [NSString stringWithFormat:@"http://autocomplete.wunderground.com/aq?query=%@", searchTerm];
//    
    
    NSLog(@"%@",urlString);
    
    NSString *encodingString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSLog(@"%@", encodingString);
    
    //convert urlString to url
    NSURL *url = [NSURL URLWithString:encodingString];
    
    //make the request
    [APIManager GETRequestWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if(data != nil){
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            NSArray *results = [[json objectForKey:@"results"] objectForKey:@"response"];
            //NSArray *results = [json objectForKey:@"results"];
            self.searchResults = [[NSMutableArray alloc]init];
            
            
            for (NSDictionary *result in results) {
                
                NSString *locationName = [result objectForKey:@"name"];
               // NSString *addressName = [[result objectForKey:@"location"] objectForKey:@"address"];
                
                WeatherSearchResults *beerLocation = [[WeatherSearchResults alloc]init];
                beerLocation.localWeather = locationName;
                //beerLocation.localWeather = addressName;
                
                
                [self.searchResults addObject:beerLocation];
                
            }
            
            block();
        }
    }];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.searchResults.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WeatherCellIdentifier" forIndexPath:indexPath];
    WeatherSearchResults *currentResults = self.searchResults[indexPath.row];
    
    cell.textLabel.text = currentResults.localWeather;
    //cell.detailTextLabel.text = currentResults.addresses;
    
    return cell;
}

#pragma mark - weather text field delegate


-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [self.view endEditing:YES];
    
    [self makeRequestToWeather:textField.text callBackBlock:^{
        
        [self.tableView reloadData];
    }];
    return YES;
}

@end
