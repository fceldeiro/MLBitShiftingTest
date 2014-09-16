//
//  ViewController.m
//  BitShiftingTest
//
//  Created by Fabian Celdeiro on 9/16/14.
//  Copyright (c) 2014 MercadoLibre. All rights reserved.
//

#import "ViewController.h"


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
    
    

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
