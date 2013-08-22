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
#import <QuartzCore/QuartzCore.h>

@implementation undoneTodoItem: UIView


- (void) setupDeleteButtonWithFrame:(CGRect) frame{
    //create the button
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    //set the position of the button
    button.frame = frame;
    
    button.backgroundColor = [UIColor clearColor];
    [button setImage: [UIImage imageNamed:@"delete_icon.png"] forState:UIControlStateNormal];
    
    //listen for clicks
    [button addTarget:self action:@selector(deleteButtonPressed)
     forControlEvents:UIControlEventTouchUpInside];
    
    //add the button to the view
    [self addSubview:button];
}
- (void)setupUpDownButtonsWithFrame:(CGRect)frame{
    
    //setup up button
    CGRect buttonFrame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, (frame.size.height/2));
    UIButton *upButton = [UIButton buttonWithType:UIButtonTypeCustom];
    upButton.frame = buttonFrame;
    [upButton setImage:[UIImage imageNamed:@"arrow-up-brown.png"] forState:UIControlStateNormal];
    [upButton addTarget:self action:@selector(upButtonPressed)
     forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:upButton];
    
    // setup down button
    buttonFrame.origin.y = frame.origin.y + buttonFrame.size.height;
    UIButton *downButton = [UIButton buttonWithType:UIButtonTypeCustom];
    downButton.frame = buttonFrame;
    [downButton setImage:[UIImage imageNamed:@"arrow-down-brown.png"] forState:UIControlStateNormal];
    [downButton addTarget:self action:@selector(downButtonPressed) forControlEvents:UIControlEventTouchUpInside];
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
- (id)initWithFrame:(CGRect)frame withString:(NSString *)itemString{
    self = [self initWithFrame:frame];
    if (self){
        
        self.layer.borderWidth = 1;
        self.layer.borderColor = [UIColor blackColor].CGColor;
        
        self.itemString = itemString;
        
        
        float todoItemButtonWidth = 20.0f;
        float todoItemButtonHeight = 20.0f;
        float todoItemButtonMargin = 5.0f;
        
        float upDownButtonsWidth = 30.0f;
        float upDownButtonsHeight = frame.size.height - (2*todoItemButtonMargin);
        
        float todoItemSliderWidth = frame.size.width - (3*todoItemButtonWidth);
        float todoItemLabelWidth = frame.size.width - (4*todoItemButtonWidth + todoItemButtonMargin);
        
        float itemOriginX = 0.0f;
        
        [self setupUpDownButtonsWithFrame:CGRectMake(itemOriginX,todoItemButtonMargin,upDownButtonsWidth,upDownButtonsHeight)];
        itemOriginX += upDownButtonsWidth;
        
        [self setupSliderWithFrame:CGRectMake(itemOriginX,5.0, todoItemSliderWidth, 10.0)];
        itemOriginX += (todoItemButtonWidth + todoItemButtonMargin);
        
        [self setupLabelWithFrame:CGRectMake((itemOriginX),0,todoItemLabelWidth, (frame.size.height))];
        itemOriginX += todoItemLabelWidth;
        
        
        [self setupDeleteButtonWithFrame:CGRectMake(itemOriginX, todoItemButtonMargin, todoItemButtonWidth, todoItemButtonHeight)];
        
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


-(void)upButtonPressed {
    NSLog(@"UP");
    if (self.upCallback){
        self.upCallback(self);
    }
}
-(void)downButtonPressed{
    NSLog(@"Down");
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
