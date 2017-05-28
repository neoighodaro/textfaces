//
//  HelpViewController.m
//  TextFaces
//
//  Created by Neo Ighodaro on 11/15/15.
//  Copyright (c) 2015 TapSharp Interactive. All rights reserved.
//

#import "HelpViewController.h"

@interface HelpViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet UIView *loadingView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingViewActivityIndicator;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backBtn;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *forwardBtn;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *refreshBtn;
- (IBAction)performReload:(id)sender;
@end


@implementation HelpViewController

@synthesize loadingView;
@synthesize loadingViewActivityIndicator;
@synthesize webView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [loadingView.layer setCornerRadius:5];
    [loadingView addSubview:loadingViewActivityIndicator];
    [self.view addSubview:loadingView];
    
    NSString* locale = [[NSLocale preferredLanguages] objectAtIndex:0];
    supportURL = [NSString stringWithFormat:@"%@?locale=%@", supportURL, locale];

    [self.webView setDelegate:self];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:supportURL]]];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self setTitle:NSLocalizedString(@"Support", @"Support")];
    
    self.navigationController.navigationBar.topItem.title = NSLocalizedString(@"Main Menu", @"Main Menu");
    
    [self updateWebviewBackAndFrontButtonState];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.topItem.title = nil;
}

- (void)updateWebviewBackAndFrontButtonState {
    [self.backBtn setEnabled:YES];
    //[self.backBtn setEnabled:[self.webView canGoBack]];
    [self.forwardBtn setEnabled:[self.webView canGoForward]];
}


- (void)webViewDidStartLoad:(UIWebView *)webView {
    [loadingView setHidden:NO];
    [self.refreshBtn setEnabled:NO];
    [self updateWebviewBackAndFrontButtonState];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [loadingView setHidden:YES];
    [self.refreshBtn setEnabled:YES];
    [self updateWebviewBackAndFrontButtonState];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [loadingView setHidden:YES];
    [self updateWebviewBackAndFrontButtonState];

    UIAlertController * alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"An Error Occurred", @"An error occurred")
                                                                    message:NSLocalizedString(@"Please make sure your device is connected to the internet.", @"Connect to the internet")
                                                             preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Okay", @"Okay")
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * action) {
                                                          [alert dismissViewControllerAnimated:YES completion:nil];
                                                      }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)goBackInTime:(id)sender {
    //if ([self.webView canGoBack])
    [self.webView goBack];
}

- (IBAction)moveForwardInTime:(id)sender {
    if ([self.webView canGoForward]) [self.webView goForward];
}

- (IBAction)performReload:(id)sender {
    [self.webView reload];
}

@end
