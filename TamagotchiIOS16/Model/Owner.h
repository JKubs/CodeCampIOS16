//
//  NSObject+Owner.h
//  TamagotchiIOS16
//
//  Created by Codecamp on 25.07.16.
//  Copyright © 2016 Codecamp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Owner : NSObject

@property (weak, nonatomic) NSString *name;
@property NSInteger money;

@end
