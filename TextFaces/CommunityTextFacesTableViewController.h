//
//  CommunityTextFacesTableViewController.h
//  TextFaces
//
//  Created by Neo Ighodaro on 11/27/15.
//  Copyright © 2015 TapSharp Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommunityTextFacesTableViewController : UITableViewController
@property(nonatomic,strong) NSMutableArray* textfaces;
- (void)fetchParseData:(NSUInteger)limit skip:(NSUInteger)skip;
- (IBAction)addTextFaceFromSuggestions:(id)sender;
@end
