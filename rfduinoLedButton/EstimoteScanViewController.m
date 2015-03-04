//
//  EstimoteScanViewController.m
//  rfduinoLedButton
//
//  Created by Cass Pangell on 2/25/15.
//  Copyright (c) 2015 OpenSourceRF. All rights reserved.
//

#import "EstimoteScanViewController.h"
#import "ESTBeaconManager.h"
#import "RFduino.h"
#import "AppViewController.h"

@interface EstimoteScanViewController ()

@property (nonatomic, copy)     void (^completion)(ESTBeacon *);
@property (nonatomic, assign)   ESTScanType scanType;

@property (nonatomic, strong) ESTBeaconManager *beaconManager;
@property (nonatomic, strong) ESTBeaconRegion *region;
@property (nonatomic, strong) NSArray *beaconsArray;

@end

@implementation EstimoteScanViewController

- (id)initWithScanType:(ESTScanType)scanType andRFDuino:(RFduino *)duino {
    
    self = [super init];
    if (self)
    {
        self.scanType = scanType;
        self.rfduino = duino;
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
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"Disconnect" style:UIButtonTypeSystem target:self action:@selector(disconnect:)];
    [[self navigationItem] setLeftBarButtonItem:backItem];
    UIBarButtonItem *selectItem = [[UIBarButtonItem alloc] initWithTitle:@"Select" style:UIButtonTypeSystem target:self action:@selector(selectBeacons:)];
    [[self navigationItem] setRightBarButtonItem:selectItem];
    
    _cellSelected = [NSMutableArray array];
    
    //Estimote Beacons
    self.beaconManager = [[ESTBeaconManager alloc] init];
    self.beaconManager.delegate = self;
    self.beaconManager.returnAllRangedBeaconsAtOnce = YES;
   // self.scanType = ESTScanTypeBeacon;
    self.region = [[ESTBeaconRegion alloc] initWithProximityUUID:ESTIMOTE_PROXIMITY_UUID
                                                      identifier:@"EstimoteSampleRegion"];
    /*
     * Starts looking for Estimote beacons.
     * All callbacks will be delivered to beaconManager delegate.
     */
    if (self.scanType == ESTScanTypeBeacon)
    {
        [self startRangingBeacons];
    }
    else
    {
        [self.beaconManager startEstimoteBeaconsDiscoveryForRegion:self.region];
    }
}

#pragma mark - Methods
- (IBAction)disconnect:(id)sender
{
    [_rfduino disconnect];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)selectBeacons:(id)sender{
    AppViewController *viewController = [[AppViewController alloc] initWithBeacon:_cellSelected andRFDuino:_rfduino];
    [self.navigationController pushViewController:viewController animated:YES];
}


#pragma mark - ESTBeaconManager delegate


- (void)beaconManager:(ESTBeaconManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (self.scanType == ESTScanTypeBeacon)
    {
        [self startRangingBeacons];
    }
}

-(void)startRangingBeacons
{

    if ([ESTBeaconManager authorizationStatus] == kCLAuthorizationStatusNotDetermined)
    {
        if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1) {
            /*
             * No need to explicitly request permission in iOS < 8, will happen automatically when starting ranging.
             */
            [self.beaconManager startRangingBeaconsInRegion:self.region];
        } else {
            /*
             * Request permission to use Location Services. (new in iOS 8)
             * We ask for "always" authorization so that the Notification Demo can benefit as well.
             * Also requires NSLocationAlwaysUsageDescription in Info.plist file.
             *
             * For more details about the new Location Services authorization model refer to:
             * https://community.estimote.com/hc/en-us/articles/203393036-Estimote-SDK-and-iOS-8-Location-Services
             */
            [self.beaconManager requestAlwaysAuthorization];
        }
    }
    else if([ESTBeaconManager authorizationStatus] == kCLAuthorizationStatusAuthorized)
    {
        [self.beaconManager startRangingBeaconsInRegion:self.region];
    }
    else if([ESTBeaconManager authorizationStatus] == kCLAuthorizationStatusDenied)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location Access Denied"
                                                        message:@"You have denied access to location services. Change this in app settings."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        
        [alert show];
    }
    else if([ESTBeaconManager authorizationStatus] == kCLAuthorizationStatusRestricted)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location Not Available"
                                                        message:@"You have no access to location services."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        
        [alert show];
    }

}

- (void)beaconManager:(ESTBeaconManager *)manager rangingBeaconsDidFailForRegion:(ESTBeaconRegion *)region withError:(NSError *)error
{
    UIAlertView* errorView = [[UIAlertView alloc] initWithTitle:@"Ranging error"
                                                        message:error.localizedDescription
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    
    [errorView show];
}

- (void)beaconManager:(ESTBeaconManager *)manager monitoringDidFailForRegion:(ESTBeaconRegion *)region withError:(NSError *)error
{
    UIAlertView* errorView = [[UIAlertView alloc] initWithTitle:@"Monitoring error"
                                                        message:error.localizedDescription
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    
    [errorView show];
}

- (void)beaconManager:(ESTBeaconManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(ESTBeaconRegion *)region
{
    self.beaconsArray = [[NSArray alloc] initWithArray:beacons];
    [self.tableView reloadData];
}

- (void)beaconManager:(ESTBeaconManager *)manager didDiscoverBeacons:(NSArray *)beacons inRegion:(ESTBeaconRegion *)region
{
    self.beaconsArray = [[NSArray alloc] initWithArray:beacons];
    [self.tableView reloadData];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.beaconsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (! cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];

    }

    ESTBeacon *beacon = [self.beaconsArray objectAtIndex:indexPath.row];
    
    if ([_cellSelected containsObject:beacon]) {
        [cell setBackgroundColor:[UIColor redColor]];
    }else{
        [cell setBackgroundColor:[UIColor clearColor]];
    }
    
    if ([beacon.major integerValue] != 1) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"Distance: %.2f", [beacon.distance floatValue]];
        cell.textLabel.text = [NSString stringWithFormat:@"Major: %@ Minor: %@", [beacon major], [beacon minor]];
        cell.imageView.image = [UIImage imageNamed:@"beacon_linear.png"];
    }

   
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _beacon = [_beaconsArray objectAtIndex:[indexPath row]];
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //the below code will allow multiple selection
    if ([_cellSelected containsObject:_beacon])
    {
        [_cellSelected removeObject:_beacon];
    }
    else
    {
        [_cellSelected addObject:_beacon];
    }
    
    NSLog(@"%@", _cellSelected);
    [tableView reloadData];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    /*
     *Stops ranging after exiting the view.
     */
    [self.beaconManager stopRangingBeaconsInRegion:self.region];
    [self.beaconManager stopEstimoteBeaconDiscovery];
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
