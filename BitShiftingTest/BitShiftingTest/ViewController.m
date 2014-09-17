//
//  ViewController.m
//  BitShiftingTest
//
//  Created by Fabian Celdeiro on 9/16/14.
//  Copyright (c) 2014 MercadoLibre. All rights reserved.
//

#import "ViewController.h"
#import <AFNetworking/AFNetworking.h>


typedef NS_OPTIONS(NSUInteger, RequestType) {
    MLNetworkingRequestTypeNone             = 0 << 0,
    MLNetworkingRequestTypeGET              = 1 << 0,
    MLNetworkingRequestTypeHEAD             = 1 << 1,
    MLNetworkingRequestTypePOST             = 1 << 2,
    MLNetworkingRequestTypePUT              = 1 << 3,
    MLNetworkingRequestTypeDELETE           = 1 << 4,
    MLNetworkingRequestTypeOPTIONS          = 1 << 5,
    MLNetworkingRequestTypeTRACE            = 1 << 6,
    MLNetworkingRequestTypeCONNECT          = 1 << 7,

    MLNetworkingRequestTypeMobile           = 1 << 10,

    MLNetworkingRequestTypeAuthenticated    = 1 << 20
};


@interface ViewController ()
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) AFHTTPSessionManager * manager;
@property (nonatomic,strong) NSMutableArray* tasks;

@end



@implementation ViewController

NSString *NSStringWithBits(int64_t mask) {
    NSMutableString *mutableStringWithBits = [NSMutableString new];
    for (int8_t bitIndex = 0; bitIndex < sizeof(mask) * 8; bitIndex++) {
        [mutableStringWithBits insertString:mask & 1 ? @"1" : @"0" atIndex:0];
        mask >>= 1;
    }
    return [mutableStringWithBits copy];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    

    UITableView * tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height-20)];
    
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    self.tableView = tableView;
    [self.view addSubview:tableView];
    
    // Do any additional setup after loading the view, typically from a nib.
    
    RequestType requestTypeGetMobile = MLNetworkingRequestTypeGET | MLNetworkingRequestTypeMobile;
    RequestType requestTypePostAuthenticated = MLNetworkingRequestTypePOST | MLNetworkingRequestTypeAuthenticated;
    RequestType requestTypeDeleteMobileAuthenticated = MLNetworkingRequestTypeAuthenticated | MLNetworkingRequestTypeDELETE | MLNetworkingRequestTypeMobile;
    

    NSString * stringBits = NSStringWithBits(requestTypeGetMobile);
    
    NSLog(@"Logging %@",stringBits);
    NSLog(@"Is Get? %@",requestTypeGetMobile & MLNetworkingRequestTypeGET ? @"YES" :@"NO");
    NSLog(@"Is Mobile? %@",requestTypeGetMobile & MLNetworkingRequestTypeMobile ? @"YES" :@"NO");
    NSLog(@"Is Authenticated? %@",requestTypeGetMobile & MLNetworkingRequestTypeAuthenticated ? @"YES" :@"NO");
    
    NSLog(@"Is Get Mobile? %@",(requestTypeGetMobile & MLNetworkingRequestTypeGET) && (requestTypeGetMobile & MLNetworkingRequestTypeMobile) ? @"YES" :@"NO");
    
    NSLog(@"Is Get Mobile Authenticated? %@",
          (requestTypeGetMobile & MLNetworkingRequestTypeGET) &&
          (requestTypeGetMobile & MLNetworkingRequestTypeMobile) &&
          (requestTypeGetMobile & MLNetworkingRequestTypeAuthenticated) ?
          @"YES" :@"NO");
    
    
    stringBits = NSStringWithBits(requestTypePostAuthenticated);
    NSLog(@"Logging requestTypePostAuthenticated %@",stringBits);
    
    NSLog(@"Is Post? %@",(requestTypePostAuthenticated & MLNetworkingRequestTypePOST)? @"YES" :@"NO");
    NSLog(@"Is Mobile? %@",(requestTypePostAuthenticated & MLNetworkingRequestTypeMobile)? @"YES" :@"NO");
    NSLog(@"Is Authenticated? %@",(requestTypePostAuthenticated & MLNetworkingRequestTypeAuthenticated)? @"YES" :@"NO");
    
     NSLog(@"Is Post Mobile? %@",(requestTypePostAuthenticated & MLNetworkingRequestTypePOST) && (requestTypePostAuthenticated & MLNetworkingRequestTypeMobile) ? @"YES" :@"NO");
    
    NSLog(@"Is Post Authenticated? %@",(requestTypePostAuthenticated & MLNetworkingRequestTypePOST) && (requestTypePostAuthenticated & MLNetworkingRequestTypeAuthenticated) ? @"YES" :@"NO");
    
    
    
    stringBits = NSStringWithBits(requestTypeDeleteMobileAuthenticated);
    NSLog(@"Logging requestTypeDeleteMobileAuthenticated %@",stringBits);

    NSLog(@"Is Delete? %@",(requestTypeDeleteMobileAuthenticated & MLNetworkingRequestTypeDELETE)? @"YES" :@"NO");
    
    NSLog(@"Is Delete Mobile Authenticated? %@",
           (requestTypeDeleteMobileAuthenticated & MLNetworkingRequestTypeDELETE) &&
           (requestTypeDeleteMobileAuthenticated & MLNetworkingRequestTypeMobile) &&
           (requestTypeDeleteMobileAuthenticated & MLNetworkingRequestTypeAuthenticated)?
           @"YES" :@"NO");
    
    

    NSURLSessionConfiguration * configuration = [[NSURLSessionConfiguration alloc] init];
    NSURL * baseURL = [NSURL URLWithString:@"https://api.mercadolibre.com"];
    
    AFHTTPSessionManager * manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
    self.manager = manager;

    
    /*
    [manager setDataTaskDidReceiveDataBlock:^(NSURLSession *session, NSURLSessionDataTask *dataTask, NSData *data) {
        NSLog(@"Task id %lu and bytes recieved %lli",(unsigned long)dataTask.taskIdentifier,dataTask.countOfBytesReceived);
    }];
     */

    self.tasks = [NSMutableArray array];
      NSURLSessionTask * taskToCancel;
    
    for (int i = 0 ; i<100 ; i++){
        
        NSURLSessionTask * task = [manager GET:@"/sites/MLA/search" parameters:@{@"q":@"ipod", @"limit":@"50"} success:^(NSURLSessionDataTask *task, id responseObject) {
            
            [self.tasks addObject:task];
             [self.tableView reloadData];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //    NSLog(@"Task Failure %@ error %@", task,error);
        }];
        
        task.taskDescription = @"GET SEARCH";



    }
    
    
    
    self.tasks = self.manager.tasks;
    
    [self.tableView reloadData];
   

    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - table

-(NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    int tasksRunning = 0;
    int tasksCompleted = 0;
    int totalTasks = (int)self.manager.tasks.count;
    
    for (NSURLSessionTask * task in self.manager.tasks){
        if (task.state == NSURLSessionTaskStateRunning){
            tasksRunning++;
        }
        else if (task.state == NSURLSessionTaskStateCompleted){
            tasksCompleted++;
        }
    }
    
    
    return [NSString stringWithFormat:@"Tasks Running %i",tasksRunning,tasksCompleted];
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tasks.count;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
        
    }
    NSURLSessionTask * task = self.tasks[indexPath.row];
    cell.textLabel.text  = [NSString stringWithFormat:@"Task number %lu",(unsigned long)task.taskIdentifier];
    
    NSString * detailText = @"";
    if (task.state == NSURLSessionTaskStateRunning){
        detailText = @"Running";
    }
    else if (task.state == NSURLSessionTaskStateCanceling){
        detailText = @"Canceling";
    }
    else if (task.state == NSURLSessionTaskStateCompleted){
        detailText = @"Completed";
    }
    else if (task.state == NSURLSessionTaskStateSuspended){
        detailText = @"Suspended";
    }
    else{
        detailText = @"unkown";
    }
    cell.detailTextLabel.text = detailText;
  //  cell.detailTextLabel.text = [NSString stringWithFormat:@"%lli",task.countOfBytesReceived / task.countOfBytesExpectedToReceive];
    
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSURLSessionTask * task = [self.tasks objectAtIndex:indexPath.row];
    if (task.state == NSURLSessionTaskStateSuspended){
        [task resume];
    }
    else {
        [task suspend];
    }
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
}
@end
