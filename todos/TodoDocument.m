//
//  TodoDocument.m
//  todos
//
//  Created by Alexandra Berke on 8/26/13.
//  Copyright (c) 2013 Alexandra Berke. All rights reserved.
//

#import "TodoDocument.h"

#define ITEMSTRING_FILENAME       @"todo.itemstring"

@interface TodoDocument()

@end

@implementation TodoDocument

@synthesize itemString = _itemString;


/* When an application opens a document (at the user’s request), UIDocument reads the contents of the document file and calls the loadFromContents:ofType:error: method, passing in an object encapsulating the document data. */
-(BOOL)loadFromContents:(id)contents ofType:(NSString *)typeName error:(NSError **)outError {
    self.fileWrapper = (NSFileWrapper *)contents;
    // The rest will be lazy loaded...
    _itemString = nil;
  
    return YES;
}
/* When a document is closed or when it is automatically saved, UIDocument sends the document object a contentsForType:error: message. */
-(id)contentsForType:(NSString *)typeName error:(NSError **)outError {
    
    if (self.fileWrapper == nil) {
        self.fileWrapper = [[NSFileWrapper alloc] initDirectoryWithFileWrappers:nil];
    }
    NSDictionary *fileWrappers = [self.fileWrapper fileWrappers];
    if (([fileWrappers objectForKey:ITEMSTRING_FILENAME] == nil) && (_itemString != nil)) {
        NSData *itemStringData = [_itemString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];
        NSFileWrapper *itemStringWrapper = [[NSFileWrapper alloc] initRegularFileWithContents:itemStringData];
        [itemStringWrapper setPreferredFilename:ITEMSTRING_FILENAME];
        [self.fileWrapper addFileWrapper:itemStringWrapper];
    }
    return  self.fileWrapper;
}


#pragma mark Accessors

- (NSString *)itemString{
    NSLog(@"itemString");
    if (_itemString == nil){
        if (self.fileWrapper != nil){
            NSFileWrapper * fileWrapper = [self.fileWrapper.fileWrappers objectForKey:ITEMSTRING_FILENAME];
            if (!fileWrapper) {
                NSLog(@"Unexpected error: Couldn't find %@ in file wrapper!", ITEMSTRING_FILENAME);
                return nil;
            }
            NSData * data = [fileWrapper regularFileContents];
            _itemString = [[NSString alloc] initWithBytes:[data bytes] length:[data length] encoding:NSUTF8StringEncoding];
        } else {
            _itemString = @"";
        }
    }
    return _itemString;
}
- (void)setItemString:(NSString *)string{
    if([_itemString isEqualToString:string]) return;
    
    NSString *oldItemString = _itemString;
    _itemString = string;
    [self.undoManager setActionName:@"Item Change"];
    [self.undoManager registerUndoWithTarget:self selector:@selector(setItemString:) object:oldItemString];
}

@end
