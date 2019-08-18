//
//  ViewController.h
//  JobsFeeder
//
//  Created by Sourav Chatterjee on 17/08/19.
//  Copyright © 2019 Sourav Chatterjee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *Title;

- (IBAction)fetchJobs:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *BtnFetchJobs;
@property (nonatomic, strong) NSXMLParser *xmlParser;
@property (nonatomic, strong) NSMutableArray *arrJobsData;
@property (nonatomic, strong) NSMutableDictionary *dictJobsData;
@property (nonatomic, strong) NSMutableString *foundValue;
@property (nonatomic, strong) NSString *currentElement;
@property (weak, nonatomic) IBOutlet UITableView *jobsTable;






@end

