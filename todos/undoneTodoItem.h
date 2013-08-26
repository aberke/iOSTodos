//
//  undoneTodoItem.h
//  todos
//
//  Created by Alexandra Berke on 8/18/13.
//  Copyright (c) 2013 Alexandra Berke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TodoItem.h"
//#import "Constants.h"

@interface undoneTodoItem : TodoItem

@property (nonatomic, copy) ItemCallback doneCallback;
@property (nonatomic, copy) ItemCallback upCallback;
@property (nonatomic, copy) ItemCallback downCallback;


@property NSString *itemString;

- (id)initWithFrame:(CGRect)frame withString:(NSString *)itemString;

- (id)initWithFrame:(CGRect)frame withString:(NSString *)itemString withDoneCallback:(BOOL(^)(TodoItem *))doneCallback withDeleteCallback:(BOOL(^)(TodoItem *))deleteCallback;


@end
