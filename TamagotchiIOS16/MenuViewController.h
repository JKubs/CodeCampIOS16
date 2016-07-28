//
//  MenuViewController.h
//  TamagotchiIOS16
//
//  Created by Codecamp on 27.07.16.
//  Copyright © 2016 Codecamp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameViewController.h"
#import "Owner.h"
#import "Pet.h"
#import "Loader.h"
#import "Saver.h"

@interface MenuViewController : UIViewController  {
    
}

@property (strong, nonatomic) IBOutlet UIButton *continueButton;

- (IBAction)continueGame:(UIButton *)sender;
- (IBAction)loadGame:(UIButton *)sender;
- (IBAction)newGame:(UIButton *)sender;

@end