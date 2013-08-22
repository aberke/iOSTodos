//
//  UIButtonExtension.m
//  todos
//
//  Created by Alexandra Berke on 8/22/13.
//  Copyright (c) 2013 Alexandra Berke. All rights reserved.
//

#import "UIButtonExtension.h"

@implementation UIButton (UIButtonExtension)

+(UIButton *)buttonWithFrame:(CGRect)frame withImageName:(NSString *)imageName withCallback:(SEL)callback withTarget:(id)actionTarget{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    
    button.backgroundColor = [UIColor clearColor];
    [button setImage: [UIImage imageNamed:imageName] forState:UIControlStateNormal];
    
    [button addTarget:actionTarget action:callback forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

@end
