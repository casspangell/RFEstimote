//
//  EstimoteScanViewController.h
//  rfduinoLedButton
//
//  Created by Cass Pangell on 2/25/15.
//  Copyright (c) 2015 OpenSourceRF. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RFduino.h"
#import "ESTBeacon.h"
#import "ESTBeaconManager.h"

typedef enum : int
{
    ESTScanTypeBluetooth,
    ESTScanTypeBeacon
    
} ESTScanType;

@interface EstimoteScanViewController : UIViewController <RFduinoDelegate, ESTBeaconManagerDelegate, UITableViewDelegate, UITableViewDataSource> {
    
}

@property(strong, nonatomic) RFduino *rfduino;

@property(strong) IBOutlet UITableView *tableView;

/*
 * Selected beacon is returned on given completion handler.
 */
- (id)initWithScanType:(ESTScanType)scanType completion:(void (^)(ESTBeacon *))completion;

@end
