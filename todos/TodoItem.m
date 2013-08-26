//
//  TodoItem.m
//  todos
//
//  Created by Alexandra Berke on 8/25/13.
//  Copyright (c) 2013 Alexandra Berke. All rights reserved.
//

#import "TodoItem.h"
#import "TodoUIColors.h"
#import "UIButtonExtension.h"
#import <QuartzCore/QuartzCore.h>

@implementation TodoItem

- (id) initWithFrame:(CGRect)frame withString:(NSString *)itemString{
    self = [self initWithFrame:frame];
    if (self) {
        //self.layer.borderWidth = 1;
        self.layer.borderColor = [UIColor blackColor].CGColor;
        
        self.itemString = itemString;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void) deleteItem {
    if (self.deletedCallback) {
        self.deletedCallback(self);
    }
}


@end
