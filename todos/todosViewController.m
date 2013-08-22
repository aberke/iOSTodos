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
#import "TodoUIColors.h"
#import <QuartzCore/QuartzCore.h>
#import "Constants.h"

@interface todosViewController ()

@end

@implementation todosViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.containerView = [[UIView alloc] initWithFrame:CGRectMake(todosContainerOriginX, todosContainerOriginY, todosContainerWidth, todosContainerHeight)];
        self.containerView.layer.backgroundColor = [UIColor backgroundYellowColor].CGColor;
        self.containerView.layer.borderColor = [UIColor brownColor].CGColor;
        
        [self setupCallbacks];
        [self setupTodos];
        
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL) completeTodoItem:(NSObject<TodoItem> *)item{
    
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
    
    self.undoneCount --;
    [self updateUndoneCountLabel];
    [self.undoneItems removeObject:item.itemString];
    [self redrawTodos];
    
    return YES;
}
- (BOOL) moveUpTodoItem:(NSObject<TodoItem> *)item{
    NSUInteger index = [self.undoneItems indexOfObject:item.itemString];
    if(([self.undoneItems count] < 2) || index == NSNotFound || (index == 0)){
        return NO;
    }
    [self.undoneItems exchangeObjectAtIndex:index withObjectAtIndex:index-1];
    [self redrawTodos];
    return YES;
}
- (BOOL) moveDownTodoItem:(NSObject<TodoItem> *)item{
    NSUInteger index = [self.undoneItems indexOfObject:item.itemString];
    if(([self.undoneItems count] < 2) || index == NSNotFound || (index > ([self.undoneItems count] - 2))){
        return NO;
    }
    [self.undoneItems exchangeObjectAtIndex:index withObjectAtIndex:index+1];
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
    self.itemUpCallback = ^(NSObject<TodoItem>* item){
        return [weakSelf moveUpTodoItem:item];
    };
    self.itemDownCallback = ^(NSObject<TodoItem>* item){
        return [weakSelf moveDownTodoItem:item];
    };
}


- (void) setupTodos{    
    // setup arrays
    self.doneItems = [[NSMutableArray alloc] init];
    self.undoneItems = [[NSMutableArray alloc] init];
    
    // setup labels
    [self setupDoneCountLabelWithFrame:CGRectMake(todosAreaMargin, 0, countLabelWidth, countLabelHeight)];
    [self setupUndoneCountLabelWithFrame:CGRectMake(countLabelWidth+todosAreaMargin, 0, countLabelWidth, countLabelHeight)];
    UILabel *underline = [[UILabel alloc] initWithFrame:CGRectMake(todosAreaMargin, countLabelHeight, todosAreaContentWidth, countLabelUnderlineHeight)];
    underline.backgroundColor = [UIColor brownColor];
    [self.containerView addSubview:underline];
    
    // setup todos area
    self.todosArea = [[UIScrollView alloc] initWithFrame:CGRectMake(todosAreaMargin, (countLabelUnderlineHeight + countLabelHeight), todosAreaContentWidth, todosAreaContentHeight)];
    self.todosArea.layer.backgroundColor = [UIColor backgroundYellowColor].CGColor;
    self.todosArea.layer.borderColor = [UIColor brownColor].CGColor;
    [self.containerView addSubview:self.todosArea];
    
}
- (id)createUndoneTodoItemWithFrame:(CGRect)frame withString:(NSString *)string{
   undoneTodoItem *item = [[undoneTodoItem alloc] initWithFrame: frame withString:string];
    // setup all the callbacks
    [item setDeletedCallback:self.itemDeletedCallback];
    [item setDoneCallback:self.itemDoneCallback];
    [item setUpCallback:self.itemUpCallback];
    [item setDownCallback:self.itemDownCallback];
    
    return item;
}
- (void) redrawTodos{
    
    // setup rectangle to be reused as frame for todos
    CGRect todoItemRect = CGRectMake(todoItemLabelOriginX, 0,todoItemLabelWidth, doneTodoItemHeight);
    
    // remove all the old views
    for(UIView *subview in [self.todosArea subviews]) {
        [subview removeFromSuperview];
    }
    
    // add the done todos
    for(int i = 0; i < [self.doneItems count]; i++){
        
        DoneTodoItem *item = [[DoneTodoItem alloc] initWithFrame: todoItemRect withString:[self.doneItems objectAtIndex:i]];
        [self.todosArea addSubview:item];
        
        // make sure next label positioned below last
        todoItemRect.origin.y += doneTodoItemHeight;
    }
    todoItemRect = CGRectMake(0, todoItemRect.origin.y,todoItemWidth, undoneTodoItemHeight);
    
    // add the undone todos
    for(int i = 0; i < [self.undoneItems count]; i++){
        
        undoneTodoItem *item = [self createUndoneTodoItemWithFrame:todoItemRect withString:[self.undoneItems objectAtIndex:i]];
        [self.todosArea addSubview:item];
        
        // make sure next label positioned below last
        todoItemRect.origin.y += undoneTodoItemHeight;
    }
    // set content size of scroll view
    [self.todosArea setContentSize:CGSizeMake(todosAreaContentWidth, todoItemRect.origin.y)];
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
-(UILabel *) stylizeCountLabelWithFrame:(CGRect)frame{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    return label;
}
- (void) setupDoneCountLabelWithFrame:(CGRect)frame {
    self.doneCountLabel = [self stylizeCountLabelWithFrame:frame];
    self.doneCountLabel.textColor = [UIColor brownColor];
    [self.containerView addSubview:self.doneCountLabel];
    [self updateDoneCountLabel];
}

- (void)setupUndoneCountLabelWithFrame:(CGRect)frame {
    self.undoneCountLabel = [self stylizeCountLabelWithFrame:frame];
    self.undoneCountLabel.textColor = [UIColor redColor];
    [self.containerView addSubview:self.undoneCountLabel];
    [self updateUndoneCountLabel];
}






@end
