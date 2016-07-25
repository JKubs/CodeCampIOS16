//
//  GameViewController.m
//  TamagotchiIOS16
//
//  Created by Codecamp on 25.07.16.
//  Copyright © 2016 Codecamp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameViewController.h"


@interface GameViewController ()
@end

@implementation GameViewController {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.image1 = [UIImage imageNamed:@"critter1.jpg"];
    self.image2 = [UIImage imageNamed:@"critter2.jpg"];
    self.petImageView.image = self.image1;
    self.currentImage = 0;
    self.storage = [[NSMutableArray alloc] initWithObjects:[[Food alloc] init],[[Food alloc] init], nil];
    self.owner = [[Owner alloc] init];
    self.pet = [[Pet alloc] init];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)feedAction:(UIButton *)sender {
}

- (IBAction)hydrateAction:(UIButton *)sender {
}

- (IBAction)enterShop:(UIButton *)sender {
}

//TODO just a joke. can be erased in final version
- (IBAction)killThatMonster:(UIButton *)sender {
}

- (void)animate {
    if(self.currentImage == 0) {
        self.petImageView.image = self.image2;
    }
    else self.petImageView.image = self.image1;
    self.currentImage = 1 - self.currentImage;
}

@end