//
//  NSObject+Pet.h
//  TamagotchiIOS16
//
//  Created by Codecamp on 25.07.16.
//  Copyright © 2016 Codecamp. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Pet : NSObject <NSCoding>

@property (weak, nonatomic) NSString *type;
@property NSInteger lives;
@property (weak, nonatomic) NSString *currentWish;

-(void)encodeWithCoder:(NSCoder *)aCoder;
-(instancetype)initWithCoder:(NSCoder *)aDecoder;

@end
