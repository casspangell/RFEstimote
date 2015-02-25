//
//  EstimoteScanViewController.m
//  rfduinoLedButton
//
//  Created by Cass Pangell on 2/25/15.
//  Copyright (c) 2015 OpenSourceRF. All rights reserved.
//

#import "EstimoteScanViewController.h"

@interface EstimoteScanViewController ()

@end

@implementation EstimoteScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_rfduino setDelegate:self];
    
    // Custom initialization
    UIButton *backButton = [UIButton buttonWithType:101];  // left-pointing shape
    [backButton setTitle:@"Disconnect" forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(disconnect:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [[self navigationItem] setLeftBarButtonItem:backItem];
}

- (IBAction)disconnect:(id)sender
{
    [_rfduino disconnect];
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
