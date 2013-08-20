//
//  todosViewController.m
//  todos
//
//  Created by Alexandra Berke on 8/15/13.
//  Copyright (c) 2013 Alexandra Berke. All rights reserved.
//

#import "todosViewController.h"
#import "undoneTodoItem.h"
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
        
        [self setupCallbacks];

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
- (BOOL) completeTodoItem:(NSObject<TodoItem> *)item{
    NSLog(@"Calling done callback with item with itemString: %@", item.itemString);
    
    self.undoneCount --;
    self.doneCount ++;
    [self updateUndoneCountLabel];
    [self updateDoneCountLabel];
    
    [self.undoneItems removeObject:item.itemString];
    [self.doneItems addObject:item.itemString];
    [self redrawUndoneTodos];
    [self redrawDoneTodos];
        
    return YES;
}
- (BOOL) deleteTodoItem:(NSObject<TodoItem> *)item{
    NSLog(@"Calling delete callback with item with itemString: %@", item.itemString);
    
    self.undoneCount --;
    [self.undoneItems removeObject:item.itemString];
    [self redrawUndoneTodos];
    
    return YES;
}
- (void) setupCallbacks {
    // use weakself in blocks to avoid strong reference cycles
    todosViewController * __weak weakSelf = self;
    
    self.itemDoneCallback = ^(NSObject<TodoItem>* item){
        return [weakSelf completeTodoItem:item];
    };
    self.itemDeletedCallback = ^(NSObject<TodoItem>* item){
        return [weakSelf deleteTodoItem:item];
    };
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
    

    
    // remove all the old views
    for(UIView *subview in [scrollView subviews]) {
        [subview removeFromSuperview];
    }
    
    for(int i = 0; i < [todosArray count]; i++){
        scrollViewHeight += (todoItemMargin + todoItemHeight);
        
        undoneTodoItem *item =  [[undoneTodoItem alloc] initWithFrame: todoItemRect withString:[todosArray objectAtIndex:i] withDoneCallback:self.itemDoneCallback withDeleteCallback:self.itemDeletedCallback];
        [scrollView addSubview:item];
        
        // make sure next label positioned below last
        todoItemRect.origin.y += (todoItemHeight + todoItemMargin);
    }
    // set content size of scroll view
    [scrollView setContentSize:(CGSizeMake(todosAreaContentWidth, scrollViewHeight))];
    
    
}


- (void) redrawDoneTodos{
    [self redrawTodos:self.doneTodosArea withTodosArray:self.doneItems];
}
- (void) redrawUndoneTodos{
    [self redrawTodos:self.undoneTodosArea withTodosArray:self.undoneItems];
}

- (void) addTodo:(NSString *)todoString{
    self.undoneCount ++;
    [self updateUndoneCountLabel];
    
   
    [self.undoneItems addObject:todoString];
    [self redrawUndoneTodos];
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
