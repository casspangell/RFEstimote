//
//  EstimoteScanViewController.h
//  rfduinoLedButton
//
//  Created by Cass Pangell on 2/25/15.
//  Copyright (c) 2015 OpenSourceRF. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RFduino.h"

@interface EstimoteScanViewController : UIViewController <RFduinoDelegate> {
    
}

@property(strong, nonatomic) RFduino *rfduino;

@end
