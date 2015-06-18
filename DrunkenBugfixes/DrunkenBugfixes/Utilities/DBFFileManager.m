//
//  DBFFileManager.m
//  DrunkenBugfixes
//
//  Created by Sergey Dunets on 18.06.15.
//  Copyright (c) 2015 Sergey Dunets. All rights reserved.
//

#import "DBFFileManager.h"

@implementation DBFFileManager

- (NSURL *)tempFileURL {
    static NSDateFormatter *sFormatter = nil;
    if (sFormatter == nil) {
        sFormatter = [NSDateFormatter new];
        sFormatter.timeStyle = NSDateFormatterShortStyle;
        sFormatter.dateStyle = NSDateFormatterShortStyle;
    }
    NSDate *currentDate = [NSDate date];
    
    NSString *filename = [sFormatter stringFromDate:currentDate];
    NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent:filename];
    return [NSURL fileURLWithPath:path];
}

@end
