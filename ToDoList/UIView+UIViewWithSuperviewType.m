//
//  UIViewWithSuperviewType.m
//  ToDoList
//
//  Created by Bhagyashree Shekhawat on 1/25/14.
//  Copyright (c) 2014 Bhagyashree. All rights reserved.
//

#import "UIView+UIViewWithSuperviewType.h"

@implementation UIView (UIViewWithSuperviewType)

- (UIView *)superViewWithClass:(Class)superViewClass{

    UIView* superView = self.superview;
    UIView* superViewOfType = nil;
    while(superView != nil && superViewOfType == nil) {
        if([superView isKindOfClass:superViewClass]){
            superViewOfType = superView;
            break;
        }
        superView = superView.superview;
    }
    return superViewOfType;
}

@end
