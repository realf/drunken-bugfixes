//
//  DBFCaptureSessionManager.h
//  DrunkenBugfixes
//
//  Created by Sergey Dunets on 15.06.15.
//  Copyright (c) 2015 Sergey Dunets. All rights reserved.
//

#import <Foundation/Foundation.h>
@import AVFoundation;

@protocol DBFCaptureSessionManagerDelegate;

@interface DBFCaptureSessionManager : NSObject

@property (nonatomic) AVCaptureSession *captureSession;
@property (nonatomic) AVCaptureDevice *cameraDevice;
@property (nonatomic) dispatch_queue_t delegateCallbackQueue;
@property (nonatomic, weak, readonly) id<DBFCaptureSessionManagerDelegate> delegate;

- (void)setDelegate:(id<DBFCaptureSessionManagerDelegate>)delegate callbackQueue:(dispatch_queue_t)callbackQueue;

- (BOOL)addInput:(AVCaptureDeviceInput *)input toCaptureSession:(AVCaptureSession *)captureSession;
- (BOOL)addOutput:(AVCaptureOutput *)output toCaptureSession:(AVCaptureSession *)captureSession;

- (void)startRunning;
- (void)stopRunning;

- (void)startRecording;
- (void)stopRecording;

- (AVCaptureVideoPreviewLayer *)videoPreviewLayer;

@end


@protocol DBFCaptureSessionManagerDelegate <NSObject>

@required

- (void)managerDidBeginRecording:(DBFCaptureSessionManager *)manager;
- (void)manager:(DBFCaptureSessionManager *)manager didFinishRecordingToFileURL:(NSURL *)fileURL error:(NSError *)error;

@end
