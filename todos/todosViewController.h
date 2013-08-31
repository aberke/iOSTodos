//
//  todosViewController.h
//  todos
//
//  Created by Alexandra Berke on 8/15/13.
//  Copyright (c) 2013 Alexandra Berke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TodoItem.h"


@interface todosViewController : UIViewController

@property (nonatomic, copy) ItemCallback itemDoneCallback;
@property (nonatomic, copy) ItemCallback itemDeletedCallback;
@property (nonatomic, copy) ItemCallback itemUpCallback;
@property (nonatomic, copy) ItemCallback itemDownCallback;

@property (nonatomic, strong) UIView *containerView;

@property int undoneCount;
@property (nonatomic, strong) NSMutableArray *undoneItems; // array of TodoEntry's

@property int doneCount;
@property (nonatomic, strong) NSMutableArray *doneItems; // array of TodoEntry's


@property (nonatomic, strong) UIScrollView *todosArea;

- (void) addUndoneTodo:(NSString *)todoString;
- (void) addDoneTodo:(NSString *)todoString;

@end
