//
//  UIViewWithSuperviewType.h
//  ToDoList
//
//  Created by Bhagyashree Shekhawat on 1/25/14.
//  Copyright (c) 2014 Bhagyashree. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIView (UIViewWithSuperviewType)

- (UIView *)superViewWithClass:(Class)superViewClass;

@end
