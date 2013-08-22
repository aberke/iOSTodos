//
//  TodoUIColors.m
//  todos
//
//  Created by Alexandra Berke on 8/21/13.
//  Copyright (c) 2013 Alexandra Berke. All rights reserved.
//

#import "TodoUIColors.h"


@implementation UIColor (TodoUIColors)

+ (UIColor *)backgroundYellowColor{
    return [UIColor colorWithRed:1.0 green:1.0 blue:(153.0/255.0) alpha:1.0];
}
+(UIColor *)lightBlueColor{
    return [UIColor colorWithRed:(224.0/255) green:(255.0/255) blue:(255.0/255) alpha:1.0];
}
+(UIColor *)mediumBlueColor{
    return [UIColor colorWithRed:(72.0/255) green:(209.0/255) blue:(204.0/255) alpha:1.0];
}

@end
