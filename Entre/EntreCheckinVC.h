//
//  EntreCheckinVC.h
//  Entre
//
//  Created by Michael Holp on 7/11/14.
//  Copyright (c) 2014 Fovnders. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EntreCheckinVC : UIViewController<UIWebViewDelegate>

@property(assign) NSString *placeName;
@property(assign) NSString *protips;
@property(assign) NSString *content;

@property(nonatomic,retain) NSURL *imageUrl;

@property(nonatomic,retain) IBOutlet UIWebView *webView;

@end
