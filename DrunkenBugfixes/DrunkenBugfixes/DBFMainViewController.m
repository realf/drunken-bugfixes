//
//  ViewController.m
//  DrunkenBugfixes
//
//  Created by Sergey Dunets on 06.06.15.
//  Copyright (c) 2015 Sergey Dunets. All rights reserved.
//

#import "DBFMainViewController.h"
#import "DBFVideoCaptureViewController.h"

@interface DBFMainViewController ()

@end

@implementation DBFMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0: {
            [self performSegueWithIdentifier:@"CaptureVideoSegueId" sender:nil];
            break;
        }
        default:
            break;
    }
}

 #pragma mark - Navigation
 
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     if ([segue.identifier isEqualToString:@"CaptureVideoSegueId"]) {
         [segue.destinationViewController setup];
     }
 }


@end
