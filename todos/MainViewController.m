//
//  MainViewController.m
//  todos
//
//  Created by Alexandra Berke on 8/14/13.
//  Copyright (c) 2013 Alexandra Berke. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UILabel *unDoneCountLabel;
@property int unDoneCount;

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
    float textFieldX = 10.0f;
    float textFieldY = 20.0f;
    float textFieldWidth = 230.0f;
    float textFieldHeight = 30.0f;
    
    float buttonX = textFieldX + textFieldWidth + 10.0f;
    float buttonWidth = 60.0f;
    
    float labelX = textFieldX;
    float labelY = textFieldY + textFieldHeight + 10.0f;
    float labelWidth = textFieldWidth;
    float labelHeight = 40.0f;
    
    
    self.unDoneCount = 0;
    
    /***** setting up textField below ********/
    
    /*
     "CGRectMake" creates the frame with (x,y,width,height) where x and y are are pixel distances from the top left of the screen
     */
    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(textFieldX, textFieldY, textFieldWidth, textFieldHeight)];
    self.textField.delegate = self;
    self.textField.borderStyle = UITextBorderStyleRoundedRect;
    
    /*
     Note: UITextField (along with a number of other UI classes are subclasses of UIView, which means they can be added onto the view hierarchy
     */
    [self.view addSubview:self.textField];
    
    /***** setting up textField above ********/
    /************************************************************/
    /***** setting up button below ********/
    
    //initialize the button with the default, rounded rect type
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(buttonX, textFieldY, buttonWidth, textFieldHeight);
    //set the target, action, and control event.
    [button addTarget:self action:@selector(buttonPressed) forControlEvents:(UIControlEventTouchUpInside)];
    // set title and add to main view
    [button setTitle:@"+ Add" forState:UIControlStateNormal];
    [self.view addSubview:button];
    
    /***** setting up button above ********/
    /************************************************************/
    /***** setting up label below ********/
    self.unDoneCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelX, labelY, labelWidth, labelHeight)];
    [self updateUnDoneCountLabel];
    [self.view addSubview:self.unDoneCountLabel];
    /***** setting up label above ********/

}
- (void) updateUnDoneCountLabel {
    self.unDoneCountLabel.text = [NSString stringWithFormat:@"%i", self.unDoneCount];
}
- (void) buttonPressed{
    self.unDoneCount ++;
    [self updateUnDoneCountLabel];
}
- (BOOL) textFieldShouldReturn: (UITextField *)textField{
    //this tells the operating system to remove the keyboard from the forefront
    [textField resignFirstResponder];
    //returns NO. Instead of adding a line break, the text field resigns
    return NO;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
