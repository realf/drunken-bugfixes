//
//  DBFFileManager.m
//  DrunkenBugfixes
//
//  Created by Sergey Dunets on 18.06.15.
//  Copyright (c) 2015 Sergey Dunets. All rights reserved.
//

#import "DBFFileManager.h"
@import AssetsLibrary;

@implementation DBFFileManager

- (NSURL *)tempFileURL {
    static NSDateFormatter *sFormatter = nil;
    if (sFormatter == nil) {
        sFormatter = [NSDateFormatter new];
        sFormatter.dateFormat = @"yyyy'-'MM'-'dd HH'-'mm'-'ss";
    }
    NSDate *currentDate = [NSDate date];
    
    NSString *filename = [sFormatter stringFromDate:currentDate];
    NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent:[filename stringByAppendingPathExtension:@"mp4"]];
    return [NSURL fileURLWithPath:path];
}

- (void)copyFileToCameraRoll:(NSURL *)fileURL {
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    if (![library videoAtPathIsCompatibleWithSavedPhotosAlbum:fileURL]) {
        NSLog(@"Video incompatible with camera roll");
    }
    
    [library writeVideoAtPathToSavedPhotosAlbum:fileURL completionBlock:^(NSURL *assetURL, NSError *error) {
        if (error != nil) {
            NSLog(@"Error: Domain = %@, Code = %@", [error domain], [error localizedDescription]);
        }
        else if (assetURL == nil) {
            NSLog(@"Error saving to camera roll: no error message, but no url returned");
        }
        else {
            NSError *error = nil;
            [[NSFileManager defaultManager] removeItemAtURL:fileURL error:&error];
            if (error != nil) {
                NSLog(@"error: %@", [error localizedDescription]);
            }
        }
    }];
}

@end
