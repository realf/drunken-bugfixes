//
//  DBFPermissionsManager.m
//  DrunkenBugfixes
//
//  Created by Sergey Dunets on 14.06.15.
//  Copyright (c) 2015 Sergey Dunets. All rights reserved.
//

#import "DBFPermissionsManager.h"
@import AVFoundation;

@implementation DBFPermissionsManager

- (void)checkCameraAuthorizationStatusWithBlock:(void (^)(BOOL granted))block {
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        if (block != nil) {
            block(granted);
        }
    }];
}

- (void)checkMicAuthorizationStatusWithBlock:(void (^)(BOOL))block {
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
        if (block != nil) {
            block(granted);
        }
    }];
}

@end
