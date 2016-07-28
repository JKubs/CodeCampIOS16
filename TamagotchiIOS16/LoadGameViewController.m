//
//  LoadGameViewController.m
//  TamagotchiIOS16
//
//  Created by Codecamp on 28.07.16.
//  Copyright © 2016 Codecamp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoadGameViewController.h"

@implementation LoadGameViewController {

}
-(void)viewDidLoad {
    NSDictionary *slot1 = [Loader loadSlot:SAVE_SLOT_1];
    NSDictionary *slot2 = [Loader loadSlot:SAVE_SLOT_2];
    NSDictionary *slot3 = [Loader loadSlot:SAVE_SLOT_3];
    NSDictionary *slot4 = [Loader loadSlot:SAVE_SLOT_4];
    
    
}
- (IBAction)loadSlotToGame:(UIButton *)sender {
}

- (IBAction)deleteSlot:(UIButton *)sender {
}
@end