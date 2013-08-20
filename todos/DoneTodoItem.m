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
    // setup label
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    
    NSAttributedString *attributedItemString = [[NSAttributedString alloc] initWithString:self.itemString attributes:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:NSUnderlineStyleSingle],NSStrikethroughStyleAttributeName,nil]];
    
    label.attributedText = attributedItemString;
    [self addSubview:label];
}

- (id)initWithFrame:(CGRect)frame withString:(NSString *)itemString{
    self = [self initWithFrame:frame];
    if (self) {
        self.itemString = itemString;
        [self setupLabelwithFrame:CGRectMake(0,0,frame.size.width,frame.size.height)];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
