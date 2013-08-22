//
//  MainViewController.m
//  todos
//
//  Created by Alexandra Berke on 8/14/13.
//  Copyright (c) 2013 Alexandra Berke. All rights reserved.
//

#import "MainViewController.h"
#import "todosViewController.h"
#import "TodoUIColors.h"
#import <QuartzCore/QuartzCore.h>

@interface MainViewController ()

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) todosViewController *todosViewController;

@end


@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    
    /* set up where items go */
    float labelX = 10.0f;
    float labelY = 15.0f;
    float labelWidth = 55.0f;
    float labelHeight = 30.0f;
    
    float textFieldX = labelX + labelWidth + 10.0f;
    float textFieldY = labelY;
    float textFieldWidth = 230.0f;
    float textFieldHeight = labelHeight;
    
    /******* set up label *******************/
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(labelX, labelY, labelWidth, labelHeight)];
    label.text = @"+ Add:";
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor mediumBlueColor];
    [self.view addSubview:label];
    
    
    /***** setting up textField below ********/
    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(textFieldX, textFieldY, textFieldWidth, textFieldHeight)];
    self.textField.delegate = self;
    self.textField.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:self.textField];
    /***** setting up textField above ********/
    
    /* style */
    self.view.layer.backgroundColor = [UIColor backgroundYellowColor].CGColor;
    
    /************************************************************/
    self.todosViewController = [[todosViewController alloc] init];
    [self.view addSubview:self.todosViewController.containerView];
    
}

- (void) textFieldReturned{
    NSString *newItem = self.textField.text;
    if([newItem length] > 0){
        [self.todosViewController addTodo:newItem];
        // erase old item
        self.textField.text = @"";
    }
}
- (BOOL) textFieldShouldReturn: (UITextField *)textField{
    //tells the operating system to remove keyboard from forefront
    [textField resignFirstResponder];
    [self textFieldReturned];
    //returns NO. Instead of adding a line break, the text field resigns
    return NO;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
