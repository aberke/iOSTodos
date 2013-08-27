//
//  TodoDocument.h
//  todos
//
//  Created by Alexandra Berke on 8/26/13.
//  Copyright (c) 2013 Alexandra Berke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TodoDocument : UIDocument

- (NSString *)itemString;
- (void)setItemString:(NSString *)itemString;

@end
