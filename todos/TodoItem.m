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
    
        self.layer.borderWidth = 1;
        self.layer.borderColor = [UIColor blackColor].CGColor;
        
        self.itemString = itemString;
        [self setupDeleteButton];
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

- (void) setupDeleteButton {
    float buttonSize = 20.0;
    float topMargin = (self.frame.size.height - buttonSize)/2;
    CGRect buttonFrame = CGRectMake(self.frame.size.width - (buttonSize + 5.0), topMargin, buttonSize, buttonSize);
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
