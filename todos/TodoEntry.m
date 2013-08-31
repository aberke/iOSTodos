//
//  TodoEntry.m
//  todos
//
//  Created by Alexandra Berke on 8/27/13.
//  Copyright (c) 2013 Alexandra Berke. All rights reserved.
//

#import "TodoEntry.h"

@implementation TodoEntry

- (id)initWithFileURL:(NSURL *)fileURL itemString:(NSString *)itemString {
    
    if ((self = [super init])) {
        self.fileURL = fileURL;
        self.itemString = itemString;
        NSLog(@"new TodoEntry with itemString: %@",itemString);
    }
    return self;
}
@end
