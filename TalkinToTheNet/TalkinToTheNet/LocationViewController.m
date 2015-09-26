//
//  LocationViewController.m
//  TalkinToTheNet
//
//  Created by Christian Maldonado on 9/22/15.
//  Copyright © 2015 Mike Kavouras. All rights reserved.
//

#import "LocationViewController.h"
#import "APIManager.h"
#import "YelpLocationResults.h"

@interface LocationViewController ()
<
UITableViewDataSource,
UITableViewDelegate,
UITextFieldDelegate
>


@property (strong, nonatomic) IBOutlet UITextField *searchTextField;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic) NSMutableArray *searchResults;

@end

@implementation LocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.searchTextField.delegate = self;
    
}

-(void)makeRequestToYelp:(NSString *)searchTerm
           callBackBlock:(void(^)())block{
    
    
    //url (media=musoc term=searchTerm)
    NSString *urlString = [NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/search?client_id=UKW5E0ASWOBAOVXMI3E3B3KCL1VKOTRMRUPYDF5NKJTIDOW2&client_secret=0V35FJSA4NOW22HIECVJW0KZAVSDCSMMMGSXAKO3B1ON45D5&near=%@&query=Oktoberfest&v=20160101&m=foursquare", searchTerm];
    
    
    
    NSLog(@"%@",urlString);
    
    NSString *encodingString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSLog(@"%@", encodingString);
    
    //convert urlString to url
    NSURL *url = [NSURL URLWithString:encodingString];
    
    //make the request
    [APIManager GETRequestWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if(data != nil){
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
           NSArray *results = [[json objectForKey:@"response"] objectForKey:@"venues"];
            //NSDictionary *results = [json objectForKey:@"response"];
            self.searchResults = [[NSMutableArray alloc]init];
            
            for (NSDictionary *result in results) {
                
                NSString *locationName = [result objectForKey:@"name"];
                NSString *addressName = [[result objectForKey:@"location"] objectForKey:@"address"];
                
                YelpLocationResults *beerLocation = [[YelpLocationResults alloc]init];
                beerLocation.locations = locationName;
                beerLocation.addresses = addressName;

                
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
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier" forIndexPath:indexPath];
    YelpLocationResults *currentResults = self.searchResults[indexPath.row];
    
    cell.textLabel.text = currentResults.locations;
    cell.detailTextLabel.text = currentResults.addresses;

    return cell;
}

#pragma mark - text field delegate


-(BOOL)textFieldShouldReturn:(UITextField *)textField{
   
    [self.view endEditing:YES];
    
    [self makeRequestToYelp:textField.text callBackBlock:^{
        
        [self.tableView reloadData];
    }];
    return YES;
}

@end
