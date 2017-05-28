//
//  KeyboardTexfFacesListViewController.m
//  TextFaces
//
//  Created by Neo Ighodaro on 11/11/15.
//  Copyright (c) 2015 TapSharp Interactive. All rights reserved.
//

#import "KeyboardTexfFacesListViewController.h"


@interface KeyboardTexfFacesListViewController ()
@property(nonatomic,strong) NSMutableArray* textfaces;
- (void)iCloudStoreDidChange:(NSNotification *)notification;
@end

@implementation KeyboardTexfFacesListViewController

@synthesize textfaces = _textfaces;
@synthesize model = _model;

+ (id)initWithModel:(TextFaces *)model {
    id keyboard = [[KeyboardTexfFacesListViewController alloc] initWithStyle:UITableViewStylePlain];
    [keyboard setModel:model];

    return keyboard;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    //  Observer to catch changes from iCloud
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(iCloudStoreDidChange:)
                                                 name:NSUbiquitousKeyValueStoreDidChangeExternallyNotification
                                               object:nil];
    [[NSUbiquitousKeyValueStore defaultStore] synchronize];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self reloadTableData:nil];
}

- (void)reloadTableData:(NSNotification *)notification {
    self.model = [TextFaces findList:self.model.listName];
    self.textfaces = [NSMutableArray arrayWithArray:self.model.listItems];
    [self.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary* payload = @{@"text" : self.textfaces[indexPath.row]};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:TEXTFACE_TAP_NOTIFICATION
                                                        object:nil
                                                      userInfo:payload];
}

- (void)labelPressed:(UITapGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        NSDictionary* payload = @{@"text" : ((UITableViewCell*)recognizer.view).textLabel.text};
        
        [[NSNotificationCenter defaultCenter] postNotificationName:TEXTFACE_PRESS_NOTIFICATION
                                                            object:nil
                                                          userInfo:payload];
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.textfaces.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* cellIdentifier = @"reuseTextfaceIdentifier";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    [cell setBackgroundColor:[UIColor clearColor]];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    [cell.textLabel setTextColor:[UIColor colorWithWhite:1 alpha:0.8f]];
    [cell.textLabel setText:[self.textfaces objectAtIndex:indexPath.row]];
    [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
    [cell.textLabel sizeToFit];
    
    UILongPressGestureRecognizer* gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(labelPressed:)];

    gesture.minimumPressDuration = 0.27;
    gesture.numberOfTouchesRequired = 1;
    [cell addGestureRecognizer:gesture];
    
    return cell;
}


#pragma mark - iCloud

- (void)iCloudStoreDidChange:(NSNotification*)notification {
    [TextFaces saveiCloudDataToLocalFile];
    [self reloadTableData:notification];
}

@end
