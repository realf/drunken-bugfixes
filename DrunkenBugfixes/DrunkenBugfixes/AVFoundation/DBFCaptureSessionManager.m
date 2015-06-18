//
//  DBFCaptureSessionManager.m
//  DrunkenBugfixes
//
//  Created by Sergey Dunets on 15.06.15.
//  Copyright (c) 2015 Sergey Dunets. All rights reserved.
//

#import "DBFCaptureSessionManager.h"

@interface DBFCaptureSessionManager ()

@property (nonatomic, strong) dispatch_queue_t sessionQueue;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;

@end

@implementation DBFCaptureSessionManager

- (instancetype)init {
    if ((self = [super init]) != nil) {
        _sessionQueue = dispatch_queue_create("org.realf.drunken-bugfixes.capturesessionqueue", DISPATCH_QUEUE_SERIAL);
        _captureSession = [self newCaptureSession];
    }
    
    return self;
}

- (void)setDelegate:(id<DBFCaptureSessionManagerDelegate>)delegate callbackQueue:(dispatch_queue_t)callbackQueue {
    NSParameterAssert(delegate == nil || callbackQueue != nil);
    
    @synchronized(self) {
        _delegate = delegate;
        if (_delegateCallbackQueue != callbackQueue) {
            _delegateCallbackQueue = callbackQueue;
        }
    }
}

- (BOOL)addInput:(AVCaptureDeviceInput *)input toCaptureSession:(AVCaptureSession *)captureSession {
    if ([captureSession canAddInput:input]) {
        [captureSession addInput:input];
        
        return YES;
    }
    else {
        NSLog(@"Cannot add input: %@", input.description);
    }
    
    return NO;
}

- (BOOL)addOutput:(AVCaptureOutput *)output toCaptureSession:(AVCaptureSession *)captureSession {
    if ([captureSession canAddOutput:output]) {
        [captureSession addOutput:output];
        
        return YES;
    }
    else {
        NSLog(@"Cannot add output: %@", output.description);
    }
    
    return NO;
}

- (void)startRunning {
    dispatch_async(_sessionQueue, ^{
        [_captureSession startRunning];
    });
}

- (void)stopRunning {
    dispatch_async(_sessionQueue, ^{
        [self stopRecording];
        [_captureSession stopRunning];
    });
}

- (void)startRecording {
    
}

- (void)stopRecording {
    
}

- (AVCaptureVideoPreviewLayer *)videoPreviewLayer {
    if (_previewLayer == nil && _captureSession != nil) {
        _previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:_captureSession];
    }
    
    return _previewLayer;
}

#pragma mark - Capture Session

- (AVCaptureSession *)newCaptureSession {
    AVCaptureSession *captureSession = [AVCaptureSession new];
    
    if (![self addDefaultCameraInputToCaptureSession:captureSession]) {
        NSLog(@"Failed to add camera input to capture session");
    }
    
    if (![self addDefaultMicInputToCaptureSession:captureSession]) {
        NSLog(@"Failed to add mic input to capture session");
    }
    
    return captureSession;
}

- (BOOL)addDefaultCameraInputToCaptureSession:(AVCaptureSession *)captureSession {
    NSError *error = nil;
    AVCaptureDeviceInput *cameraDeviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:[AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo] error:&error];
    
    if (error != nil) {
        NSLog(@"Error configuring camera input: %@", [error localizedDescription]);
        
        return NO;
    }
    else {
        BOOL success = [self addInput:cameraDeviceInput toCaptureSession:captureSession];
        _cameraDevice = cameraDeviceInput.device;
        
        return success;
    }
}

- (BOOL)addDefaultMicInputToCaptureSession:(AVCaptureSession *)captureSession {
    NSError *error = nil;
    AVCaptureDeviceInput *micDeviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:[AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio] error:&error];
    
    if (error != nil) {
        NSLog(@"Error configuring mic input: %@", [error localizedDescription]);
        
        return NO;
    }
    else {
        return [self addInput:micDeviceInput toCaptureSession:captureSession];
    }
}

@end
