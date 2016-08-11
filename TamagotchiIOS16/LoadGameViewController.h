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
#import "Constants.h"

@interface LoadGameViewController : UIViewController {
    
}
@property (strong, nonatomic) IBOutlet UIButton *slot1View;
@property (strong, nonatomic) IBOutlet UIButton *slot1Content;
@property (strong, nonatomic) IBOutlet UIImageView *slot1PetImage;
@property (strong, nonatomic) IBOutlet UILabel *slot1Lives;
@property (strong, nonatomic) IBOutlet UILabel *slot1XP;
@property (strong, nonatomic) IBOutlet UILabel *slot1UserName;
@property (strong, nonatomic) IBOutlet UILabel *slot1money;
@property (strong, nonatomic) IBOutlet UILabel *slot1lvl;
@property (strong, nonatomic) IBOutlet UIButton *slot2View;
@property (strong, nonatomic) IBOutlet UIButton *slot2Content;
@property (strong, nonatomic) IBOutlet UIImageView *slot2PetImage;
@property (strong, nonatomic) IBOutlet UILabel *slot2lvl;
@property (strong, nonatomic) IBOutlet UILabel *slot2Lives;
@property (strong, nonatomic) IBOutlet UILabel *slot2XP;
@property (strong, nonatomic) IBOutlet UILabel *slot2UserName;
@property (strong, nonatomic) IBOutlet UILabel *slot2money;
@property (strong, nonatomic) IBOutlet UIButton *slot3View;
@property (strong, nonatomic) IBOutlet UIButton *slot3Content;
@property (strong, nonatomic) IBOutlet UIImageView *slot3PetImage;
@property (strong, nonatomic) IBOutlet UILabel *slot3Lives;
@property (strong, nonatomic) IBOutlet UILabel *slot3UserName;
@property (strong, nonatomic) IBOutlet UILabel *slot3XP;
@property (strong, nonatomic) IBOutlet UILabel *slot3money;
@property (strong, nonatomic) IBOutlet UIButton *slot4View;
@property (strong, nonatomic) IBOutlet UIButton *slot4Content;
@property (strong, nonatomic) IBOutlet UILabel *slot3lvl;
@property (strong, nonatomic) IBOutlet UIImageView *slot4PetImage;
@property (strong, nonatomic) IBOutlet UILabel *slot4Lives;
@property (strong, nonatomic) IBOutlet UILabel *slot4XP;
@property (strong, nonatomic) IBOutlet UILabel *slot4lvl;
@property (strong, nonatomic) IBOutlet UILabel *slot4UserName;
@property (strong, nonatomic) IBOutlet UILabel *slot4money;
@property (strong, nonatomic) UIButton *selectedView;
@property (strong, nonatomic) NSString *selectedSlot;
@property (strong, nonatomic) IBOutlet UIButton *loadButton;
@property (strong, nonatomic) IBOutlet UIButton *deleteButton;
@property (strong, nonatomic) IBOutlet UIButton *createButton;

@property (strong, nonatomic) UILabel *selectedUserName;
@property (strong, nonatomic) UIImageView *selectedPetImage;

@property (nonatomic) BOOL slot1isDead;
@property (nonatomic) BOOL slot2isDead;
@property (nonatomic) BOOL slot3isDead;
@property (nonatomic) BOOL slot4isDead;

- (IBAction)deleteSlot:(UIButton *)sender;
- (IBAction)slot1pressed:(UIButton *)sender;
- (IBAction)slot2pressed:(UIButton *)sender;
- (IBAction)slot3pressed:(UIButton *)sender;
- (IBAction)slot4pressed:(UIButton *)sender;
- (IBAction)empty1pressed:(UIButton *)sender;
- (IBAction)empty2pressed:(UIButton *)sender;
- (IBAction)empty3pressed:(UIButton *)sender;
- (IBAction)empty4pressed:(UIButton *)sender;




@end
