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
@property (strong, nonatomic) IBOutlet UIButton *slot1View;
@property (strong, nonatomic) IBOutlet UIImageView *slot1PetImage;
@property (strong, nonatomic) IBOutlet UILabel *slot1Lives;
@property (strong, nonatomic) IBOutlet UILabel *slot1UserName;
@property (strong, nonatomic) IBOutlet UILabel *slot1money;
@property (strong, nonatomic) IBOutlet UIButton *slot2View;
@property (strong, nonatomic) IBOutlet UIImageView *slot2PetImage;
@property (strong, nonatomic) IBOutlet UILabel *slot2Lives;
@property (strong, nonatomic) IBOutlet UILabel *slot2UserName;
@property (strong, nonatomic) IBOutlet UILabel *slot2money;
@property (strong, nonatomic) IBOutlet UIButton *slot3View;
@property (strong, nonatomic) IBOutlet UIImageView *slot3PetImage;
@property (strong, nonatomic) IBOutlet UILabel *slot3Lives;
@property (strong, nonatomic) IBOutlet UILabel *slot3UserName;
@property (strong, nonatomic) IBOutlet UILabel *slot3money;
@property (strong, nonatomic) IBOutlet UIButton *slot4View;
@property (strong, nonatomic) IBOutlet UIImageView *slot4PetImage;
@property (strong, nonatomic) IBOutlet UILabel *slot4Lives;
@property (strong, nonatomic) IBOutlet UILabel *slot4UserName;
@property (strong, nonatomic) IBOutlet UILabel *slot4money;
@property (strong, nonatomic) UIButton *selectedView;
@property (strong, nonatomic) NSString *selectedSlot;
@property (strong, nonatomic) IBOutlet UIButton *loadButton;
@property (strong, nonatomic) IBOutlet UIButton *deleteButton;
@property (strong, nonatomic) UIImageView *selectedPetImage;
@property (strong, nonatomic) UILabel *selectedLives;
@property (strong, nonatomic) UILabel *selectedUserName;
@property (strong, nonatomic) UILabel *selectedmoney;

- (IBAction)deleteSlot:(UIButton *)sender;
- (IBAction)slot1Pressed:(UIButton *)sender;
- (IBAction)slot2Pressed:(UIButton *)sender;
- (IBAction)slot3Pressed:(UIButton *)sender;
- (IBAction)slot4Pressed:(UIButton *)sender;


@end
