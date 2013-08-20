//
//  undoneTodoItem.h
//  todos
//
//  Created by Alexandra Berke on 8/18/13.
//  Copyright (c) 2013 Alexandra Berke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TodoItem.h"

@interface undoneTodoItem : UIView <TodoItem>

@property (nonatomic, copy) ItemCallback doneCallback;
@property (nonatomic, copy) ItemCallback deletedCallback;


@property NSString *itemString;

- (id)initWithFrame:(CGRect)frame withString:(NSString *)itemString withDoneCallback:(BOOL(^)(NSObject<TodoItem>*))doneCallback withDeleteCallback:(BOOL(^)(NSObject<TodoItem>*))deleteCallback;

@end