//
//  GameOverController.h
//  TamagotchiIOS16
//
//  Created by Codecamp on 29.07.16.
//  Copyright © 2016 Codecamp. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "Pet.h"

@interface GameOverController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *petImage;
@property (weak, nonatomic) Pet *pet;

@end