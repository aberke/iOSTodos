//
//  undoneTodoItem.m
//  todos
//
//  Created by Alexandra Berke on 8/18/13.
//  Copyright (c) 2013 Alexandra Berke. All rights reserved.
//

#import "undoneTodoItem.h"
#import "TodoItem.h"
#import <QuartzCore/QuartzCore.h>

@implementation undoneTodoItem: UIView

- (void) doneButtonPressed {
    if(self.doneCallback){
        self.doneCallback(self);
    }
}
- (void) deleteButtonPressed {
    if(self.deletedCallback){
        self.deletedCallback(self);
    }
}
- (void) setupDeleteButtonWithFrame:(CGRect) frame{
    //create the button
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    //set the position of the button
    button.frame = frame;
    
    //set the button's title
    [button setTitle:@"X" forState:UIControlStateNormal];
    
    //listen for clicks
    [button addTarget:self action:@selector(deleteButtonPressed)
     forControlEvents:UIControlEventTouchUpInside];
    
    //add the button to the view
    [self addSubview:button];
}
- (void)setupDoneButtonWithFrame:(CGRect)frame{
    
    //create the button
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    //set the position of the button
    button.frame = frame;
    
    //set the button's title
    [button setTitle:@"D" forState:UIControlStateNormal];
    
    //listen for clicks
    [button addTarget:self action:@selector(doneButtonPressed)
     forControlEvents:UIControlEventTouchUpInside];
    
    //add the button to the view
    [self addSubview:button];
    
    
    
}
- (void)setupLabelWithFrame:(CGRect)frame {
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = self.itemString;
    [self addSubview:label];
}

- (id)initWithFrame:(CGRect)frame withString:(NSString *)itemString withDoneCallback:(ItemCallback)doneCallback withDeleteCallback:(ItemCallback)deleteCallback
{
    self = [self initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.layer.borderWidth = 1;
        self.layer.borderColor = [UIColor blackColor].CGColor;
        
        self.itemString = itemString;
        
        self.doneCallback = doneCallback;
        self.deletedCallback = deleteCallback;
        
        
        float todoItemDoneButtonWidth = 20.0f;
        float todoItemDoneButtonHeight = 20.0f;
        
        float todoItemDeleteButtonWidth = 15.0f;
        float todoItemDeleteButtonHeight = 15.0f;
        
        [self setupDoneButtonWithFrame:CGRectMake(0,0,todoItemDoneButtonWidth,todoItemDoneButtonHeight)];
        
        [self setupLabelWithFrame:CGRectMake(todoItemDoneButtonWidth,0,(frame.size.width - todoItemDoneButtonWidth - todoItemDeleteButtonWidth), (frame.size.height))];

        [self setupDeleteButtonWithFrame:CGRectMake((frame.size.width-todoItemDeleteButtonWidth), 0, todoItemDeleteButtonWidth, todoItemDeleteButtonHeight)];
    
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
