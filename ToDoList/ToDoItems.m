//
//  ToDoItems.m
//  ToDoList
//
//  Created by Bhagyashree Shekhawat on 1/25/14.
//  Copyright (c) 2014 Bhagyashree. All rights reserved.
//

#import "ToDoItems.h"

@interface ToDoItems ()
+ (NSString *)parseClassName;
@end

@implementation ToDoItems
@dynamic todoItems;
+ (NSString *)parseClassName {
    return @"ToDoItems";
}

@end
