//
//  ViewController.m
//  JobsFeeder
//
//  Created by Sourav Chatterjee on 17/08/19.
//  Copyright © 2019 Sourav Chatterjee. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.Title.text = @"Stack JOBS";
    self.BtnFetchJobs.layer.cornerRadius = 5;
    self.BtnFetchJobs.clipsToBounds = YES;
    
    
}

- (IBAction)fetchJobs:(id)sender {

    [self.BtnFetchJobs setTitle:@"Fetching..." forState:UIControlStateNormal];

}
@end
