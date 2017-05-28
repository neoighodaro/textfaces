//
//  TextFaces.h
//  TextFaces
//
//  Created by Neo Ighodaro on 11/11/15.
//  Copyright (c) 2015 TapSharp Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DEFAULT_TEXTFACES @[@"¯\\_(ツ)_/¯", @"(⌐■_■)", @"(⌐■_■) ( •_•) ⌐■-■ ( •_•)", @"๏̯͡๏﴿", @"q(●‿●)p", @"╭∩╮(-_-)╭∩╮", @"ಠ_ಠ", @"ಠ‿ಠ", @"ಠ╭╮ಠ", @"(ง’̀-’́)ง", @"ꏱ𐐃.𐐃ꎍ", @"(ಥ﹏ಥ)", @"ᕕ( ᐛ )ᕗ", @"◉_◉", @"( ◕ ◡ ◕ )", @"(╯°□°）╯︵ ┻━┻", @"┬─┬ノ( º _ ºノ)", @"(ு८ு_ .:)", @"ヽ(｀Д´)ﾉ", @"( ͡° ͜ʖ ͡°)", @"╿︡O͟-O︠╿", @"ʕ•ᴥ•ʔ", @"ʘ̃˻ʘ̃", @"(☞ﾟヮﾟ)☞ ", @"(ᵔᴥᵔ)", @"ヽ༼ຈل͜ຈ༽ﾉ", @"(´･ω･`)", @"(・_・、)(_・、 )(・、 )", @"ლ,ᔑ•ﺪ͟͠•ᔐ.ლ", @"⨀⦢⨀", @"º╲˚\\╭ᴖ_ᴖ╮/˚╱º", @"º(•♠•)º"]

#define TEXTFACES_APP_GROUP_ID @"group.com.tapsharp.TextFaces"
#define TEXTFACES_APP_DATA_FILENAME @"textfaces.data"

#define TEXTFACES_NAME_KEY  @"textfacesName"
#define TEXTFACES_ITEMS_KEY @"textfacesItems"

#define TEXTFACE_TAP_NOTIFICATION @"textfaceButtonTapEvent"
#define TEXTFACE_PRESS_NOTIFICATION @"textfaceButtonPressEvent"
#define TEXTFACES_DATA_DID_CHANGE_NOTIFICATION @"textfacesDataDidChange"

#define TEXTFACES_LIST_ALL NSLocalizedString(@"All", @"All")
#define TEXTFACES_LIST_FAVS NSLocalizedString(@"Favorites", @"Favorites")

#define TEXTFACES_ITUNES_APP_ID @"1062327380"
#define TEXTFACES_SHARE_URL @"https://appsto.re/us/urDu_.i"
#define TEXTFACES_SHARE_TEXT NSLocalizedString(@"Type awesome TextFaces on your #iPhone #iPad #iOS using @TextFacesApp (⌐■_■)\n\nGet TextFaces", @"Share text")

#define TEXTFACES_TINT_COLOR [UIColor colorWithRed:255/255.0f green:68/255.0f blue:80/255.0f alpha:1]

static NSArray* allStoredTextFaces;
static NSString* lastKnownDataStoreModifiedDate;

@interface TextFaces : NSObject<NSCoding>
@property(nonatomic,copy) NSString* listName;
@property(nonatomic,strong) NSArray* listItems;
+ (id)listWithName:(NSString *)name textfaces:(NSArray *)textfaces;
+ (NSArray *)findAll;
+ (NSArray *)findAllFromiCloud;
+ (TextFaces *)findList:(NSString *)name;
+ (TextFaces *)findList:(NSString *)name withFreshData:(BOOL)requiresFreshData;
+ (void)addToFavorites:(NSString *)textface;
+ (void)removeFromFavorites:(NSString *)textface;
+ (BOOL)save:(NSString *)textface toList:(NSString *)group;
+ (BOOL)remove:(NSString *)textface fromList:(NSString *)group;
+ (void)reset;
+ (NSString *)dataStoreLastModified;
+ (BOOL)textfaceExists:(NSString *)textface inList:(NSString *)list;
- (id)initWithList:(NSString *)name textfaces:(NSArray *)textfaces;
- (BOOL)save;
+ (BOOL)saveiCloudDataToLocalFile;
@end
