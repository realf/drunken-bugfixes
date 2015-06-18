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

typedef NS_ENUM(NSInteger, DBFAlertType) {
    DBFAlertTypeCameraAccessDenied,
    DBFAlertTypeMicAccessDenied,
};

@interface DBFVideoCaptureViewController () <DBFCaptureSessionManagerDelegate>

@property (nonatomic) BOOL recorging;
@property (nonatomic, retain) DBFCaptureSessionManager *captureSessionManager;

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
    
    [_captureSessionManager startRunning];
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
    
}

- (void)manager:(DBFCaptureSessionManager *)manager didFinishRecordingToFileURL:(NSURL *)fileURL error:(NSError *)error {
    
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
