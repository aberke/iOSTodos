//
//  DoneTodoItem.h
//  todos
//
//  Created by Alexandra Berke on 8/19/13.
//  Copyright (c) 2013 Alexandra Berke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TodoItem.h"

@interface DoneTodoItem : TodoItem

@property NSString *itemString;

- (id)initWithFrame:(CGRect)frame withString:(NSString *)itemString;

@end
