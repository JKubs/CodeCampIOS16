//
//  Loader.m
//  TamagotchiIOS16
//
//  Created by Codecamp on 26.07.16.
//  Copyright © 2016 Codecamp. All rights reserved.
//

#import "Loader.h"

@implementation Loader

+(BOOL)loadSaveStateTo:(GameViewController *)controller {
    
    //bundle
    //NSString *dataFile = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"txt"];
    
    //sandbox
    NSString *docPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/SaveFile.tsv"];
    // NSString *dataFile = [NSString stringWithContentsOfFile:docPath encoding: NSUTF8StringEncoding error:nil];
    
    NSError *error;
    NSString *save = [[NSString alloc]
                                initWithContentsOfFile:docPath
                                encoding:NSUTF8StringEncoding
                                error:&error];
    if (save == nil) {
        // an error occurred
        NSLog(@"Error reading file at %@\n%@",
              docPath, [error localizedFailureReason]);
        return NO;
    }
    NSArray *lines = [save componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    
    BOOL read = NO;
    for (NSString *line in lines) {
        if([line containsString:@"SaveSlot"]) {
            //TODO parse slot and compare it to needed slot
            
            if(read) {
                if([line length] > 0) {
                    NSString *subject = [[line componentsSeparatedByString:@":"] objectAtIndex:0];
                    //TODO parse save data and save it in controller
                    if([subject isEqualToString:@""]) {
                    
                    }
                }
            }
        }
    }
    
    return NO;
}

@end
