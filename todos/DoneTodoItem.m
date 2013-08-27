//
//  DoneTodoItem.m
//  todos
//
//  Created by Alexandra Berke on 8/19/13.
//  Copyright (c) 2013 Alexandra Berke. All rights reserved.
//

#import "DoneTodoItem.h"

@implementation DoneTodoItem 

- (void) setupLabel {
    [super setupLabel];
    NSAttributedString *attributedItemString = [[NSAttributedString alloc] initWithString:self.itemString attributes:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:NSUnderlineStyleSingle],NSStrikethroughStyleAttributeName,nil]];    
    _label.attributedText = attributedItemString;
    _label.textColor = [UIColor brownColor];
}

- (id)initWithFrame:(CGRect)frame withString:(NSString *)itemString{
    self = [super initWithFrame:frame withString:itemString];
    if (self) {
        self.itemString = itemString;
        [self setupLabel];
    }
    return self;
}


@end
