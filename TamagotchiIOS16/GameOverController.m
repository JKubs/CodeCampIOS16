//
//  GameOverController.m
//  TamagotchiIOS16
//
//  Created by Codecamp on 29.07.16.
//  Copyright © 2016 Codecamp. All rights reserved.
//

#import "GameOverController.h"

@implementation GameOverController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
    self.petImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_dead.png", self.pet.type]];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"confirm"]) {
        MenuViewController *menu = [segue destinationViewController];
        [Saver deleteCurrentSlotReference];
        menu.continueButton.enabled = NO;
    }
}

@end
