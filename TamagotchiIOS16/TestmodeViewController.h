//
// TestmodeViewController.h
//  TamagotchiIOS16
//
//  Created by Codecamp on 25.07.16.
//  Copyright © 2016 Codecamp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Food.h"
#import "Pet.h"
#import "Saver.h"
#import "NotificationRequest.h"
#import "GameViewController.h"

@interface TestmodeViewController : UIViewController{
    IBOutlet UITextView *nextNotiText;
}
- (IBAction)sendNotification:(id)sender;
- (IBAction)genRandNoti:(id)sender;
- (IBAction)resetNotis:(id)sender;
- (void)refreshNoti;
- (int)calcStuff:(int)n;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong, nonatomic) Pet *pet;
@property (strong, nonatomic) NSArray *foodList;
@property (strong, nonatomic) NSArray *drinkList;
@property (strong, nonatomic) NSArray *notificationRequests;
@property (strong, nonatomic) GameViewController *gameController;

@end