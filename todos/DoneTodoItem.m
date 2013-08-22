//
//  DoneTodoItem.m
//  todos
//
//  Created by Alexandra Berke on 8/19/13.
//  Copyright (c) 2013 Alexandra Berke. All rights reserved.
//

#import "DoneTodoItem.h"
#import <QuartzCore/QuartzCore.h>

@implementation DoneTodoItem 

- (void) setupLabelwithFrame:(CGRect)frame {
    // setup label
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    
    NSAttributedString *attributedItemString = [[NSAttributedString alloc] initWithString:self.itemString attributes:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:NSUnderlineStyleSingle],NSStrikethroughStyleAttributeName,nil]];
    
    label.attributedText = attributedItemString;
    label.textColor = [UIColor brownColor];
    [self addSubview:label];
}

- (id)initWithFrame:(CGRect)frame withString:(NSString *)itemString{
    self = [self initWithFrame:frame];
    if (self) {
        self.itemString = itemString;
        [self setupLabelwithFrame:CGRectMake(60.0,0,205.0,frame.size.height)];
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
