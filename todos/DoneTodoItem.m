//
//  DoneTodoItem.m
//  todos
//
//  Created by Alexandra Berke on 8/19/13.
//  Copyright (c) 2013 Alexandra Berke. All rights reserved.
//

#import "DoneTodoItem.h"

@implementation DoneTodoItem 

- (void) setupLabelwithFrame:(CGRect)frame {
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    
    NSAttributedString *attributedItemString = [[NSAttributedString alloc] initWithString:self.itemString attributes:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:NSUnderlineStyleSingle],NSStrikethroughStyleAttributeName,nil]];
    
    label.attributedText = attributedItemString;
    label.textColor = [UIColor brownColor];
    [self addSubview:label];
}

- (id)initWithFrame:(CGRect)frame withString:(NSString *)itemString{
    self = [super initWithFrame:frame withString:itemString];
    if (self) {
        self.itemString = itemString;
        [self setupLabelwithFrame:CGRectMake(0.0, 0.0, frame.size.width, frame.size.height)];
    }
    return self;
}


@end
