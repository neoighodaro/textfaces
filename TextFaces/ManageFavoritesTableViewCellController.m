//
//  ManageFavoritesTableViewCellController.m
//  TextFaces
//
//  Created by Neo Ighodaro on 11/16/15.
//  Copyright (c) 2015 TapSharp Interactive. All rights reserved.
//

#import "TextFaces.h"
#import "ManageTextFacesCell.h"
#import "ManageFavoritesTableViewCellController.h"

@interface ManageFavoritesTableViewCellController ()
- (void)iCloudStoreDidChange:(NSNotification*)notification;
@end


@implementation ManageFavoritesTableViewCellController

@synthesize textfaces = _textfaces;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem setTitle:NSLocalizedString(@"Favorites", @"Favorites text")];
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

    NSMutableArray* faces = [[TextFaces findList:TEXTFACES_LIST_FAVS].listItems mutableCopy];
    [self setTextfaces:faces];
    [self.tableView reloadData];
    
    if (self.textfaces.count <= 0) {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"No favorites", @"No  favorites text")
                                                                       message:NSLocalizedString(@"Click \"Select favorites\" to select some favorites.", @"Select some favorites text")
                                                                preferredStyle:UIAlertControllerStyleAlert];
    
        UIAlertAction *addAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Select Favorites", @"Select favorites action")
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction *action) {
                                                              [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"ManageTextFacesTableViewController"]
                                                                                                   animated:YES];
                                                          }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel action")
                                                               style:UIAlertActionStyleCancel
                                                             handler:^(UIAlertAction *action){
                                                                 [self.navigationController popViewControllerAnimated:YES];
                                                             }];        
        
        [alert addAction:addAction];
        [alert addAction:cancelAction];
    
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.textfaces.count;
}

#pragma mark - Display Cells

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ManageTextFacesCell* cell = [tableView dequeueReusableCellWithIdentifier:@"FavoritesCellIdentifier"];
    
    if ( ! cell) {
        cell = [[ManageTextFacesCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:@"FavoritesCellIdentifier"];
    }
    
    cell.textLabel.text = [self.textfaces objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - Editing Cells

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == [self.textfaces count] ) {
        return NO;
    }
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSString* face = [self.textfaces objectAtIndex:indexPath.row];
        [TextFaces removeFromFavorites:face];
        [self.textfaces removeObjectAtIndex:indexPath.row];
        
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}


#pragma mark - Moving Cells

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == [self.textfaces count] ) {
        return NO;
    }
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    NSString* item = [self.textfaces objectAtIndex:sourceIndexPath.row];
    [self.textfaces removeObjectAtIndex:sourceIndexPath.row];
    [self.textfaces insertObject:item atIndex:destinationIndexPath.row];
    
    [[TextFaces listWithName:TEXTFACES_LIST_FAVS textfaces:self.textfaces] save];
}

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath {
    if ([proposedDestinationIndexPath row] < [self.textfaces count]) {
        return proposedDestinationIndexPath;
    }
    NSIndexPath *betterIndexPath = [NSIndexPath indexPathForRow:[self.textfaces count]-1 inSection:0];
    return betterIndexPath;
}

#pragma mark - iCloud

- (void)iCloudStoreDidChange:(NSNotification*)notification {
    [TextFaces saveiCloudDataToLocalFile];
    self.textfaces = [[TextFaces findList:TEXTFACES_LIST_FAVS withFreshData:YES].listItems mutableCopy];
    [self.tableView reloadData];
}

@end
