//
//  CKBookLibraryViewController.m
//  firstNovel
//
//  Created by 张超 on 1/12/14.
//  Copyright (c) 2014 张超. All rights reserved.
//

#import "CKBookLibraryViewController.h"
#import "CKCommonUtility.h"
#import "NSURL+KeyValueParsing.h"
#import "NSString-URLArguments.h"

@interface CKBookLibraryViewController ()

@end

@implementation CKBookLibraryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [_webView release];
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    _webView.delegate = self;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(IOS_7_0))
    {
        _webView.frame = CGRectMake(0.0f, STATUS_HEIGHT + NAVIGATIONBAR_HEIGHT, APPLICATION_FRAME_WIDTH, APPLICATION_FRAME_HEIGHT - TABBAR_HEIGHT - STATUS_HEIGHT - NAVIGATIONBAR_HEIGHT);
    }
    else
    {
        _webView.frame = CGRectMake(0.0f, 0.0f, APPLICATION_FRAME_WIDTH, APPLICATION_FRAME_HEIGHT - TABBAR_HEIGHT  - NAVIGATIONBAR_HEIGHT);
    }
    [self.view addSubview:_webView];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://m.baidu.com/book"]]];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSDictionary *kvs = [[request URL] keysAndValuesOfQuery];
    NSLog(@"%@", kvs);
    NSString *downsrc = [kvs objectForKey:@"downsrc"];
    NSString *title = [kvs objectForKey:@"title"];
    if (CHECK_STRING_VALID(downsrc) && CHECK_STRING_VALID(title))
    {
        NSLog(@"%@", [downsrc stringByUnescapingFromURLArgument]);
        //TODO
        return NO;
    }
    return YES;
}

@end
