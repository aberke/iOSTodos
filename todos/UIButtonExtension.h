//
//  UIButtonExtension.h
//  todos
//
//  Created by Alexandra Berke on 8/22/13.
//  Copyright (c) 2013 Alexandra Berke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (UIButtonExtension)

+(UIButton *)buttonWithFrame:(CGRect)frame withImageName:(NSString *)imageName withCallback:(SEL)callback withTarget:(id)actionTarget;

@end
