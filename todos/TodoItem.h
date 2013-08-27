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


@interface TodoItem : UIView {
# pragma mark UIconstants
    float _labelMargin;// = 60.0f;
    float _deleteButtonSize;// = 20.0f;
    
# pragma mark UIobjects
    UILabel *_label;
}

@property (nonatomic, copy) ItemCallback deletedCallback;

@property NSString *itemString;
- (void) setupLabel;
- (void) setupDeleteButton;
- (void) deleteItem;
- (void) alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex;

#pragma mark view helper methods
- (CGFloat)height;

- (id)initWithFrame:(CGRect)frame withString:(NSString *)itemString;



@end