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

#import <UIKit/UIKit.h>

#import "RFduino.h"
#import "ESTBeacon.h"
#import "ESTBeaconManager.h"

@interface AppViewController : UIViewController<RFduinoDelegate, ESTBeaconManagerDelegate>
{
    __weak IBOutlet UILabel *label1;
    __weak IBOutlet UIButton *button1;
    
    __weak IBOutlet UILabel *label2;
    __weak IBOutlet UIImageView *image1;
    
    UIImage *off;
    UIImage *on;
    
    int R;
    int G;
    int B;
}

@property(strong, nonatomic) RFduino *rfduino;
@property(strong, nonatomic) ESTBeacon *beacon;
@property(strong, nonatomic) NSArray *beaconArray;
@property(strong, nonatomic) NSMutableDictionary *beaconDict;
@property (nonatomic, strong) ESTBeaconManager  *beaconManager;
@property (nonatomic, strong) ESTBeaconRegion   *beaconRegion;
@property(nonatomic) IBOutlet UILabel *majorLabel;
@property(nonatomic) IBOutlet UILabel *minorLabel;
@property(nonatomic) IBOutlet UILabel *rfLabel;


- (IBAction)buttonTouchDown:(id)sender;
- (IBAction)buttonTouchUpInside:(id)sender;

- (id)initWithBeacon:(NSArray*)estimotes andRFDuino:(RFduino *)duino;

@end
