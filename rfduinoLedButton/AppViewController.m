/*
 Copyright (c) 2013 OpenSourceRF.com.  All right reserved.
 
 This library is free software; you can redistribute it and/or
 modify it under the terms of the GNU Lesser General Public
 License as published by the Free Software Foundation; either
 version 2.1 of the License, or (at your option) any later version.
 
 This library is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 See the GNU Lesser General Public License for more details.
 
 You should have received a copy of the GNU Lesser General Public
 License along with this library; if not, write to the Free Software
 Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
 IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
 CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
 TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
 SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

#import <QuartzCore/QuartzCore.h>


#import "AppViewController.h"
#import "ESTBeaconManager.h"

@implementation AppViewController

+ (void)load
{
    // customUUID = @"c97433f0-be8f-4dc8-b6f0-5343e6100eb4";
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

        // Custom initialization
        UIButton *backButton = [UIButton buttonWithType:101];  // left-pointing shape
        [backButton setTitle:@"Disconnect" forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(disconnect:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        [[self navigationItem] setLeftBarButtonItem:backItem];

    }
    return self;
}

- (id)initWithBeacon:(NSArray*)estimotes andRFDuino:(RFduino *)duino {
    
    self = [super init];
    if (self)
    {
        self.beacon = [estimotes objectAtIndex:0];
        _beaconArray = estimotes;
        self.rfduino = duino;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //[_majorLabel setText:[NSString stringWithFormat:@"%@", [_beacon major]]];
    //[_minorLabel setText:[NSString stringWithFormat:@"%@", [_beacon minor]]];
    [_rfLabel setText:[_rfduino name]];
    
    [_rfduino setDelegate:self];
    
    UIColor *start = [UIColor colorWithRed:58/255.0 green:108/255.0 blue:183/255.0 alpha:0.15];
    UIColor *stop = [UIColor colorWithRed:58/255.0 green:108/255.0 blue:183/255.0 alpha:0.45];
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    //gradient.frame = [self.view bounds];
    gradient.frame = CGRectMake(0.0, 0.0, 1024.0, 1024.0);
    gradient.colors = [NSArray arrayWithObjects:(id)start.CGColor, (id)stop.CGColor, nil];
    [self.view.layer insertSublayer:gradient atIndex:0];
    
    /*
     * BeaconManager setup.
     */
    self.beaconManager = [[ESTBeaconManager alloc] init];
    self.beaconManager.delegate = self;
    
    self.beaconRegion = [[ESTBeaconRegion alloc] initWithProximityUUID:self.beacon.proximityUUID
                                                                 major:[self.beacon.major unsignedIntValue]
                                                                 minor:[self.beacon.minor unsignedIntValue]
                                                            identifier:@"RegionIdentifier"
                                                               secured:self.beacon.isSecured];
    
    [self.beaconManager startRangingBeaconsInRegion:self.beaconRegion];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)disconnect:(id)sender
{
    [_rfduino disconnect];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)sendByte:(uint8_t)byte
{
    uint8_t tx[1] = { byte };
    NSData *data = [NSData dataWithBytes:(void*)&tx length:1];
    [_rfduino send:data];
}

- (IBAction)buttonTouchDown:(id)sender
{
    [self sendByte:1];
}

- (IBAction)buttonTouchUpInside:(id)sender
{
    [self sendByte:0];
}

- (void)didReceive:(NSData *)data
{
    NSLog(@"RecievedData");
    
    const uint8_t *value = [data bytes];
    // int len = [data length];

    NSLog(@"value = %x", value[0]);
    
    if (value[0])
        [image1 setImage:on];
    else
        [image1 setImage:off];
}

#pragma mark - ESTBeaconManager delegate

- (void)beaconManager:(ESTBeaconManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(ESTBeaconRegion *)region
{
    ESTBeacon *firstBeacon = [beacons firstObject];
    
    [self updateDotPositionForDistance:[firstBeacon.distance floatValue]];
}

- (void)updateDotPositionForDistance:(float)distance
{
    NSLog(@"distance: %f", distance);
    
    float value = 255*distance;

    if (value > 255) {
        int new = 255 - value;
        value = new;
    }
    
    if (value < 0) {
        value = value*-1;
    }
    
    NSInteger intValue = floor(value);
    
    NSLog(@"%d %d %d", intValue, intValue, intValue);
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    [arr addObject:[NSNumber numberWithInteger:intValue]];

    
    int length = [arr count];

    [self sendByte:arr];

    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self.beaconManager stopRangingBeaconsInRegion:self.beaconRegion];
}

@end
