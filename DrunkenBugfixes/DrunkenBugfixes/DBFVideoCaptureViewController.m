//
//  DBFVideoCaptureViewController.m
//  DrunkenBugfixes
//
//  Created by Sergey Dunets on 15.06.15.
//  Copyright (c) 2015 Sergey Dunets. All rights reserved.
//

#import "DBFVideoCaptureViewController.h"
#import "DBFCaptureSessionMovieFileOutputManager.h"
#import "DBFPermissionsManager.h"
#import "DBFFileManager.h"

typedef NS_ENUM(NSInteger, DBFAlertType) {
    DBFAlertTypeCameraAccessDenied,
    DBFAlertTypeMicAccessDenied,
};

@interface DBFVideoCaptureViewController () <DBFCaptureSessionManagerDelegate>

@property (nonatomic) BOOL recording;
@property (nonatomic) BOOL dismissing;
@property (nonatomic, retain) DBFCaptureSessionManager *captureSessionManager;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *recordButton;

@end

@implementation DBFVideoCaptureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)toggleRecording:(id)sender {
    if (_recording) {
        [_captureSessionManager stopRecording];
    }
    else {
        [UIApplication sharedApplication].idleTimerDisabled = YES;
        
        self.recordButton.enabled = NO;
        self.recordButton.title = @"Stop";
        
        [self.captureSessionManager startRecording];
        
        _recording = YES;
    }
}

- (IBAction)closeCamera:(id)sender {
    if(_recording){
        _dismissing = YES;
        [_captureSessionManager stopRecording];
    } else {
        [self stopRecordingAndClose];
    }
}

- (void)setup {
    [self checkPermissions];
    _captureSessionManager = [DBFCaptureSessionMovieFileOutputManager new];
    [_captureSessionManager setDelegate:self callbackQueue:dispatch_get_main_queue()];
    
    [self setupInterface];
}

#pragma mark -

- (void)checkPermissions {
    DBFPermissionsManager *permissionsManager = [DBFPermissionsManager new];
    [permissionsManager checkCameraAuthorizationStatusWithBlock:^(BOOL granted) {
        if (!granted) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showAlert:DBFAlertTypeCameraAccessDenied];
            });
        }
    }];
    
    [permissionsManager checkMicAuthorizationStatusWithBlock:^(BOOL granted) {
        if (!granted) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showAlert:DBFAlertTypeMicAccessDenied];
            });
        }
    }];
}

- (void)setupInterface {
    AVCaptureVideoPreviewLayer *previewLayer = _captureSessionManager.videoPreviewLayer;
    previewLayer.frame = self.view.bounds;
    [self.view.layer addSublayer:previewLayer];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStylePlain target:self action:@selector(closeCamera:)];
    self.navigationController.navigationItem.hidesBackButton = YES;
    
    [_captureSessionManager startRunning];
}

- (void)stopRecordingAndClose {
    [_captureSessionManager stopRunning];
    [self.navigationController popToRootViewControllerAnimated:YES];
    _dismissing = NO;
}

- (void)showAlert:(DBFAlertType)type {
    UIAlertController *alertController = nil;
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Close" style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction *settingsAction = [UIAlertAction actionWithTitle:@"Settings" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }];
    
    switch (type) {
        case DBFAlertTypeCameraAccessDenied: {
            alertController = [UIAlertController alertControllerWithTitle:@"Camera disabled" message:@"This app doesn't have permission to use the camera, please go to the Settings app > Privacy > Camera and enable access." preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:cancelAction];
            [alertController addAction:settingsAction];
            
            break;
        }
        case DBFAlertTypeMicAccessDenied: {
            alertController = [UIAlertController alertControllerWithTitle:@"Microphone Disabled" message:@"To enable sound recording with your video please go to the Settings app > Privacy > Microphone and enable access." preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:cancelAction];
            [alertController addAction:settingsAction];
            
            break;
        }
    }
    
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - DBFCaptureSessionManagerDelegate

- (void)managerDidBeginRecording:(DBFCaptureSessionManager *)manager {
    _recordButton.enabled = YES;
}

- (void)manager:(DBFCaptureSessionManager *)manager didFinishRecordingToFileURL:(NSURL *)fileURL error:(NSError *)error {
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    
    _recordButton.title = @"Record";
    _recording = NO;
    
    DBFFileManager *fm = [DBFFileManager new];
    [fm copyFileToCameraRoll:fileURL];
    
    //Dismiss camera (when user taps cancel while camera is recording)
    if (_dismissing) {
        [self stopRecordingAndClose];
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
