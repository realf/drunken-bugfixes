//
//  DBFPermissionsManager.h
//  DrunkenBugfixes
//
//  Created by Sergey Dunets on 14.06.15.
//  Copyright (c) 2015 Sergey Dunets. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBFPermissionsManager : NSObject

- (void)checkCameraAuthorizationStatusWithBlock:(void(^)(BOOL granted))block;
- (void)checkMicAuthorizationStatusWithBlock:(void(^)(BOOL granted))block;

@end
