//
//  todosViewController.h
//  todos
//
//  Created by Alexandra Berke on 8/15/13.
//  Copyright (c) 2013 Alexandra Berke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface todosViewController : UIViewController

@property (nonatomic, strong) UIView *containerView;

@property (nonatomic, strong) UIScrollView *undoneTodosArea;
@property (nonatomic, strong) UILabel *undoneCountLabel;
@property int undoneCount;
@property (nonatomic, strong) NSMutableArray *undoneItems;

@property (nonatomic, strong) UIScrollView *doneTodos;
@property (nonatomic, strong) UILabel *doneCountLabel;
@property int doneCount;
@property (nonatomic, strong) NSMutableArray *doneItems;


- (void) addTodo:(NSString *)todoString;

@end
