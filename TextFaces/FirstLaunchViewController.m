//
//  FirstLaunchViewController.m
//  TextFaces
//
//  Created by Neo Ighodaro on 11/13/15.
//  Copyright (c) 2015 TapSharp Interactive. All rights reserved.
//

#import "FirstLaunchViewController.h"

@interface FirstLaunchViewController ()
- (IBAction)dismissFirstLaunchBtnPressed:(id)sender;
- (void)finishedWatchingIntroVideo:(NSNotification *) notification;
- (void)createIntroVideoController;
- (void)addGradientToView;
@end

@implementation FirstLaunchViewController

@synthesize player = _player;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addGradientToView];
    [self createIntroVideoController];
    
    [self.subtitle setText:[NSString stringWithFormat:NSLocalizedString(@"It's like emoji's but with simple text.\n%@", @"Intro text subtitle"), @"(⌐■_■)  ᕕ( ᐛ )ᕗ  ¯\\_(ツ)_/¯"]];
    [self.startButton setTitle:NSLocalizedString(@"Watch Intro Video", @"Watch intro video") forState:UIControlStateNormal];
    [self.startButton.layer setCornerRadius:20];
    
    [self.dismissFirstlaunchBtn setTitle:NSLocalizedString(@"No, thank you", @"No thank you") forState:UIControlStateNormal];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(finishedWatchingIntroVideo:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:self.player.moviePlayer];
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
                                                  object:self.player.moviePlayer];
}


- (void)createIntroVideoController {
    NSURL* videoURL = [NSURL URLWithString:@"https://textfaces.co/ios_intro_video.mp4"];    
    MPMoviePlayerViewController* player = [[MPMoviePlayerViewController alloc] initWithContentURL:videoURL];
    player.moviePlayer.movieSourceType = MPMovieSourceTypeFile;
    player.moviePlayer.shouldAutoplay = YES;
    self.player = player;
}


#pragma mark - Configure view

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)addGradientToView {
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.view.bounds;
    gradient.colors = [NSArray arrayWithObjects:
                       (id)[[UIColor colorWithRed:255/255.0f green:94/255.0f blue:58/255.0f alpha:1] CGColor],
                       (id)[[UIColor colorWithRed:255/255.0f green:42/255.0f blue:104/255.0f alpha:1] CGColor], nil];
    
    [self.view.layer insertSublayer:gradient atIndex:0];
}


#pragma mark - Events

- (IBAction)dismissFirstLaunchBtnPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)playGettingStartedVideo:(id)sender {
    [self presentMoviePlayerViewControllerAnimated:self.player];
    [self.player.moviePlayer play];
}

- (void)finishedWatchingIntroVideo:(NSNotification *) notification {
    //[self dismissFirstLaunchBtnPressed:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
