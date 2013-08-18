//
//  todosViewController.m
//  todos
//
//  Created by Alexandra Berke on 8/15/13.
//  Copyright (c) 2013 Alexandra Berke. All rights reserved.
//

#import "todosViewController.h"
#import <QuartzCore/QuartzCore.h>

#import "constants.h"

@interface todosViewController ()

@end

@implementation todosViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 60, 320, 375)];
        self.containerView.layer.borderColor = [UIColor blueColor].CGColor;
        self.containerView.layer.borderWidth = 1.0f;
        
        [self setupDoneTodos];
        [self setupUndoneTodos];
        
        
        
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) setupDoneTodos {
    [self setupDoneCountLabel];
}


- (void) setupUndoneTodos {
    [self setupUndoneCountLabel];
    
    self.undoneItems = [[NSMutableArray alloc] init];
    
    self.undoneTodosArea = [[UIScrollView alloc] initWithFrame:CGRectMake(175, 40, undoneTodosAreaContentWidth, 300)];
    self.undoneTodosArea.layer.borderWidth = 2;
    self.undoneTodosArea.layer.borderColor = [UIColor redColor].CGColor;
    self.undoneTodosArea.backgroundColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.5];
    [self.view addSubview:self.undoneTodosArea];
    
    CGSize sViewContentSize = CGSizeMake(undoneTodosAreaContentWidth, 10);
    [self.undoneTodosArea setContentSize:sViewContentSize];
    
    [self.containerView addSubview:self.undoneTodosArea];
}
- (void) redrawUndoneTodos:(UIScrollView *) scrollView {
    // set scroll view height to match content
    CGFloat scrollViewHeight = 5.0f;
    
    for(int i = 0; i < self.undoneCount; i++){
        scrollViewHeight += (todoItemMargin + todoItemHeight);
        
        UILabel *label =  [[UILabel alloc] initWithFrame: CGRectMake(todoItemMargin, (todoItemMargin + (todoItemMargin+todoItemHeight)*i),todoItemWidth, todoItemHeight)];
        label.text = [self.undoneItems objectAtIndex:i];
        [scrollView addSubview:label];
    }
    // set content size of scroll view
    [scrollView setContentSize:(CGSizeMake(undoneTodosAreaContentWidth, scrollViewHeight))];
    
    [self updateUndoneCountLabel];
}

- (void) addTodo:(NSString *)todoString{
    self.undoneCount ++;
    [self.undoneItems addObject:todoString];
    [self redrawUndoneTodos:self.undoneTodosArea];
}
- (void) updateDoneCountLabel {
    self.doneCountLabel.text = [NSString stringWithFormat:@"%i", self.doneCount];
}

- (void) updateUndoneCountLabel {
    self.undoneCountLabel.text = [NSString stringWithFormat:@"%i", self.undoneCount];
}
- (void) setupDoneCountLabel {
    self.doneCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(5.0f, 5.0f, 130.0f, 30.0f)];
    self.doneCountLabel.textColor = [UIColor greenColor];
    self.doneCountLabel.textAlignment = NSTextAlignmentCenter;
    [self.containerView addSubview:self.doneCountLabel];
    [self updateDoneCountLabel];
}

- (void)setupUndoneCountLabel {
    self.undoneCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(185.0f, 5.0f, 130.0f, 30.0f)];
    self.undoneCountLabel.textColor = [UIColor redColor];
    self.undoneCountLabel.textAlignment = NSTextAlignmentCenter;
    [self.containerView addSubview:self.undoneCountLabel];
    [self updateUndoneCountLabel];
}








@end
