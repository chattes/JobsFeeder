//
//  ViewController.h
//  JobsFeeder
//
//  Created by Sourav Chatterjee on 17/08/19.
//  Copyright © 2019 Sourav Chatterjee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *Title;

- (IBAction)fetchJobs:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *BtnFetchJobs;




@end

