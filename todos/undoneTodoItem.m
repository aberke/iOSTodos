//
//  undoneTodoItem.m
//  todos
//
//  Created by Alexandra Berke on 8/18/13.
//  Copyright (c) 2013 Alexandra Berke. All rights reserved.
//

#import "undoneTodoItem.h"
#import "TodoItem.h"
#import "TodoUIColors.h"
#import "UIButtonExtension.h"
#import <QuartzCore/QuartzCore.h>

@implementation undoneTodoItem: UIView

- (id)initWithFrame:(CGRect)frame withString:(NSString *)itemString{
    self = [self initWithFrame:frame];
    if (self){
        
        //self.layer.borderWidth = 1;
        self.layer.borderColor = [UIColor blackColor].CGColor;
        
        self.itemString = itemString;
        
        
        float todoItemButtonWidth = 20.0f;
        float todoItemButtonHeight = 20.0f;
        float todoItemMargin = 10.0f;
        
        float upDownButtonsWidth = 30.0f;
        float upDownButtonsHeight = frame.size.height - (2*todoItemMargin);
        
        float todoItemLabelWidth = frame.size.width*(2.0/3);
        float todoItemSliderWidth = todoItemLabelWidth + todoItemButtonWidth;
        
        float itemOriginX = 0.0f;
        
        [self setupUpDownButtonsWithFrame:CGRectMake(itemOriginX,todoItemMargin,upDownButtonsWidth,upDownButtonsHeight)];
        itemOriginX += (upDownButtonsWidth +todoItemMargin);
        
        
        [self setupLabelWithFrame:CGRectMake((itemOriginX+todoItemButtonWidth),0,todoItemLabelWidth, (frame.size.height))];
        [self setupSliderWithFrame:CGRectMake(itemOriginX,todoItemMargin, todoItemSliderWidth, 10.0)];
        itemOriginX += (todoItemSliderWidth+todoItemButtonWidth);
        
        [self setupDeleteButtonWithFrame:CGRectMake(itemOriginX, todoItemMargin, todoItemButtonWidth, todoItemButtonHeight)];
        
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame withString:(NSString *)itemString withDoneCallback:(ItemCallback)doneCallback withDeleteCallback:(ItemCallback)deleteCallback{
    self = [self initWithFrame:frame withString:itemString];
    if (self) {
        self.doneCallback = doneCallback;
        self.deletedCallback = deleteCallback;
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    return self;
}

- (void) setupDeleteButtonWithFrame:(CGRect) frame{
    UIButton *button = [UIButton buttonWithFrame:frame withImageName:@"delete_icon.png" withCallback:@selector(deleteButtonPressed) withTarget:self];
    
    //add the button to the view
    [self addSubview:button];
}
- (void)setupUpDownButtonsWithFrame:(CGRect)frame{
    //setup up button
    CGRect buttonFrame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, (frame.size.height/2));
    UIButton *upButton = [UIButton buttonWithFrame:buttonFrame withImageName:@"arrow-up-brown.png" withCallback:@selector(upButtonPressed) withTarget:self];
    [self addSubview:upButton];
    
    // setup down button
    buttonFrame.origin.y = frame.origin.y + buttonFrame.size.height;
    UIButton *downButton = [UIButton buttonWithFrame:buttonFrame withImageName:@"arrow-down-brown.png" withCallback:@selector(downButtonPressed) withTarget:self];
    [self addSubview:downButton];
}
- (void)sliderAction:(id)sender{
    UISlider *slider = (UISlider *)sender;
    if(([slider value] == slider.maximumValue) && self.doneCallback){
        self.doneCallback(self);
    }
}
- (void) setupSliderWithFrame:(CGRect)frame{
    UISlider *slider = [[UISlider alloc] initWithFrame:frame];
    [slider addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventValueChanged];
    [slider setBackgroundColor:[UIColor clearColor]];
    [slider setThumbImage: [UIImage imageNamed:@"icon-checkmark.png"] forState:UIControlStateNormal];
    
    UIImage *yellowTrack = [[UIImage imageNamed:@"yellowslide.png"]
                                 stretchableImageWithLeftCapWidth:4.0 topCapHeight:0.0];
    UIImage *clearTrack = [[UIImage imageNamed: @"transparent-slider.png"] stretchableImageWithLeftCapWidth:4.0 topCapHeight:0.0];
    
    [slider setMinimumTrackImage:yellowTrack forState:UIControlStateNormal];
    [slider setMaximumTrackImage:clearTrack forState:UIControlStateNormal];
    
    slider.minimumValue = 0.0;
    slider.maximumValue = 50.0;
    slider.continuous = YES;
    slider.value = 0.0;
    [self addSubview:slider];
    
}
- (void)setupLabelWithFrame:(CGRect)frame {
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = self.itemString;
    label.textColor = [UIColor redColor];
    label.backgroundColor = [UIColor clearColor];
    [self addSubview:label];
     
}

-(void)upButtonPressed {
    if (self.upCallback){
        self.upCallback(self);
    }
}
-(void)downButtonPressed{
    if (self.downCallback){
        self.downCallback(self);
    }
}

- (void) deleteButtonPressed {
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

@end
