//
//  ActionViewController.m
//  TextFacesAction
//
//  Created by Neo Ighodaro on 11/24/15.
//  Copyright © 2015 TapSharp Interactive. All rights reserved.
//

#import "TextFaces.h"
#import "NSString+Additions.h"
#import "ActionViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface ActionViewController ()
- (void)addNewTextFace:(NSString *)defaultText;
@end

@implementation ActionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addGradientToView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSExtensionItem* item = self.extensionContext.inputItems[0];
    NSItemProvider* itemProvider = item.attachments[0];
    
    if ([itemProvider hasItemConformingToTypeIdentifier:(NSString *)kUTTypePlainText]) {
        [itemProvider loadItemForTypeIdentifier:(NSString *)kUTTypePlainText options:nil completionHandler:^(NSString* item, NSError* error) {
            if (item) {
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    [self addNewTextFace:item];
                }];
            }
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)done {
    [self.extensionContext completeRequestReturningItems:self.extensionContext.inputItems completionHandler:nil];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - Add Cells

- (void)addNewTextFace:(NSString *)defaultText {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Add New", @"Add New")
                                                                   message:NSLocalizedString(@"Add a custom TextFace to your list of available TextFaces.", @"Add custom textface.")
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Add", @"Add")
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              NSString* textface = ((UITextField*)alert.textFields[0]).text;
                                                              
                                                              if ([textface isKindOfClass:[NSString class]] && [NSString isEmpty:textface] == NO) {
                                                                  [TextFaces save:textface toList:TEXTFACES_LIST_ALL];
                                                              }
                                                              
                                                             [alert dismissViewControllerAnimated:YES completion:nil];
                                                              [self done];
                                                          }];
    
    UIAlertAction* addAndFaveAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Add & Favorite", @"Add and Mark Favorite")
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * action) {
                                                                 NSString* textface = ((UITextField*)alert.textFields[0]).text;
                                                                 
                                                                 if ([NSString isEmpty:textface] == NO) {
                                                                     [alert dismissViewControllerAnimated:YES completion:nil];
                                                                     [self done];
                                                                     [TextFaces save:textface toList:TEXTFACES_LIST_ALL];
                                                                     [TextFaces addToFavorites:textface];
                                                                 }
                                                             }];
    
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel")
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * action) {
                                                             [alert dismissViewControllerAnimated:YES completion:nil];
                                                             [self done];
                                                         }];
    
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField){
        textField.text = defaultText;
        textField.placeholder = NSLocalizedString(@"Enter TextFace", @"Enter TextFace");
    }];
    [alert addAction:defaultAction];
    [alert addAction:addAndFaveAction];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}


- (void)addGradientToView {
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.view.bounds;
    gradient.colors = [NSArray arrayWithObjects:
                       (id)[[UIColor colorWithRed:255/255.0f green:94/255.0f blue:58/255.0f alpha:1] CGColor],
                       (id)[[UIColor colorWithRed:255/255.0f green:42/255.0f blue:104/255.0f alpha:1] CGColor],
                       nil];
    [self.view.layer insertSublayer:gradient atIndex:0];
}


@end
