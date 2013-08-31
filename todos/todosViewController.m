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

#import "TodoEntry.h"
#import "TodoDocument.h"

@interface todosViewController () {
    UILabel *_undoneCountLabel;
    UILabel *_doneCountLabel;
    
    NSURL *_localRoot;
}

@end

@implementation todosViewController

#pragma mark Helpers

- (NSURL *)localRoot {
    if (_localRoot != nil) {
        return _localRoot;
    }
    NSArray * paths = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    _localRoot = [paths objectAtIndex:0];
    return _localRoot;
}
- (NSURL *)getDocURL:(NSString *)filename {
    return [self.localRoot URLByAppendingPathComponent:filename];
}
- (BOOL)docNameExistsInTodoItems:(NSString *)docName {
    BOOL nameExists = NO;
    for (TodoEntry * entry in self.undoneItems) {
        if ([[entry.fileURL lastPathComponent] isEqualToString:docName]) {
            nameExists = YES;
            break;
        }
    }
    for (TodoEntry * entry in self.doneItems) {
        if ([[entry.fileURL lastPathComponent] isEqualToString:docName]) {
            nameExists = YES;
            break;
        }
    }
    return nameExists;
}
- (NSString*)getDocFilename:(NSString *)prefix withExtension:(NSString *)extension{
    
    NSInteger docCount = 0;
    NSString* newDocName = [NSString stringWithFormat:@"%@.%@", prefix, extension];
    // Look for an existing document with the same name. If one is found, increment docCount; try again.
    while ([self docNameExistsInTodoItems:newDocName]) {
        docCount++;
        newDocName = [NSString stringWithFormat:@"%@-%d.%@", prefix, docCount, extension];
    }
    return newDocName;
}
- (int)indexOfUndoneEntryWithItemString:(NSString *)itemString {
    __block int retval = -1;
    [self.undoneItems enumerateObjectsUsingBlock:^(TodoEntry * entry, NSUInteger idx, BOOL *stop) {
        if ([entry.itemString isEqual:itemString]) {
            retval = idx;
            *stop = YES;
        }
    }];
    return retval;
}
- (int)indexOfDoneEntryWithItemString:(NSString *)itemString {
    __block int retval = -1;
    [self.doneItems enumerateObjectsUsingBlock:^(TodoEntry * entry, NSUInteger idx, BOOL *stop) {
        if ([entry.itemString isEqual:itemString]) {
            retval = idx;
            *stop = YES;
        }
    }];
    return retval;
}

# pragma mark setup

- (void) setupCallbacks {
    todosViewController * __weak weakSelf = self;
    // use weakself in blocks to avoid strong reference cycles
    self.itemDoneCallback = ^(TodoItem *item){
        return [weakSelf completeTodoItem:item];
    };
    self.itemDeletedCallback = ^(TodoItem *item){
        return [weakSelf deleteTodoItem:item];
    };
    self.itemUpCallback = ^(TodoItem *item){
        return [weakSelf moveUpTodoItem:item];
    };
    self.itemDownCallback = ^(TodoItem *item){
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

#pragma mark View lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.containerView = [[UIView alloc] initWithFrame:CGRectMake(todosContainerOriginX, todosContainerOriginY, todosContainerWidth, todosContainerHeight)];
        self.containerView.layer.backgroundColor = [UIColor backgroundYellowColor].CGColor;
        
        [self setupCallbacks];
        [self setupTodos];
        [self refresh];
        
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
#pragma mark File management methods

- (void)loadDocAtURL:(NSURL *)fileURL asDone:(BOOL)done{
    // Open doc so we can read data
    TodoDocument * doc = [[TodoDocument alloc] initWithFileURL:fileURL];
    [doc openWithCompletionHandler:^(BOOL success) {
        // Check status
        if (!success) {
            NSLog(@"Failed to open %@", fileURL);
            return;
        }
        // Preload data on background thread
        NSString *itemString = doc.itemString;
        NSLog(@"Loaded File URL: %@", [doc.fileURL lastPathComponent]);        
        // Close since we're done with it
        [doc closeWithCompletionHandler:^(BOOL success) {
            
            // Check status
            if (!success) NSLog(@"Failed to close %@", fileURL); // Continue anyway...
            
            // Add to the list of files on main thread
            dispatch_async(dispatch_get_main_queue(), ^{
                if (!done) [self addUndoneEntryWithFileURL:fileURL itemString:itemString];
                else [self addDoneEntryWithFileURL:fileURL itemString:itemString];
            });
        }];
    }];
}
- (BOOL) moveUpTodoItem:(TodoItem *)item{
    NSUInteger index = [self.undoneItems indexOfObject:item.itemString];
    if(([self.undoneItems count] < 2) || index == NSNotFound || (index == 0)){
        return NO;
    }
    [self.undoneItems exchangeObjectAtIndex:index withObjectAtIndex:index-1];
    [self redrawTodos];
    return YES;
}
- (BOOL) moveDownTodoItem:(TodoItem *)item{
    NSUInteger index = [self.undoneItems indexOfObject:item.itemString];
    if(([self.undoneItems count] < 2) || index == NSNotFound || (index > ([self.undoneItems count] - 2))){
        return NO;
    }
    [self.undoneItems exchangeObjectAtIndex:index withObjectAtIndex:index+1];
    [self redrawTodos];
    return YES;
}
- (id) removeDoneEntryWithString:(NSString *)itemString{
    int index = [self indexOfDoneEntryWithItemString:itemString];
    if (index < 0) return nil;
    TodoEntry *entry = [self.doneItems objectAtIndex:index];
    
    [self.doneItems removeObject:entry];
    return entry;
}
- (id) removeUndoneEntryWithString:(NSString *)itemString{
    int index = [self indexOfUndoneEntryWithItemString:itemString];
    if (index < 0) return nil;
    TodoEntry *entry = [self.undoneItems objectAtIndex:index];
    
    [self.undoneItems removeObject:entry];
    return entry;
}

- (BOOL) deleteTodoItem:(TodoItem *)item{
    TodoEntry *entry;
    
    if ([item isMemberOfClass:[undoneTodoItem class]]){
        if ((entry = [self removeUndoneEntryWithString:item.itemString]) == nil) return NO;
    }
    else if ([item isMemberOfClass:[DoneTodoItem class]]){
        if ((entry = [self removeDoneEntryWithString:item.itemString]) == nil) return NO;
    }
    else {
        return NO;
    }
    NSFileManager* fileManager = [[NSFileManager alloc] init];
    [fileManager removeItemAtURL:entry.fileURL error:nil];
    
    [self redrawTodos];
    [self updateCountLabels];
    return YES;
}
- (BOOL) completeTodoItem:(TodoItem *)item{
    TodoEntry *entry;
    
    if (![item isMemberOfClass:[undoneTodoItem class]]){
        NSLog(@"ERROR");
        return NO;
    }
    // delete old todo
    if ((entry = [self removeUndoneEntryWithString:item.itemString]) == nil) return NO;
    
    NSFileManager* fileManager = [[NSFileManager alloc] init];
    [fileManager removeItemAtURL:entry.fileURL error:nil];
    
    [self addDoneTodo:item.itemString];
    
    [self redrawTodos];
    [self updateCountLabels];
    return YES;
}
- (void) addDoneTodo:(NSString *)itemString{
    // Determine a unique filename to create
    NSURL * fileURL = [self getDocURL:[self getDocFilename:itemString withExtension:TODO_DONE_EXTENSION]];
    [self createTodoWithFileURL:fileURL withString:itemString];
    [self addDoneEntryWithFileURL:fileURL itemString:itemString];
}
- (void) addUndoneTodo:(NSString *)itemString{
    // Determine a unique filename to create
    NSURL * fileURL = [self getDocURL:[self getDocFilename:itemString withExtension:TODO_UNDONE_EXTENSION]];
    [self createTodoWithFileURL:fileURL withString:itemString];
    [self addUndoneEntryWithFileURL:fileURL itemString:itemString];
}


- (void)createTodoWithFileURL:(NSURL *)fileURL withString:(NSString *)todoString {
    NSLog(@"Want to create file at %@", fileURL);
    
    // Create new document and save to the filename
    TodoDocument * doc = [[TodoDocument alloc] initWithFileURL:fileURL];
    [doc setItemString:todoString];
    NSLog(@"0");
    ///*
    [doc saveToURL:fileURL forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
        
        if (!success) {
            NSLog(@"Failed to create file at %@", fileURL);
            return;
        }
        
        NSLog(@"File created at %@", fileURL);
    }];//*/
}
#pragma mark Refresh Methods

- (void) refresh {
    [self.doneItems removeAllObjects];
    [self.undoneItems removeAllObjects];
    // load local
    NSArray * localDocuments = [[NSFileManager defaultManager] contentsOfDirectoryAtURL:self.localRoot includingPropertiesForKeys:nil options:0 error:nil];
    NSLog(@"Found %d local files.", localDocuments.count);
    for (int i=0; i < localDocuments.count; i++) {
        
        NSURL * fileURL = [localDocuments objectAtIndex:i];
        if ([[fileURL pathExtension] isEqualToString:TODO_UNDONE_EXTENSION]) {
            NSLog(@"Found local UNDONE file: %@", fileURL);
            [self loadDocAtURL:fileURL asDone:NO];
        }
        else if ([[fileURL pathExtension] isEqualToString:TODO_DONE_EXTENSION]) {
            NSLog(@"Found local DONE file: %@", fileURL);
            [self loadDocAtURL:fileURL asDone:YES];
        }
    }
}
# pragma mark entry methods
- (void)addUndoneEntryWithFileURL:(NSURL *)fileURL itemString:(NSString *)itemString{
    
    TodoEntry *entry = [[TodoEntry alloc] initWithFileURL:fileURL itemString:itemString];
    [self.undoneItems addObject:entry];
    
    [self redrawTodos];
    [self updateCountLabels];
}
- (void)addDoneEntryWithFileURL:(NSURL *)fileURL itemString:(NSString *)itemString{
    
    TodoEntry *entry = [[TodoEntry alloc] initWithFileURL:fileURL itemString:itemString];
    [self.doneItems addObject:entry];
    
    [self redrawTodos];
    [self updateCountLabels];
}

#pragma mark drawing

- (id)createDoneTodoItemWithFrame:(CGRect)frame withString:(NSString *)string{
    DoneTodoItem *item = [[DoneTodoItem alloc] initWithFrame: frame withString:string];
    // configure callbacks
    [item setDeletedCallback:self.itemDeletedCallback];
    return item;
}
- (id)createUndoneTodoItemWithFrame:(CGRect)frame withString:(NSString *)string{
    undoneTodoItem *item = [[undoneTodoItem alloc] initWithFrame: frame withString:string];
    // configure callbacks
    [item setDeletedCallback:self.itemDeletedCallback];
    [item setDoneCallback:self.itemDoneCallback];
    [item setUpCallback:self.itemUpCallback];
    [item setDownCallback:self.itemDownCallback];
    
    return item;
}
- (void) redrawTodos{
    NSLog(@"redrawTodos");
    // setup rectangle to be reused as frame for todos
    CGRect todoItemRect = CGRectMake(0, 0,todoItemWidth, doneTodoItemHeight);
    
    // remove all the old views
    for(UIView *subview in [self.todosArea subviews]) {
        [subview removeFromSuperview];
    }
    
    // add the done todos
    for(int i = 0; i < [self.doneItems count]; i++){
        NSString *itemString = [[self.doneItems objectAtIndex:i] itemString];
        
        DoneTodoItem *item = [self createDoneTodoItemWithFrame: todoItemRect withString:itemString];
        [self.todosArea addSubview:item];
        
        // make sure next label positioned below last
        todoItemRect.origin.y += [item height];
    }
    todoItemRect = CGRectMake(0, todoItemRect.origin.y,todoItemWidth, undoneTodoItemHeight);
    
    // add the undone todos
    for(int i = 0; i < [self.undoneItems count]; i++){
        NSString *itemString = [[self.undoneItems objectAtIndex:i] itemString];
        NSLog(@"undoneItems itemString: %@",itemString);
        undoneTodoItem *item = [self createUndoneTodoItemWithFrame:todoItemRect withString:itemString];
        [self.todosArea addSubview:item];
        
        // make sure next label positioned below last
        todoItemRect.origin.y += [item height];
    }
    // set content size of scroll view
    [self.todosArea setContentSize:CGSizeMake(todosAreaContentWidth, todoItemRect.origin.y)];
}
# pragma mark handle count labels

- (void) updateCountLabels {
    self.undoneCount = [self.undoneItems count];
    self.doneCount = [self.doneItems count];
    [self updateDoneCountLabel];
    [self updateUndoneCountLabel];
}

- (void) updateDoneCountLabel {
    _doneCountLabel.text = [NSString stringWithFormat:@"Done: %i", self.doneCount];
}

- (void) updateUndoneCountLabel {
    _undoneCountLabel.text = [NSString stringWithFormat:@"Undone: %i", self.undoneCount];
}
-(UILabel *) stylizeCountLabelWithFrame:(CGRect)frame{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    return label;
}
- (void) setupDoneCountLabelWithFrame:(CGRect)frame {
    _doneCountLabel = [self stylizeCountLabelWithFrame:frame];
    _doneCountLabel.textColor = [UIColor brownColor];
    [self.containerView addSubview:_doneCountLabel];
    [self updateDoneCountLabel];
}

- (void)setupUndoneCountLabelWithFrame:(CGRect)frame {
    _undoneCountLabel = [self stylizeCountLabelWithFrame:frame];
    _undoneCountLabel.textColor = [UIColor redColor];
    [self.containerView addSubview:_undoneCountLabel];
    [self updateUndoneCountLabel];
}






@end
