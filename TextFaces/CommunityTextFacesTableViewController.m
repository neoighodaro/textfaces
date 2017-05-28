//
//  CommunityTextFacesTableViewController.m
//  TextFaces
//
//  Created by Neo Ighodaro on 11/27/15.
//  Copyright © 2015 TapSharp Interactive. All rights reserved.
//

#import <Parse/Parse.h>
#import <Appirater/Appirater.h>
#import "TextFaces.h"
#import "SuggestedTableViewCell.h"
#import "CommunityTextFacesTableViewController.h"

@interface CommunityTextFacesTableViewController ()

@end


@implementation CommunityTextFacesTableViewController

@synthesize textfaces = _textfaces;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = NSLocalizedString(@"Loading...", @"Loading");
    self.navigationController.navigationBar.titleTextAttributes = @{
        NSForegroundColorAttributeName:[UIColor whiteColor]
    };
    
    [self setTextfaces:[NSMutableArray array]];
    [self fetchParseData:1000 skip:0];
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.textfaces.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     SuggestedTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"SuggestedCellIdentifier"
                                                                    forIndexPath:indexPath];
    
    if ( ! cell) {
        cell = [[SuggestedTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                             reuseIdentifier:@"SuggestedCellIdentifier"];
    }
    
    NSString* face = [self.textfaces objectAtIndex:indexPath.row];
    
    cell.textLabel.text = face;
    [cell markAsAdded:[TextFaces textfaceExists:face inList:TEXTFACES_LIST_ALL]];

    return cell;
}


#pragma mark - Fetch Parse Data

- (void)fetchParseData:(NSUInteger)limit skip:(NSUInteger)skip {
    PFQuery *query = [PFQuery queryWithClassName:@"Faces"];
    [query setLimit: limit];
    [query setSkip: skip];
    [query setCachePolicy:kPFCachePolicyCacheElseNetwork];
    //[query whereKey:@"validated" equalTo:@"false"];

    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        self.navigationItem.title = NSLocalizedString(@"Suggested", @"Suggested");

        if ( ! error) {
            for (PFObject* face in objects) {
                [self.textfaces insertObject:[face objectForKey:@"face"] atIndex:0];
            }
            
            [self.tableView reloadData];
        } else {
            NSString* errorMsg, *titleMsg;
            
            switch (error.code) {
                case kPFErrorConnectionFailed:
                    titleMsg = NSLocalizedString(@"Internet Connection Error", @"Internet Connection Error");
                    errorMsg = NSLocalizedString(@"Error connecting to server, please check your network and try again.",
                                                 @"Could not connect to server.");
                    break;
                    
                default:
                    titleMsg = NSLocalizedString(@"An Error Occurred", @"Unknown Error Occurred");
                    errorMsg = NSLocalizedString(@"Failed to fetch suggested TextFaces, please try again later.",
                                                 @"Failed to fetch suggested textfaces");
                    break;
            }
            
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:titleMsg
                                                                           message:errorMsg
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Okay", @"Okay")
                                                                   style:UIAlertActionStyleCancel
                                                                 handler:^(UIAlertAction* action) {
                                                                     [self.navigationController popViewControllerAnimated:YES];
                                                                 }];
            
            [alert addAction:cancelAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }];
}


#pragma mark - Add Suggestion

- (IBAction)addTextFaceFromSuggestions:(id)sender {
    CGPoint buttonOriginInTableView = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonOriginInTableView];
    
    SuggestedTableViewCell* cell = (SuggestedTableViewCell*)[self.tableView cellForRowAtIndexPath:indexPath];
    
    NSString* face = [self.textfaces objectAtIndex:indexPath.row];
    
    BOOL canAddSuggestion = [cell.addSuggestionBtn.tintColor isEqual:TEXTFACES_TINT_COLOR];
    
    if (canAddSuggestion) {
        [TextFaces save:face toList:TEXTFACES_LIST_ALL];
        [Appirater userDidSignificantEvent:YES];
        [cell markAsAdded:YES];
    }
}

@end
