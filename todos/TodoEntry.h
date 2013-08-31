//
//  TodoEntry.h
//  todos
//
//  Created by Alexandra Berke on 8/27/13.
//  Copyright (c) 2013 Alexandra Berke. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TodoEntry : NSObject

@property (strong) NSURL *fileURL;
@property (strong) NSString *itemString;

- (id)initWithFileURL:(NSURL *)fileURL itemString:(NSString *)itemString;

@end
