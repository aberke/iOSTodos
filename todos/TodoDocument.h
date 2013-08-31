//
//  TodoDocument.h
//  todos
//
//  Created by Alexandra Berke on 8/26/13.
//  Copyright (c) 2013 Alexandra Berke. All rights reserved.
//

#import <UIKit/UIKit.h>

#define TODO_DONE_EXTENSION @"done"
#define TODO_UNDONE_EXTENSION @"undone"

@interface TodoDocument : UIDocument

@property (nonatomic, strong) NSString *itemString;

@property (nonatomic, strong) NSFileWrapper *fileWrapper;


@end
