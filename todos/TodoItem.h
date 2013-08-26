//
//  TodoItem.h
//  todos
//
//  Created by Alexandra Berke on 8/25/13.
//  Copyright (c) 2013 Alexandra Berke. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TodoItem;


typedef BOOL(^ItemCallback)(TodoItem *item);


@interface TodoItem : UIView

@property (nonatomic, copy) ItemCallback deletedCallback;

@property NSString *itemString;
- (void) deleteItem;
- (id)initWithFrame:(CGRect)frame withString:(NSString *)itemString;

@end