//
//  ViewController.m
//  TextFaces
//
//  Created by Neo Ighodaro on 11/10/15.
//  Copyright (c) 2015 TapSharp Interactive. All rights reserved.
//

#import <Social/Social.h>
#import "TextFaces.h"
#import "RootViewController.h"
#import "RootMenuTableViewCell.h"

@interface RootViewController ()
@property(nonatomic,strong) NSMutableArray* links;
- (void)configureView;
- (void)sendEmailToDeveloper;
- (IBAction)shareTextFacesApp:(id)sender;
- (IBAction)resetTestFacesToDefaults:(id)sender;
@end


@implementation RootViewController

@synthesize links;
@synthesize headerLogo;
@synthesize headerView;
@synthesize tableView = _tableView;


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    if ( ! [defaults boolForKey:@"FirstLaunchViewControllerSeen"]) {
        [self performSegueWithIdentifier:@"FirstLaunchViewController" sender:nil];
        
        [defaults setObject:@YES forKey:@"FirstLaunchViewControllerSeen"];
        [defaults synchronize];
        
        [TextFaces saveiCloudDataToLocalFile];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* segue;

    switch (indexPath.row) {
        case 0: segue = @"ManageTextFacesTableViewController"; break;
        case 1: segue = @"ManageFavoritesTableViewCellController"; break;
        case 2: segue = @"CommunityTextFacesTableViewController"; break;
        case 3: segue = @"HelpViewController"; break;
        case 4: return [self sendEmailToDeveloper]; break;
        default: segue = nil; break;
    }

    if (segue) [self performSegueWithIdentifier:segue sender:self];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleNone;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.links.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RootMenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LinkCell"];
    
    NSDictionary* link = [self.links objectAtIndex:indexPath.row];
    
    cell.menuTitle.text = link[@"title"];
    cell.menuSubtitle.text = link[@"subtitle"];
    cell.menuIcon.image = [UIImage imageNamed:link[@"icon"]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

# pragma mark - Configure View

- (void)loadView {
    [super loadView];
    
    self.tableView.rowHeight = 70;
}

- (void)configureView {
    self.links = [[NSMutableArray alloc] initWithArray:@[
                                                         @{
                                                             @"title": NSLocalizedString(@"Manage Textfaces", @"Manage TextFaces"),
                                                             @"subtitle": NSLocalizedString(@"Manage all your textfaces.", @"Manage all TextFaces"),
                                                             @"icon":@"menu-settings-icon"
                                                         },
                                                         @{
                                                             @"title": NSLocalizedString(@"Favorites", @"Favorites"),
                                                             @"subtitle": NSLocalizedString(@"Manage all your favorites.", @"Manage favorites"),
                                                             @"icon":@"menu-star-icon"
                                                         },
                                                         @{
                                                             @"title": NSLocalizedString(@"Suggested TextFaces", @"Suggested TextFaces"),
                                                             @"subtitle": NSLocalizedString(@"Our Community Picks", @"Our Community Picks"),
                                                             @"icon": @"menu-cloud-icon"
                                                         },
                                                         @{
                                                             @"title": NSLocalizedString(@"Need Help?", @"Need help?"),
                                                             @"subtitle": NSLocalizedString(@"How-to's & FAQs", @"How-to's and FAQs"),
                                                             @"icon": @"menu-help-icon"
                                                         },
                                                         @{
                                                             @"title": NSLocalizedString(@"Submit Feedback", @"Submit Feedback"),
                                                             @"subtitle": NSLocalizedString(@"We'll always value your input", @"We value your input."),
                                                             @"icon": @"menu-msg-icon"
                                                         }
                                                    ]];
    
    // Nav bar
    UINavigationBar* nav = self.navigationController.navigationBar;
    [nav setBackgroundImage:[UIImage new] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [nav setShadowImage:[UIImage new]];
    [self setNeedsStatusBarAppearanceUpdate];
}


#pragma mark - Button Events

- (IBAction)shareTextFacesApp:(id)sender {
    NSMutableArray *sharingItems = [NSMutableArray new];
    [sharingItems addObject:TEXTFACES_SHARE_TEXT];
    [sharingItems addObject:[NSURL URLWithString:TEXTFACES_SHARE_URL]];
    //[sharingItems addObject:[UIImage imageNamed:@"textfaces-keyboard-screenshot"]];
    
    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:sharingItems
                                                                                     applicationActivities:nil];
    
    [self presentViewController:activityController animated:YES completion:nil];
}

- (IBAction)resetTestFacesToDefaults:(id)sender {
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Reset TextFaces?", @"Reset TextFaces?")
                                                                             message:NSLocalizedString(@"You will lose all your organization and favorites if you continue.", @"You will lose customizations.")
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* resetAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Reset", @"Reset")
                                                          style:UIAlertActionStyleDestructive
                                                        handler:^(UIAlertAction *action) {
                                                            [TextFaces reset];
                                                        }];

    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel")
                                                           style:UIAlertActionStyleCancel
                                                         handler:nil];

    [alertController addAction:cancelAction];
    [alertController addAction:resetAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)sendEmailToDeveloper {
    MFMailComposeViewController *mailCtrl = [[MFMailComposeViewController alloc] init];
    [mailCtrl setMailComposeDelegate:self];
    [mailCtrl setSubject:NSLocalizedString(@"TextFaces FeedBack", @"TextFaces FeedBack")];
    [mailCtrl setToRecipients:@[@"help@textfaces.co"]];
    
    [self presentViewController:mailCtrl animated:YES completion:NULL];
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    switch (result) {
        case MFMailComposeResultSent: [Appirater userDidSignificantEvent:YES]; break;
        default: break;
    }

    [self dismissViewControllerAnimated:YES completion:NULL];
}
@end
