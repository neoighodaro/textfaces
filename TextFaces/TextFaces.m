//
//  TextFaces.m
//  TextFaces
//
//  Created by Neo Ighodaro on 11/11/15.
//  Copyright (c) 2015 TapSharp Interactive. All rights reserved.
//

#import "TextFaces.h"


@interface TextFaces () {
    BOOL _canSaveData;
}
+ (NSURL *)textfacesDataURL;
+ (BOOL)saveData:(NSMutableArray *)faces;
@end


@implementation TextFaces

@synthesize listName = _listName;
@synthesize listItems = _listItems;


#pragma mark - Initializers

+ (id)listWithName:(NSString *)name textfaces:(NSArray *)textfaces {
    return [[[self class] alloc] initWithList:name textfaces:textfaces];
}

- (id)initWithList:(NSString *)name textfaces:(NSArray *)textfaces {
    self = [super init];
    if (self) {
        _canSaveData = YES;

        self.listName = name;
        self.listItems = textfaces;
    }
    return self;
}


#pragma mark - Misc

+ (NSString *)dataStoreLastModified {
    NSDate *fileDate;
    NSError* error;
    
    [[self.class textfacesDataURL] getResourceValue:&fileDate forKey:NSURLContentModificationDateKey error:&error];

    if ( ! error) {
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        return [formatter stringFromDate:fileDate];
    }
    
    return nil;
}


#pragma mark - Find

+ (TextFaces *)findList:(NSString *)name {
    NSMutableArray* lists = (NSMutableArray *)[[self class] findAll];

    for (TextFaces* faces in lists) {
        if ([faces.listName isEqualToString:name]) return faces;
    }

    return NULL;
}

+ (TextFaces *)findList:(NSString *)name withFreshData:(BOOL)requiresFreshData {
    allStoredTextFaces = nil;

    NSMutableArray* lists = (NSMutableArray *)[[self class] findAll];
    
    for (TextFaces* faces in lists) {
        if ([faces.listName isEqualToString:name]) return faces;
    }
    
    return NULL;
}

+ (NSArray *)findAllFromiCloud {
    NSData* dataContents = [[NSUbiquitousKeyValueStore defaultStore] objectForKey:@"TEXTFACES"];
    return dataContents ? [NSKeyedUnarchiver unarchiveObjectWithData:dataContents] : nil;
}

+ (NSArray *)findAll {
    if (lastKnownDataStoreModifiedDate && ! [[TextFaces dataStoreLastModified] isEqualToString:lastKnownDataStoreModifiedDate]) {
        allStoredTextFaces = nil;
    }
    
    if (allStoredTextFaces == nil) {
        NSData* data;
        NSData* iCloudData = Nil;

        data = iCloudData ? iCloudData : [NSData dataWithContentsOfURL:[self textfacesDataURL]];

        if ( ! data) {
            [self reset];
            return [self.class findAll];
        }
        
        allStoredTextFaces = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        lastKnownDataStoreModifiedDate = [self dataStoreLastModified];
    }

    return allStoredTextFaces;
}

+ (BOOL)textfaceExists:(NSString *)textface inList:(NSString *)list {
    TextFaces* faces = [self.class findList:list];
    return (faces && [faces.listItems indexOfObject:textface] != NSNotFound);
}

#pragma mark - Delete data

+ (void)removeFromFavorites:(NSString *)textface {
    [self.class remove:textface fromList:TEXTFACES_LIST_FAVS];
}

+ (BOOL)remove:(NSString *)textface fromList:(NSString *)group {
    BOOL madeChanges = NO;
    NSMutableArray* faces = (NSMutableArray *)[self.class findAll];
    
    for (TextFaces* face in faces) {
        if ([face.listName isEqualToString:group]) {
            if ([face.listItems indexOfObject:textface] != NSNotFound) {
                NSMutableArray* listItems = [face.listItems mutableCopy];
                [listItems removeObject:textface];
                
                face.listItems = listItems;
                madeChanges = YES;
            }
            
            break;
        }
    }
    
    if (madeChanges && [group isEqualToString:TEXTFACES_LIST_ALL]) {
        [self removeFromFavorites:textface];
    }
    
    return madeChanges ? [self.class saveData:faces toiCloud:YES] : NO;
}

#pragma mark - Save Data

+ (void)addToFavorites:(NSString *)textface {
    [self.class save:textface toList:TEXTFACES_LIST_FAVS];
}

- (BOOL)save {
    if (_canSaveData != YES) {
        return NO;
    }
    
    BOOL foundMatch = NO;
    
    NSMutableArray* faces = (NSMutableArray *)[self.class findAll];

    for (TextFaces* face in faces) {
        if ([face.listName isEqualToString:self.listName]) {
            [faces replaceObjectAtIndex:[faces indexOfObject:face] withObject:self];
            foundMatch = YES;
            break;
        }
    }
    
    if (foundMatch == NO) {
        [faces addObject:self];
    }

    return [self.class saveData:faces toiCloud:YES];
}

+ (BOOL)save:(NSString *)textface toList:(NSString *)listName {
    BOOL madeChanges = NO;
    NSMutableArray* faces = (NSMutableArray *)[[self class] findAll];

    for (TextFaces* face in faces) {
        if ([face.listName isEqualToString:listName]) {
            if ([face.listItems indexOfObject:textface] == NSNotFound) {
                NSMutableArray* listItems = [face.listItems mutableCopy];
                [listItems insertObject:textface atIndex:0];

                face.listItems = listItems;
                madeChanges = YES;
            }

            break;
        }
    }
    
    return madeChanges ? [[self class] saveData:faces toiCloud:YES] : NO;
}

+ (BOOL)saveiCloudDataToLocalFile {
    NSArray* fileData = [self.class findAllFromiCloud];
    
    if ( ! fileData) return NO;
    
    return [self.class saveData:[fileData mutableCopy] toiCloud:NO];
}

+ (void)reset {
    [[NSFileManager defaultManager] removeItemAtURL:[self textfacesDataURL] error:nil];
    
    id allTextFaces = [self.class listWithName:TEXTFACES_LIST_ALL textfaces:DEFAULT_TEXTFACES];
    id favTextFaces = [self.class listWithName:TEXTFACES_LIST_FAVS textfaces:@[]];
    
    [self.class saveData:[NSMutableArray arrayWithObjects:allTextFaces, favTextFaces, nil] toiCloud:YES];
}

#pragma mark - Private

+ (BOOL)saveData:(NSMutableArray *)faces toiCloud:(BOOL)saveToiCloud {
    if (saveToiCloud == YES) {
        NSData* fileData = [NSKeyedArchiver archivedDataWithRootObject:faces];
        [[NSUbiquitousKeyValueStore defaultStore] setObject:fileData forKey:@"TEXTFACES"];
    }
    
    return [self.class saveData:faces];
}

+ (BOOL)saveData:(NSMutableArray *)faces {
    NSData* fileData = [NSKeyedArchiver archivedDataWithRootObject:faces];

    BOOL savedData = [fileData writeToURL:[self.class textfacesDataURL] atomically:YES];

    if (savedData) {
        allStoredTextFaces = nil;
        lastKnownDataStoreModifiedDate = [self.class dataStoreLastModified];
    }

    return savedData;
}

+ (NSURL *)textfacesDataURL {
    NSURL* containerURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:TEXTFACES_APP_GROUP_ID];
    return [containerURL URLByAppendingPathComponent:TEXTFACES_APP_DATA_FILENAME];
}

#pragma mark - NSCoder

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (self) {
        self.listName  = [decoder decodeObjectForKey:TEXTFACES_NAME_KEY];
        self.listItems = [decoder decodeObjectForKey:TEXTFACES_ITEMS_KEY];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.listName forKey:TEXTFACES_NAME_KEY];
    [encoder encodeObject:self.listItems forKey:TEXTFACES_ITEMS_KEY];
}

#pragma mark - Debug

- (NSString *)description {
    return [NSString stringWithFormat:@"List Name: %@ - List Items: %@", self.listName, self.listItems];
}

@end
