//
//  FirstLaunchViewController.h
//  TextFaces
//
//  Created by Neo Ighodaro on 11/13/15.
//  Copyright (c) 2015 TapSharp Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <MediaPlayer/MediaPlayer.h>

@interface FirstLaunchViewController : UIViewController

@property(nonatomic,weak) IBOutlet UILabel* subtitle;
@property(nonatomic,strong) IBOutlet UIButton* startButton;
@property (weak, nonatomic) IBOutlet UIButton *dismissFirstlaunchBtn;
@property(nonatomic,strong) MPMoviePlayerViewController* player;
- (IBAction)playGettingStartedVideo:(id)sender;
@end
