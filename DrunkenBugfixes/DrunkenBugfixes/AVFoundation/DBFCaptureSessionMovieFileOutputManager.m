//
//  DBFCaptureSessionMovieFileOutputManager.m
//  DrunkenBugfixes
//
//  Created by Sergey Dunets on 18.06.15.
//  Copyright (c) 2015 Sergey Dunets. All rights reserved.
//

#import "DBFCaptureSessionMovieFileOutputManager.h"
#import "DBFFileManager.h"

@interface DBFCaptureSessionMovieFileOutputManager () <AVCaptureFileOutputRecordingDelegate>

@property (nonatomic, retain) AVCaptureMovieFileOutput *movieFileOutput;

@end


@implementation DBFCaptureSessionMovieFileOutputManager

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        [self addMovieFileOutputToCaptureSession:self.captureSession];
    }
    return self;
}

#pragma mark - Private

- (BOOL)addMovieFileOutputToCaptureSession:(AVCaptureSession *)session {
    self.movieFileOutput = [AVCaptureMovieFileOutput new];
    return [self addOutput:_movieFileOutput toCaptureSession:session];
}

#pragma mark - Recording

- (void)startRecording {
    DBFFileManager *fileManager = [DBFFileManager new];
    NSURL *fileURL = [fileManager tempFileURL];
    [self.movieFileOutput startRecordingToOutputFileURL:fileURL recordingDelegate:self];
}

#pragma mark - AVCaptureFileOutputRecordingDelegate

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didStartRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray *)connections {
    [self.delegate managerDidBeginRecording:self];
}

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error {
    [self.delegate manager:self didFinishRecordingToFileURL:outputFileURL error:error];
}

@end
