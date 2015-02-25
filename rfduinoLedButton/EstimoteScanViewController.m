//
//  EstimoteScanViewController.m
//  rfduinoLedButton
//
//  Created by Cass Pangell on 2/25/15.
//  Copyright (c) 2015 OpenSourceRF. All rights reserved.
//

#import "EstimoteScanViewController.h"
#import "ESTBeaconManager.h"

@interface EstimoteScanViewController ()

@property (nonatomic, copy)     void (^completion)(ESTBeacon *);
@property (nonatomic, assign)   ESTScanType scanType;

@property (nonatomic, strong) ESTBeaconManager *beaconManager;
@property (nonatomic, strong) ESTBeaconRegion *region;
@property (nonatomic, strong) NSArray *beaconsArray;

@end

@implementation EstimoteScanViewController

- (id)initWithScanType:(ESTScanType)scanType completion:(void (^)(ESTBeacon *))completion
{
    self = [super init];
    if (self)
    {
        self.scanType = scanType;
        self.completion = [completion copy];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_rfduino setDelegate:self];
    
    //TableView
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    
    // Custom initialization
    UIButton *backButton = [UIButton buttonWithType:101];  // left-pointing shape
    [backButton setTitle:@"Disconnect" forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(disconnect:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [[self navigationItem] setLeftBarButtonItem:backItem];
    
    //Estimote Beacons
    self.beaconManager = [[ESTBeaconManager alloc] init];
    self.beaconManager.delegate = self;
    self.beaconManager.returnAllRangedBeaconsAtOnce = YES;
    
    self.region = [[ESTBeaconRegion alloc] initWithProximityUUID:ESTIMOTE_PROXIMITY_UUID
                                                      identifier:@"EstimoteSampleRegion"];
}

#pragma mark - Arduino Methods
- (IBAction)disconnect:(id)sender
{
    [_rfduino disconnect];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (! cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];

    }
    
   // cell.textLabel.text = text;
   // cell.detailTextLabel.text = detail;
   // cell.detailTextLabel.numberOfLines = 3;
   
    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
