//
//  TodoItem.h
//  todos
//
//  Created by Alexandra Berke on 8/19/13.
//  Copyright (c) 2013 Alexandra Berke. All rights reserved.
//

#import <Foundation/Foundation.h>



@protocol TodoItem <NSObject>

@property NSString *itemString;

@end

typedef BOOL(^ItemCallback)(NSObject<TodoItem>* item);