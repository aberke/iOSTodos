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

@implementation undoneTodoItem

- (id)initWithFrame:(CGRect)frame withString:(NSString *)itemString{
    self = [super initWithFrame:frame withString:itemString];
    if (self){
        
        float todoItemButtonWidth = 20.0f;
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
        
    }
    return self;
}

- (void) setupDeleteButtonWithFrame:(CGRect) frame{
    UIButton *button = [UIButton buttonWithFrame:frame withImageName:@"delete_icon.png" withCallback:@selector(deleteItem) withTarget:self];
    
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

@end
