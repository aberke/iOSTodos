//
//  TodoDocument.m
//  todos
//
//  Created by Alexandra Berke on 8/26/13.
//  Copyright (c) 2013 Alexandra Berke. All rights reserved.
//

#import "TodoDocument.h"

@interface TodoDocument()

@property (nonatomic, strong) NSString *itemString;

@end

@implementation TodoDocument


#pragma mark Accessors

- (NSString *)itemString{
    return self.itemString;
}
- (void)setItemString:(NSString *)itemString{
    if([self.itemString isEqualToString:itemString]) return;
    
    NSString *oldItemString = self.itemString;
    self.itemString = itemString;
    [self.undoManager setActionName:@"Item Change"];
    [self.undoManager registerUndoWithTarget:self selector:@selector(setItemString:) object:oldItemString];
}

@end
