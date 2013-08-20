//
//  todosViewController.m
//  todos
//
//  Created by Alexandra Berke on 8/15/13.
//  Copyright (c) 2013 Alexandra Berke. All rights reserved.
//

#import "todosViewController.h"
#import "undoneTodoItem.h"
#import "DoneTodoItem.h"
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
        self.containerView = [[UIView alloc] initWithFrame:CGRectMake(todosContainerOriginX, todosContainerOriginY, todosContainerWidth, todosContainerHeight)];
        // TAKE OUT AFTER DEBUGGING ####
        [self debugMakeViewVisible:self.containerView];
        
        [self setupCallbacks];
        [self setupTodos];
        
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
    [self redrawTodos];
        
    return YES;
}
- (BOOL) deleteTodoItem:(NSObject<TodoItem> *)item{
    NSLog(@"Calling delete callback with item with itemString: %@", item.itemString);
    
    self.undoneCount --;
    [self.undoneItems removeObject:item.itemString];
    [self redrawTodos];
    
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


- (void) setupTodos{
    float countLabelWidth = (todosAreaContentWidth)/2;
    // setup labels
    [self setupDoneCountLabelWithFrame:CGRectMake(todosAreaMargin, 0, countLabelWidth, 30.0f)];
    [self setupUndoneCountLabelWithFrame:CGRectMake(countLabelWidth+todosAreaMargin, 0, countLabelWidth, 30.0f)];
    
    // setup arrays
    self.doneItems = [[NSMutableArray alloc] init];
    self.undoneItems = [[NSMutableArray alloc] init];
    
    // setup todos area
    self.todosArea = [[UIScrollView alloc] initWithFrame:CGRectMake(todosAreaMargin, 30.0f, todosAreaContentWidth, todosAreaContentHeight)];
    self.todosArea.layer.borderWidth = 2;
    self.todosArea.layer.borderColor = [UIColor brownColor].CGColor;
    [self.containerView addSubview:self.todosArea];
    
}
- (void) redrawTodos{
    // set scroll view height to match content
    CGFloat scrollViewHeight = 5.0f;
    
    // setup rectangle to be reused as frame for todos
    CGRect todoItemRect = CGRectMake(todoItemMargin, todoItemMargin,todoItemWidth, todoItemHeight);
    
    // remove all the old views
    for(UIView *subview in [self.todosArea subviews]) {
        [subview removeFromSuperview];
    }
    
    // add the done todos
    for(int i = 0; i < [self.doneItems count]; i++){
        scrollViewHeight += (todoItemMargin + todoItemHeight);
        
        DoneTodoItem *item = [[DoneTodoItem alloc] initWithFrame: todoItemRect withString:[self.doneItems objectAtIndex:i]];
        
        [self.todosArea addSubview:item];
        
        // make sure next label positioned below last
        todoItemRect.origin.y += (todoItemHeight + todoItemMargin);
    }
    // add the undone todos
    for(int i = 0; i < [self.undoneItems count]; i++){
        scrollViewHeight += (todoItemMargin + todoItemHeight);
        
        undoneTodoItem *item = [[undoneTodoItem alloc] initWithFrame: todoItemRect withString:[self.undoneItems objectAtIndex:i] withDoneCallback:self.itemDoneCallback withDeleteCallback:self.itemDeletedCallback];
         
        [self.todosArea addSubview:item];
        
        // make sure next label positioned below last
        todoItemRect.origin.y += (todoItemHeight + todoItemMargin);
    }
    // set content size of scroll view
    [self.todosArea setContentSize:(CGSizeMake(todosAreaContentWidth, scrollViewHeight))];
    
}


- (void) addTodo:(NSString *)todoString{
    self.undoneCount ++;
    [self updateUndoneCountLabel];
    
   
    [self.undoneItems addObject:todoString];
    [self redrawTodos];
}
- (void) updateDoneCountLabel {
    self.doneCountLabel.text = [NSString stringWithFormat:@"Done: %i", self.doneCount];
}

- (void) updateUndoneCountLabel {
    self.undoneCountLabel.text = [NSString stringWithFormat:@"Undone: %i", self.undoneCount];
}
- (void) setupDoneCountLabelWithFrame:(CGRect)frame {
    self.doneCountLabel = [[UILabel alloc] initWithFrame:frame];
    self.doneCountLabel.textColor = [UIColor greenColor];
    self.doneCountLabel.textAlignment = NSTextAlignmentCenter;
    [self.containerView addSubview:self.doneCountLabel];
    [self updateDoneCountLabel];
}

- (void)setupUndoneCountLabelWithFrame:(CGRect)frame {
    self.undoneCountLabel = [[UILabel alloc] initWithFrame:frame];
    self.undoneCountLabel.textColor = [UIColor redColor];
    self.undoneCountLabel.textAlignment = NSTextAlignmentCenter;
    [self.containerView addSubview:self.undoneCountLabel];
    [self updateUndoneCountLabel];
}






@end
