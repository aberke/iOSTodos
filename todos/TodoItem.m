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
    self = [super initWithFrame:frame];
    if (self) {
        
        [self configureConstants];
        
        self.itemString = itemString;
        [self setupDeleteButton];
    }
    return self;
}
- (void) configureConstants{
    _labelMargin = 60.0f;
    _deleteButtonSize = 20.0f;
}
- (void) setupLabel {
    float labelWidth = (self.frame.size.width - (2*_labelMargin));
    _label = [[UILabel alloc] initWithFrame:CGRectMake(_labelMargin, 0, labelWidth, self.frame.size.height)];
    _label.text = self.itemString;
    _label.backgroundColor = [UIColor clearColor];
    [self addSubview:_label];
    
}
- (void) setupDeleteButton {
    _deleteButtonSize = 20.0f;
    float leftMargin = self.frame.size.width - (_deleteButtonSize + 5.0);
    float topMargin = (self.frame.size.height - _deleteButtonSize)/2;
    CGRect buttonFrame = CGRectMake(leftMargin, topMargin, _deleteButtonSize, _deleteButtonSize);
    UIButton *button = [UIButton buttonWithFrame:buttonFrame withImageName:@"delete_icon.png" withCallback:@selector(deleteItem) withTarget:self];
    
    //add the button to the view
    [self addSubview:button];
}

- (void) deleteItem {
    NSString *dialogMessage = [NSString stringWithFormat:@"You can do it... %@",self.itemString];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Delete this item?" message:dialogMessage delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Just Delete it",nil];
    [alert show];
}
/* called when user answers alert that's shown when delete button pressed */
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1 && self.deletedCallback) {
        self.deletedCallback(self);
    }
}

#pragma mark view helper methods
- (CGFloat)height{
    return self.frame.size.height;
}

@end
