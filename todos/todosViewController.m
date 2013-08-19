//
//  todosViewController.m
//  todos
//
//  Created by Alexandra Berke on 8/15/13.
//  Copyright (c) 2013 Alexandra Berke. All rights reserved.
//

#import "todosViewController.h"
#import "undoneTodoItem.h"
#import "TodoItem.h"
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
        // TAKE OUT AFTER DEBUGGING ####
        [self debugMakeViewVisible:self.containerView];

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
- (void) debugMakeViewVisible:(UIView *)view {
    view.layer.borderColor = [UIColor blueColor].CGColor;
    view.layer.borderWidth = 1.0f;
    
}
- (void) setupDoneTodos {
    [self setupDoneCountLabel];

    self.doneItems = [[NSMutableArray alloc] init];
    
    self.doneTodosArea = [[UIScrollView alloc] initWithFrame:CGRectMake(5, 40, todosAreaContentWidth, 300)];
    self.doneTodosArea.layer.borderWidth = 2;
    self.doneTodosArea.layer.borderColor = [UIColor greenColor].CGColor;
    self.doneTodosArea.backgroundColor = [UIColor colorWithRed:0 green:1 blue:0 alpha:0.5];
    [self.view addSubview:self.doneTodosArea];
    
    [self.doneTodosArea setContentSize:CGSizeMake(todosAreaContentWidth, 10)];
    
    [self.containerView addSubview:self.doneTodosArea];
}

- (void) setupUndoneTodos {
    [self setupUndoneCountLabel];
    
    self.undoneItems = [[NSMutableArray alloc] init];
    
    self.undoneTodosArea = [[UIScrollView alloc] initWithFrame:CGRectMake(175, 40, todosAreaContentWidth, 300)];
    self.undoneTodosArea.layer.borderWidth = 2;
    self.undoneTodosArea.layer.borderColor = [UIColor redColor].CGColor;
    self.undoneTodosArea.backgroundColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.5];
    [self.view addSubview:self.undoneTodosArea];
    
    [self.undoneTodosArea setContentSize:CGSizeMake(todosAreaContentWidth, 10)];
    
    [self.containerView addSubview:self.undoneTodosArea];
}
- (void) redrawTodos:(UIScrollView *) scrollView withTodosArray:(NSMutableArray *)todosArray {
    // set scroll view height to match content
    CGFloat scrollViewHeight = 5.0f;
    
    // setup rectangle to be reused as frame for todos
    CGRect todoItemRect = CGRectMake(todoItemMargin, todoItemMargin,todoItemWidth, todoItemHeight);
    
    BOOL (^itemDoneCallback)(NSObject<TodoItem>*_weak) = ^(NSObject<TodoItem>* item){
        NSLog(@"Calling done callback with item with itemString: %@", item.itemString);
        return YES;
    };
    BOOL (^itemDeleteCallback)(NSObject<TodoItem>*_weak) = ^(NSObject<TodoItem>* item){
        NSLog(@"Calling delete callback with item with itemString: %@", item.itemString);
        return YES;
    };
    
    // remove all the old views
    for(UIView *subview in [scrollView subviews]) {
        [subview removeFromSuperview];
    }
    
    for(int i = 0; i < self.undoneCount; i++){
        scrollViewHeight += (todoItemMargin + todoItemHeight);
        
        undoneTodoItem *item =  [[undoneTodoItem alloc] initWithFrame: todoItemRect withString:[self.undoneItems objectAtIndex:i] withDoneCallback:itemDoneCallback withDeleteCallback:itemDeleteCallback];
        [scrollView addSubview:item];
        
        // make sure next label positioned below last
        todoItemRect.origin.y += (todoItemHeight + todoItemMargin);
    }
    // set content size of scroll view
    [scrollView setContentSize:(CGSizeMake(todosAreaContentWidth, scrollViewHeight))];
    
    
}


- (void) redrawDoneTodos:(UIScrollView *) scrollView {
    [self redrawTodos:scrollView withTodosArray:self.doneItems];
}
- (void) redrawUndoneTodos:(UIScrollView *) scrollView {
    [self redrawTodos:scrollView withTodosArray:self.undoneItems];
}

- (void) addTodo:(NSString *)todoString{
    self.undoneCount ++;
    [self updateUndoneCountLabel];
    
   
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

// callbacks for undone todos
- (BOOL)undoneTodoItemDoneCallback:(undoneTodoItem *)item {
    if(item){
        
        
        
        
        return YES;
    }
    return NO;
}

- (BOOL)undoneTodoItemDeleteCallback:(undoneTodoItem *)item {
    if(item){
        
        
        return YES;
    }
    return NO;
}






@end
