//
//  EntreCheckinVC.m
//  Entre
//
//  Created by Michael Holp on 7/11/14.
//  Copyright (c) 2014 Fovnders. All rights reserved.
//

#import "EntreCheckinVC.h"

@implementation EntreCheckinVC
@synthesize webView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIView *logoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 120, 21)];
    UIImageView *logo = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 120, 21)];
    logo.image = [UIImage imageNamed:@"entre-logo.png"];
    [self.view addSubview:logoView];
    [logoView addSubview:logo];
    self.navigationItem.titleView = logoView;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:173/255.0 green:216/255.0 blue:199/255.0 alpha:1.0];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    NSLog(@"CONTENT: %@", self.content);
    
    [webView loadHTMLString:self.content baseURL:[NSURL URLWithString:@"www.entre.co"]];
}

@end
