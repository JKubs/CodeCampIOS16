//
//  LoadGameViewController.h
//  TamagotchiIOS16
//
//  Created by Codecamp on 28.07.16.
//  Copyright © 2016 Codecamp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Saver.h"
#import "Loader.h"

@interface LoadGameViewController : UIViewController {
    
}
@property (strong, nonatomic) IBOutlet UITableViewCell *slot1View;
@property (strong, nonatomic) IBOutlet UIImageView *slot1PetImage;
@property (strong, nonatomic) IBOutlet UILabel *slot1Lives;
@property (strong, nonatomic) IBOutlet UILabel *slot1UserName;
@property (strong, nonatomic) IBOutlet UILabel *slot1money;
@property (strong, nonatomic) IBOutlet UITableViewCell *slot2View;
@property (strong, nonatomic) IBOutlet UIImageView *slot2PetImage;
@property (strong, nonatomic) IBOutlet UILabel *slot2Lives;
@property (strong, nonatomic) IBOutlet UILabel *slot2UserName;
@property (strong, nonatomic) IBOutlet UILabel *slot2money;
@property (strong, nonatomic) IBOutlet UITableViewCell *slot3View;
@property (strong, nonatomic) IBOutlet UIImageView *slot3PetImage;
@property (strong, nonatomic) IBOutlet UILabel *slot3Lives;
@property (strong, nonatomic) IBOutlet UILabel *slot3UserName;
@property (strong, nonatomic) IBOutlet UILabel *slot3money;
@property (strong, nonatomic) IBOutlet UITableViewCell *slot4View;
@property (strong, nonatomic) IBOutlet UIImageView *slot4PetImage;
@property (strong, nonatomic) IBOutlet UILabel *slot4Lives;
@property (strong, nonatomic) IBOutlet UILabel *slot4UserName;
@property (strong, nonatomic) IBOutlet UILabel *slot4money;
- (IBAction)loadSlotToGame:(UIButton *)sender;
- (IBAction)deleteSlot:(UIButton *)sender;

@end
