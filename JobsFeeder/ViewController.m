//
//  ViewController.m
//  JobsFeeder
//
//  Created by Sourav Chatterjee on 17/08/19.
//  Copyright © 2019 Sourav Chatterjee. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.Title.text = @"Stack JOBS";
    self.BtnFetchJobs.layer.cornerRadius = 5;
    self.BtnFetchJobs.clipsToBounds = YES;
    self.jobsTable.dataSource = self;
    self.jobsTable.delegate = self;
    
    
}

- (IBAction)fetchJobs:(id)sender {
    NSLog(@"Making a request....");
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    AFHTTPResponseSerializer *responseSerializer = [AFHTTPResponseSerializer serializer];
    responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/atom+xml", nil];
    manager.responseSerializer = responseSerializer;
    NSURL *URL = [NSURL URLWithString:@"https://jobs.github.com/positions.atom?description=javascript&location="];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    NSURLSessionDataTask *dataTask = [
                                      manager dataTaskWithRequest:request  completionHandler:^(NSURLResponse *response, id responseObject, NSError *error){
                                          if (error) {
                                              NSLog(@"Error: %@", error);
                                          }else{
                                              NSData *data = (NSData *)responseObject;
                                              self.xmlParser = [[NSXMLParser alloc] initWithData:data];
                                              self.xmlParser.delegate = self;
                                              [self.xmlParser parse];
                                          }
                                      }
                                      ];
    [dataTask resume];
    
}

-(void) parserDidStartDocument: (NSXMLParser *) parser {
    NSLog(@"------Lets Start parsing the XML Data-----------");
    self.arrJobsData = [[NSMutableArray alloc] init];
}

- (void) parserDidEndDocument: (NSXMLParser *) parser {
    NSLog(@"Finished Parsing Documents");
    [self.jobsTable reloadData];
    
}

- (void) parser:(NSXMLParser *) parser parseErrorOccurred:(nonnull NSError *)parseError {
    NSLog(@"%@", [parseError localizedDescription]);
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    
    // If the current element name is equal to "geoname" then initialize the temporary dictionary.
    if ([elementName isEqualToString:@"entry"]) {
        self.dictJobsData = [[NSMutableDictionary alloc] init];
    }
    
    if([elementName isEqualToString:@"link"]){
        NSString *jobLink = [attributeDict objectForKey:@"href"];
        if(!self.foundValue){
            self.foundValue = [[NSMutableString alloc] initWithString:jobLink];
        } else {
            [self.foundValue appendString:jobLink ];
        }
        
    }
    
    self.currentElement = elementName;
    
}

- (void) parser: (NSXMLParser *)parser didEndElement:(nonnull NSString *)elementName namespaceURI:(nullable NSString *)namespaceURI qualifiedName:(nullable NSString *)qName{
    
    if([elementName isEqualToString:@"entry"]){
        [self.arrJobsData addObject:[[NSDictionary alloc] initWithDictionary:self.dictJobsData]];
    }
    
    
    if([elementName isEqualToString:@"title"]){
        
        [self.dictJobsData setObject:[NSString stringWithString:self.foundValue] forKey:@"title"];
    }
    
    if([elementName isEqualToString:@"content"]){
        [self.dictJobsData setObject:[NSString stringWithString:self.foundValue] forKey:@"content"];
    }
    
    if([elementName isEqualToString:@"link"]){
        [self.dictJobsData setObject:[NSString stringWithString:self.foundValue] forKey:@"link"];
    }
    
    [self.foundValue setString: @""];
    
}


-(void) parser: (NSXMLParser *) parser foundCharacters:(nonnull NSString *)string {
    
    if(
       [self.currentElement isEqualToString:@"content"] ||
       [self.currentElement isEqualToString:@"title"]
       ){
        if(!self.foundValue){
            self.foundValue = [[NSMutableString alloc] initWithString:string];
        } else {
            [self.foundValue appendString:string ];
        }
    }
    
    
    
    
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"Table Return Count : %i", [self.arrJobsData count]);
    return [self.arrJobsData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.textLabel.text = [[self.arrJobsData objectAtIndex:indexPath.row] objectForKey:@"title"];
    NSString *detail = [[self.arrJobsData objectAtIndex:indexPath.row] objectForKey:@"link"];
    cell.detailTextLabel.text = detail;
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"JobDetails" sender:self];
    
}



@end
