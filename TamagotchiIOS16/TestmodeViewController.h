//
// TestmodeViewController.h
//  TamagotchiIOS16
//
//  Created by Codecamp on 25.07.16.
//  Copyright © 2016 Codecamp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TestmodeViewController : UIViewController{
    IBOutlet UITextView *nextNotiText;
}
- (IBAction)sendNotification:(id)sender;
- (IBAction)refreshNoti:(id)sender;
- (IBAction)genRandNoti:(id)sender;
- (IBAction)resetNotis:(id)sender;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;


@end