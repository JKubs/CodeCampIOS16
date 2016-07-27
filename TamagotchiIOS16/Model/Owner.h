//
//  NSObject+Owner.h
//  TamagotchiIOS16
//
//  Created by Codecamp on 25.07.16.
//  Copyright © 2016 Codecamp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Owner : NSObject <NSCoding>

@property (weak, nonatomic) NSString *name;
@property NSInteger money;

-(void)encodeWithCoder:(NSCoder *)aCoder;
-(instancetype)initWithCoder:(NSCoder *)aDecoder;

@end
