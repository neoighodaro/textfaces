//
//  ManageTextFacesTableViewController.m
//  TextFaces
//
//  Created by Neo Ighodaro on 11/15/15.
//  Copyright (c) 2015 TapSharp Interactive. All rights reserved.
//

#import "ManageTextFacesTableViewController.h"

@interface ManageTextFacesTableViewController ()
- (void)iCloudStoreDidChange:(NSNotification*)notification;
@end

@implementation ManageTextFacesTableViewController
@synthesize textfaces = _textfaces;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem setTitle:NSLocalizedString(@"Manage", @"Manage")];
    [self.navigationItem setRightBarButtonItem:self.editButtonItem];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    //  Observer to catch changes from iCloud
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(iCloudStoreDidChange:)
                                                 name:NSUbiquitousKeyValueStoreDidChangeExternallyNotification
                                               object:nil];
    [[NSUbiquitousKeyValueStore defaultStore] synchronize];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setTextfaces:[[TextFaces findList:TEXTFACES_LIST_ALL].listItems mutableCopy]];
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.textfaces.count;
}

#pragma mark - Toggle Favorites

- (IBAction)toggleFavoriteButtonClicked:(id)sender {
    CGPoint buttonOriginInTableView = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonOriginInTableView];

    ManageTextFacesCell* cell = (ManageTextFacesCell*)[self.tableView cellForRowAtIndexPath:indexPath];

    NSString* face = [self.textfaces objectAtIndex:indexPath.row];

    BOOL canFav = [[cell.favBtn imageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"unfav-icon"]];

    [cell markAsFavorited:canFav];

    if (canFav) {
        [TextFaces addToFavorites:face];
        [Appirater userDidSignificantEvent:YES];
    } else {
        [TextFaces removeFromFavorites:face];
    }
}

#pragma mark - Display Cells

- (id)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ManageTextFacesCell* cell = [tableView dequeueReusableCellWithIdentifier:@"SingleTextFaceCellIdentifier"];
    
    if ( ! cell) {
        cell = [[ManageTextFacesCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:@"SingleTextFaceCellIdentifier"];
    }
    
    NSString* face = [self.textfaces objectAtIndex:indexPath.row];
    
    [cell.textLabel setText:face];
    [cell markAsFavorited:[TextFaces textfaceExists:face inList:TEXTFACES_LIST_FAVS]];
    
    return cell;
}

#pragma mark - Add Cells

- (IBAction)addNewTextFace:(id)sender {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Add New", @"Add New")
                                                                   message:NSLocalizedString(@"Add a custom TextFace to your list of available TextFaces.", @"Add custom textface.")
                                                            preferredStyle:UIAlertControllerStyleAlert];
 
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Add", @"Add")
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              NSString* textface = ((UITextField*)alert.textFields[0]).text;
                                                              
                                                              if ([NSString isEmpty:textface] == NO) {
                                                                  [TextFaces save:textface toList:TEXTFACES_LIST_ALL];
                                                                  [self.textfaces insertObject:textface atIndex:0];
                                                                  [self.tableView reloadData];
                                                              }
                                                          }];

    UIAlertAction* addAndFaveAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Add & Favorite", @"Add and Mark Favorite")
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * action) {
                                                                 NSString* textface = ((UITextField*)alert.textFields[0]).text;

                                                                 if ([NSString isEmpty:textface] == NO) {
                                                                     [TextFaces save:textface toList:TEXTFACES_LIST_ALL];
                                                                     [TextFaces addToFavorites:textface];
                                                                     [self.textfaces insertObject:textface atIndex:0];
                                                                     [self.tableView reloadData];
                                                                 }
                                                             }];
    
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel")
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * action) {}];
    

    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField){
        textField.placeholder = NSLocalizedString(@"Enter TextFace", @"Enter TextFace");
    }];
    [alert addAction:defaultAction];
    [alert addAction:addAndFaveAction];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - Editing Cells

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    
    if (editing) {
        UIBarButtonItem *addBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                target:self
                                                                                action:@selector(addNewTextFace:)];
        [self.navigationItem setLeftBarButtonItem:addBtn animated:YES];
    } else {
        [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return (indexPath.row == self.textfaces.count) ? NO : YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSString* face = [self.textfaces objectAtIndex:indexPath.row];
        [TextFaces remove:face fromList:TEXTFACES_LIST_ALL];
        [self.textfaces removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

#pragma mark - Moving Cells

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return (indexPath.row == self.textfaces.count) ? NO : YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    NSString* face = [self.textfaces objectAtIndex:sourceIndexPath.row];
    [self.textfaces removeObjectAtIndex:sourceIndexPath.row];
    [self.textfaces insertObject:face atIndex:destinationIndexPath.row];
    [[TextFaces listWithName:TEXTFACES_LIST_ALL textfaces:self.textfaces] save];
}

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)destinationIndexPath {
    if (destinationIndexPath.row < self.textfaces.count)
        return destinationIndexPath;

    return [NSIndexPath indexPathForRow:(self.textfaces.count - 1) inSection:0];
}

#pragma mark - iCloud

- (void)iCloudStoreDidChange:(NSNotification*)notification {
    [TextFaces saveiCloudDataToLocalFile];
    self.textfaces = [[TextFaces findList:TEXTFACES_LIST_ALL withFreshData:YES].listItems mutableCopy];
    [self.tableView reloadData];
}

@end