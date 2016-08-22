//
//  NSObject+Food.h
//  TamagotchiIOS16
//
//  Created by Codecamp on 25.07.16.
//  Copyright © 2016 Codecamp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Food : NSObject <NSCoding>

@property (weak, nonatomic) NSString *name;
@property NSInteger cost;
@property NSInteger expReward;

-(void)encodeWithCoder:(NSCoder *)aCoder;
-(instancetype)initWithCoder:(NSCoder *)aDecoder;

@end
